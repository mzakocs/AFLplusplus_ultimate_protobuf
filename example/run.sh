#! /bin/bash

### Run inside example dir
# Build
pushd ..
mkdir build
cd build
cmake ..
make -j`nproc`
popd

# Make corpus
mkdir input
../build/example/corpus_proto_creator > ./input/1 

# Run
export AFL_CUSTOM_MUTATOR_ONLY=1
export AFL_DISABLE_TRIM=1
export AFL_CUSTOM_MUTATOR_LIBRARY=$(pwd)/../build/example/mutator/libexample_mutator.so
afl-fuzz -i ./input -o ./output -- ../build/example/fuzzer/example_harness @@
