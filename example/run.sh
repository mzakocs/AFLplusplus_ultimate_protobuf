#! /bin/bash

### Run inside example dir ###

# Build
pushd ..
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=$(which afl-clang-fast) -DCMAKE_CXX_COMPILER=$(which afl-clang-fast++) ..
make -j`nproc`
popd

# Make corpus
mkdir input
../build/example/corpus_proto_creator > ./input/1 

# Run
export AFL_CUSTOM_MUTATOR_ONLY=1
export AFL_DISABLE_TRIM=1
export AFL_SKIP_CPUFREQ=1
export AFL_CUSTOM_MUTATOR_LIBRARY=$(pwd)/../build/example/mutator/libexample_mutator.so
afl-fuzz -i ./input -o ./output -- ../build/example/harness/example_harness @@
