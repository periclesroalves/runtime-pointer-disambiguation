//===- SpeculativeAliasAnalysis.cpp - Speculative Alias Analysis -----------==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
//
//===----------------------------------------------------------------------===//

#include "polly/SpeculativeAliasAnalysis.h"
#include "polly/LinkAllPasses.h"
#include <llvm/IR/Module.h>
#include <llvm/Transforms/Utils/FullInstNamer.h>
#include <llvm/Support/CommandLine.h>
#include <llvm/Support/YAMLTraits.h>    // for IO, Input, operator>>, etc

using namespace polly;
using namespace llvm;
using namespace llvm::yaml;

cl::OptionCategory category("Speculative alias analysis");

// Register the AliasAnalysis interface, providing a nice name to refer to.
char SpeculativeAliasAnalysis::ID = 0;
INITIALIZE_ANALYSIS_GROUP(SpeculativeAliasAnalysis, "Speculative Alias Analysis", NoSpecAA)

void SpeculativeAliasAnalysis::anchor() {}


//===----------------------------------------------------------------------===//
// Implementation using offline profiling feedback
//===----------------------------------------------------------------------===//

// must match alias types in alias_profiler.h
enum AliasType {
  NO_HEAP_ALIAS,
  NO_RANGE_ALIAS,
  EXACT_ALIAS,
};

using AliasPairs   = std::map<std::pair<std::string, std::string>, SpeculativeAliasResult>;
using AliasProfile = std::map<std::string, AliasPairs>;

struct YamlPair {
  std::string ptr1;
  std::string ptr2;
  float NO_RANGE_ALIAS;
  float NO_HEAP_ALIAS;
  float EXACT_ALIAS;
};

struct YamlProfile {
  std::string           function;
  std::vector<YamlPair> alias_pairs;
};

namespace llvm {
namespace yaml {

#define MAP_REQUIRED_FIELD(IO, VALUE, NAME) \
  (IO).mapRequired(#NAME, (VALUE).NAME)
#define MAP_OPTIONAL_FIELD(IO, VALUE, NAME, DEFAULT) \
  (IO).mapOptional(#NAME, (VALUE).NAME, (DEFAULT))

template<>
struct MappingTraits<YamlPair> {
  static void mapping(yaml::IO& io, YamlPair& value)
  {
    MAP_REQUIRED_FIELD(io, value, ptr1);
    MAP_REQUIRED_FIELD(io, value, ptr2);
    MAP_OPTIONAL_FIELD(io, value, NO_RANGE_ALIAS, 0.0f);
    MAP_OPTIONAL_FIELD(io, value, NO_HEAP_ALIAS,  0.0f);
    MAP_OPTIONAL_FIELD(io, value, EXACT_ALIAS,    0.0f);
  }
};

template<>
struct MappingTraits<YamlProfile> {
  static void mapping(IO& io, YamlProfile& value)
  {
    MAP_REQUIRED_FIELD(io, value, function);
    MAP_REQUIRED_FIELD(io, value, alias_pairs);
  }
};

} // end namespace yaml
} // end namespace llvm

LLVM_YAML_IS_SEQUENCE_VECTOR(YamlPair)
LLVM_YAML_IS_DOCUMENT_LIST_VECTOR(YamlProfile)

cl::opt<std::string> AliasProfileFile(
  "polly-alias-profile-file",
  cl::desc("Path to file with alias profiling information"),
  cl::value_desc("filename")
);

namespace {
  /// XXX: This pass is not initialized if we load polly into clang :(
  ///      In opt it works just fine, I don't know why it doesn't in clang.
  ///      -> Temporary hack: put all the logic in NoSpecAA pass :(

  struct ProfilingFeedbackSpecAA : public ImmutablePass,
      public SpeculativeAliasAnalysis {
    static char ID; // Class identification, replacement for typeinfo
    ProfilingFeedbackSpecAA() : ImmutablePass(ID) {
      initializeProfilingFeedbackSpecAAPass(*PassRegistry::getPassRegistry());
    }

    SpeculativeAliasResult speculativeAlias(const Function *f, const Value *a, const Value *b) override {
      // TODO: lazily load profiling results and use them

      return SpeculativeAliasResult::DontKnow;
    }

    //===------------------------------------------------------------------===//
    //  Pass interface
    //===------------------------------------------------------------------===//

    void *getAdjustedAnalysisPointer(const void *ID) override {
      if (ID == &SpeculativeAliasAnalysis::ID)
        return (SpeculativeAliasAnalysis*)this;
      return this;
    }
  };
}  // End of anonymous namespace

// Register this pass...
char ProfilingFeedbackSpecAA::ID = 0;
INITIALIZE_AG_PASS(ProfilingFeedbackSpecAA, SpeculativeAliasAnalysis, "profiling-spec-aa",
                   "Speculative Alias Analysis using profiling feedback",
                   true, false, false)

Pass *polly::createProfilingFeedbackSpecAAPass() { return new ProfilingFeedbackSpecAA(); }


//===----------------------------------------------------------------------===//
// Default implementation
//===----------------------------------------------------------------------===//

#define FAIL_ON_IO_ERROR 1

namespace {
  /// This class implements the -no-specaa pass which always returns don't know
  /// for any alias query.
  struct NoSpecAA : public ImmutablePass, public SpeculativeAliasAnalysis {
    static char ID; // Class identification, replacement for typeinfo
    NoSpecAA() : ImmutablePass(ID) {
      initializeNoSpecAAPass(*PassRegistry::getPassRegistry());
    }

