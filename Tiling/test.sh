#!/bin/bash
scriptDir="$( cd "$( dirname "$0" )" && pwd )"

passesDirPath=$scriptDir"/llvm-passes"
buildDirPath=$scriptDir"/build"
testDirPath=$scriptDir"/test"

unrollPassFileName="TileUnroll"
unrollPassName="tile-unroll"

graphPassFileName="TileGraph"
graphPassName="scev-tile-graph"

loopPassFileName="TileLoop"
loopPassName="scev-tile-loop"

sfxRaw="_raw"
sfxOpt="_opt"
sfxUnr="_unr"
sfxTil="_til"
sfxCmp=$sfxRaw

compiler=clang

rebuildPasses=1;
rebuildBench=0;

if [ $rebuildPasses -eq 1 ]; then
    #clear build directory
    if [ ! -d $buildDirPath ]; then
    	mkdir $buildDirPath
    fi
    rm -rf $buildDirPath/*
fi

# clear the testing directory
if [ ! -d $testDirPath ]; then
	mkdir $testDirPath
fi
rm -rf $testDirPath/*

#setup logging
testLogPath=$testDirPath/"test-log.txt";
# Redirect stdout ( > ) into a named pipe ( >() ) running "tee"
exec > >(tee $testLogPath)
#redirect stderr to stdout
exec 2>&1

unrollFactor=12

selectedLoopNames="" #"L02" to select loop or "L02,L03" to select multiple, or "" to process all
selectedFunNames=""    
    
speedTiling=true;    
    
#select benchmark
bench=4;
case "$bench" in
1)
  benchPath=$scriptDir/bench/must-dep
  testFileName="must-dep-tst"
  compiler="clang++"
  fPrintLimit=6
  tilingTout=3
  ;;
2) 
  testFileName="wavelets_my"
  testFileNameExt='.c'
  fPrintLimit=32
  tilingTout=15
  ;;
3)
  benchPath=$scriptDir/bench/jacobi3d
  testFileName="jacobi3d"
  compiler="clang++"
  fPrintLimit=32
  tilingTout=15
  ;;
4)
  benchPath=$scriptDir/bench/polybench
  testFileName="3mm"
  fPrintLimit=32
  tilingTout=15 
  ;; 
esac

#testing different alias anaysis options
aaType=1;#3
case "$aaType" in
1) aa="-basicaa";;
2) aa="-globalsmodref-aa" ;;
3) aa="-scev-aa" ;;
4) aa="-steens-aa" ;;
5) aa="-ds-aa" ;;
esac


testFileBasePath=$testDirPath/$testFileName

#to get optirex call
#scp  <username>@gcg-production-2:/work/tiling/optirex.jar <path-to-LLVMtools-repo>/Tiling/
#you require java 1.8 to run it
optirexPath=$scriptDir/optirex.jar

graphsFilePath=$testDirPath/$testFileName'_graph.yml'
tilingFilePath=$testDirPath/$testFileName'_tiling.yml'

unrollPassDllPath=$buildDirPath/$unrollPassFileName/"lib"$unrollPassFileName".so"
graphPassDllPath=$buildDirPath/$graphPassFileName/"lib"$graphPassFileName".so"
loopPassDllPath=$buildDirPath/$loopPassFileName/"lib"$loopPassFileName".so"

llvmDir=$(realpath /home/fader/workspace/corse-llvm/)/
llvmBuildDir=$(realpath $llvmDir/build-llvm-debug)/
llvmBinDir="$llvmBuildDir/bin/";
llvmPollyDllPath="LLVMPolly.so"

if [ $USER == "fader" ]; then
    # llvmInstallDir="/home/luke2k4/work/inria/llvm/llvm-gcg/install"
    # llvmPollyDllPath=$llvmInstallDir/"lib/LLVMPolly.so"
    # llvmBinDir=$llvmInstallDir"/bin/"

    # export LLVM_DIR_ENV=$llvmInstallDir/"share/llvm/cmake/"
    export LLVM_DIR_ENV=$llvmBinDir/"cmake/"
    # export CMAKE_PREFIX_PATH_ENV=$llvmBinDir
fi

optPath=$llvmBinDir"opt"
clangPath=$llvmBinDir$compiler
llcPath=$llvmBinDir"llc"

echo "CLANG VERSION:"
echo `$clangPath --version`
echo "OPT VERSION:"
echo `$optPath --version`
echo "LLC VERSION:"
echo `$llcPath --version`

javaPath="java"

if [ $rebuildPasses -eq 1 ]; then
    # Build the new LLVM passes
    cd $buildDirPath
    echo $llvmBuildDi
    cmake \
      -DCMAKE_PREFIX_PATH="$llvmBuildDir" \
      -DCMAKE_BUILD_TYPE=Release \
      -DLLVM_ENABLE_ASSERTIONS=Off \
      $passesDirPath
    make clean
    make
fi
    
export CMAKE_PREFIX_PATH_ENV=$llvmBinDir

#compile and emit human readable ir
cd $benchPath
rawIrPath=$benchPath/$testFileName$sfxRaw'.ll'
if [ $rebuildBench -eq 1 ]; then
    make clean && make     
    if [ ! -f $rawIrPath ]; then
        echo "File "$rawIrPath" not produced, exiting ...";
        exit;
    fi
fi
cp $rawIrPath  $testFileBasePath$sfxRaw'.ll'


# Start testing
cd $testDirPath

#transEnableUnroll="-indvars -loops -loop-simplify -loop-rotate -lcssa"
#transEnableUnroll="-indvars -loops -loop-simplify -loop-rotate"; #works
disable="-mc-x86-disable-arith-relaxation -polly-optimizer=none -polly-opt-simplify-deps=no" #-disable-objc-arc-opts" # -stop-after=loop-rotate"
commonArgs="-load $llvmPollyDllPath -polly -O3 -unroll-count=1 -unroll-threshold=1"
#commonArgs="-indvars -loops -loop-simplify -loop-rotate"
firstUnrollArgs="-polly-indvars -loops -loop-simplify -loop-rotate" # -polly-canonicalize" # this changes a lot 
passDebug="-debug-pass=Executions -print-after-all"

#firstUnrollArgs= "-indvars -loops -loop-simplify -loop-rotate"
#secondUnrollArgs="-polly-indvars" # -polly-canonicalize" # -loop-simplify" # -polly-canonicalize";
#secondUnrollArgs= "-indvars -loops -loop-simplify -loop-rotate"

#optimize program
$optPath  $commonArgs $firstUnrollArgs -S -o $testFileBasePath$sfxOpt'.ll' $testFileBasePath$sfxRaw'.ll' 
#$optPath  $commonArgs $firstUnrollArgs -S -o $testFileBasePath$sfxOpt'.ll' $testFileBasePath$sfxOpt'.ll' 
#$optPath  $commonArgs $firstUnrollArgs $disable -loop-unroll -unroll-count=1 -S -o $testFileBasePath$sfxOpt'.ll' $testFileBasePath$sfxRaw'.ll' 

#assign names to instructions
$optPath -instnamer -S -o $testFileBasePath$sfxOpt'.ll'  $testFileBasePath$sfxOpt'.ll'
#build the dependence graph for tiling and name loops and basic blocks 
#$optPath -load $graphPassDllPath $aa -$graphPassName -tile-graph-file-out $graphsFilePath -selected-loop-names=$selectedLoopNames --time-passes -S -o $testFileBasePath$sfxOpt'.ll' $testFileBasePath$sfxOpt'.ll'

#unroll loop N times
#$optPath $passDebug $commonArgs $secondUnrollArgs $disable  -loop-unroll -unroll-count=$unrollFactor -S -o $testFileBasePath$sfxUnr'_0.ll' $testFileBasePath$sfxOpt'.ll'
$optPath  -unroll-threshold=1  -load $unrollPassDllPath $aa -$unrollPassName  -selected-loop-names=$selectedLoopNames -unroll-factor=$unrollFactor -S -o $testFileBasePath$sfxUnr'.ll' $testFileBasePath$sfxOpt'.ll'

#simplify scev expressions
$optPath  -indvars  -S -o $testFileBasePath$sfxUnr'_tst.ll' $testFileBasePath$sfxUnr'.ll'

#produce dependence graph from an iteration of an unrolled loop
$optPath -load $graphPassDllPath $aa -$graphPassName -tile-graph-file-out $graphsFilePath -selected-loop-names=$selectedLoopNames -unroll-factor=$unrollFactor -S -o $testFileBasePath$sfxUnr'.ll' $testFileBasePath$sfxUnr'.ll'

#tiling tool has to be executed here
$javaPath -ea -jar $optirexPath "{ \
    inDir: $testDirPath/, \
    outDir: $testDirPath/, \
    logDir: $testDirPath/, \
    fPrintLimit: $fPrintLimit, \
    speedTiling: $speedTiling, \
    tilingConfigMap: { \
        timeout: $tilingTout, \
        dumpGraph: 1, \
        unrollFactor: $unrollFactor
    } \
}";

#modify the ir to create the tiling
$optPath -load $loopPassDllPath $aa -$loopPassName -tile-graph-file-in $graphsFilePath -tiling-file-in $tilingFilePath -selected-loop-names=$selectedLoopNames -S -o $testFileBasePath$sfxTil'.ll'  $testFileBasePath$sfxUnr'.ll'
#cp $testFileBasePath$sfxUnr'.ll' $testFileBasePath$sfxTil'.ll'

#compile to binary
#create object file
$llcPath -filetype=obj $testFileBasePath$sfxCmp'.ll' -o $testFileBasePath$sfxCmp'.o'
$llcPath -filetype=obj $testFileBasePath$sfxTil'.ll' -o $testFileBasePath$sfxTil'.o'

#link
#create executable
$clangPath $testFileBasePath$sfxCmp'.o' -o $testFileBasePath$sfxCmp'.out'
$clangPath $testFileBasePath$sfxTil'.o' -o $testFileBasePath$sfxTil'.out'

#run
$testFileBasePath$sfxCmp'.out' 2>&1 | tee $testFileBasePath$sfxCmp'.log'
$testFileBasePath$sfxTil'.out' 2>&1 | tee $testFileBasePath$sfxTil'.log' 


#compare results before/after tiling
diff $testFileBasePath$sfxCmp'.log' $testFileBasePath$sfxTil'.log'
if [ $? -eq 0 ]; then
    echo "Tiled and untiled program outputs are the same"
else
    echo "Tiled and untiled program outputs are NOT the same!"
fi 


#-instnamer - names variables %tmpX 
#opt -load ./Hello/libLLVMPassname.so -hello  --time-passes ../hello.bc


#opt -mem2reg -indvars -loops  -loopsimplify -loop-rotate -lcssa -loop-unroll -unroll-count=3 -debug loop.o -o tt.bc

