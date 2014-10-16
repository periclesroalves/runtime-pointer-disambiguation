
#ifndef _GCG_BENCH_UTIL_HPP
#define _GCG_BENCH_UTIL_HPP 1

#include <cstdint>

namespace internal {
	extern void real_blackhole(uintptr_t);
}

/// Useful helper function to confuse dead code elimination in benchmarks.
/// Consume pointer argument
template<typename T>
void blackhole(T *t) {
	::internal::real_blackhole(reinterpret_cast<uintptr_t>(t));
}

/// Useful helper function to confuse dead code elimination in benchmarks.
/// Consume integer/float argument
// TODO: use std::enable_if to check if cast is possible
template<typename T>
void blackhole(T t) {
	::internal::real_blackhole(static_cast<uintptr_t>(t));
}

template<typename T, typename... Ts>
void blackhole(T t, Ts&&... ts) {
	blackhole<T>(t);
	blackhole<Ts...>(ts...);
}

inline void blackhole() {}

#endif // end _GCG_BENCH_UTIL_HPP