    template<typename T>
    static std::pair<T, T> orderedPair(T a, T b)
    {
      return (a < b) ? std::make_pair(a, b) : std::make_pair(b, a);
    }

    SpeculativeAliasResult speculativeAlias(const Function *f, const Value *a, const Value *b) override {
      auto it = data.find(f->getName());

      if (it == data.end())
        return SpeculativeAliasResult::DontKnow;

      auto pair = orderedPair<std::string>(
        FullInstNamer::getNameOrFail(this, a),
        FullInstNamer::getNameOrFail(this, b)
      );
      auto& pairs = it->second;

      auto it2 = pairs.find(pair);

      if (it2 == pairs.end())
        return SpeculativeAliasResult::DontKnow;

      // errs() << "found alias info for " << a->getName() << " vs " << b->getName() << "\n";

      return it2->second;
    }

    //===------------------------------------------------------------------===//
    //  Pass interface
    //===------------------------------------------------------------------===//

    void *getAdjustedAnalysisPointer(const void *ID) override {
      if (ID == &SpeculativeAliasAnalysis::ID)
        return (SpeculativeAliasAnalysis*)this;
      return this;
    }

    bool doInitialization(Module &M) override {
      data.clear();

      /// read input file

      auto document = MemoryBuffer::getFile(AliasProfileFile);

      if (auto error = document.getError()) {
        if (FAIL_ON_IO_ERROR) {
          errs() << "Could not open alias profile file '" << AliasProfileFile << "': " << error.message() << "\n";
          exit(1);
        }
        return false;
      }

      /// parse input file

      yaml::Input yin(document.get()->getBuffer());

      std::vector<YamlProfile> docs;

      yin >> docs;

      if (auto error = yin.error()) {
        if (FAIL_ON_IO_ERROR) {
          errs() << "Could not parse alias profile file '" << AliasProfileFile << "': " << error.message() << "\n";
          exit(1);
        }
        return false;
      }

      /// convert to in memory data structure
      /// necessary because LLVMs YAML parser is quite limited.

      for (auto& profile : docs) {
        std::string function = std::move(profile.function);

        if (data.count(function)) {
          if (FAIL_ON_IO_ERROR) {
            errs() << "Duplicate alias profile for function '" << function << "\n";
            exit(1);
          }
          return false;
        }

        AliasPairs pairs;

        for (auto& pair : profile.alias_pairs) {
          pairs.insert(
            std::make_pair(
              std::make_pair(std::move(pair.ptr1), std::move(pair.ptr2)),
              decideResult(pair)
            )
          );
        }

        data.insert(std::make_pair(std::move(function), std::move(pairs)));
      }

      return false;
    }
  private:
    SpeculativeAliasResult decideResult(const YamlPair& pair) {
      static const float percentage = 1.0;

      if ((pair.NO_HEAP_ALIAS == percentage)
          && (pair.NO_RANGE_ALIAS == percentage))
        return SpeculativeAliasResult::NoAlias;

      if (pair.NO_HEAP_ALIAS == percentage)
        return SpeculativeAliasResult::NoHeapAlias;
      if (pair.NO_RANGE_ALIAS == percentage)
        return SpeculativeAliasResult::NoRangeOverlap;

      if (pair.EXACT_ALIAS == percentage)
        return SpeculativeAliasResult::ExactAlias;

      return SpeculativeAliasResult::ProbablyAlias;
    }

    AliasProfile data;
  };
}  // End of anonymous namespace

// Register this pass...
char NoSpecAA::ID = 0;
INITIALIZE_AG_PASS(NoSpecAA, SpeculativeAliasAnalysis, "no-spec-aa",
                   "No Speculative Alias Analysis (same result as static AA)",
                   true, true, true)

Pass *polly::createNoSpecAAPass() { return new NoSpecAA(); }

