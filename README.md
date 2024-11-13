## AFLplusplus_ultimate_protobuf
A customizable and lightweight mutator for AFL++ that integrates libprotobuf-mutator as effortlessly as libFuzzer

## Build
This project uses a `CMake` build system. Run the script below to build the example:
```bash
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=$(which afl-clang-fast) -DCMAKE_CXX_COMPILER=$(which afl-clang-fast++) ..
make -j`nproc`
```

## Example
- See `./example` for a base mutator, corpus generator, and harness
- Run `./run.sh` from within the directory to build and run the example fuzzer
  - AFL++ must be built and installed with the `afl-clang-fast` compilers
- `mutator.cpp` exists solely to import the generated protobufs and pass it to `DEFINE_PROTO_MUTATOR`
  - Can also just call `DEFINE_PROTO_MUTATOR_CUSTOM_INIT`, `DEFINE_PROTO_MUTATOR_CUSTOM_FUZZ`, or `DEFINE_PROTO_MUTATOR_CUSTOM_DEINIT` individually and then define your own `afl_custom_*` functions
    - For example, if you only call `DEFINE_PROTO_MUTATOR_CUSTOM_INIT` and `DEFINE_PROTO_MUTATOR_CUSTOM_FUZZ` in your `mutator.h`, you can then define `afl_custom_deinit` yourself and do whatever you want in there
    - Useful if you don't want to maintain your own custom `lpm_afl_mutator.h`
    - There are also tons of extra `afl_custom_*` functions that can add functionality to your mutator (more info on the [AFL++ wiki](https://aflplus.plus/docs/custom_mutators/))
- `harness.cpp` is the harness that `afl-fuzz` will actually target, handles file i/o and converts the protobuf to raw bytes (or any other fuzzing input format such as structs or classes)
  - For example, if you write a protobuf schema to represent JavaScript, the harness will be responsible for converting the protobuf structure into a string of JavaScript code (and then feeding it to the JavaScript engine for execution)
  - Another example is if you write a protobuf schema to represent the VP9 video codec ([shameless plug for an old project of mine](https://github.com/mzakocs/vp9-proto)), then the harness will convert the protobuf to raw bytes to be consumed by the VP9 decoder
  - This may seem more complicated than just putting all the custom conversion logic in the custom mutator, but unfortunately AFL saves output from a custom mutator directly to disk, meaning it will save the raw bytes directly to disk and add them to the corpus (instead of the protobuf format that we need to mutate again)
  - This also provides more flexibility as the converted protobuf doesn't necessarily have to be in a format that can be saved to disk (e.g. for the struct/class example)
- `corpus_proto_creator.cpp` is a utility for manually constructing corpus inputs
  - Another great option is just writing them by hand if your protobuf description is simple enough

## Usage
- To include this in a seperate project (git submodules or CMake FetchProject recommended), include the `libprotobuf` and `libprotobuf-mutator` cmake files in the highest level of the project and disable them in `AFLplusplus_ultimate_protobuf_mutator` (using the `LIB_PROTOBUF_DOWNLOAD` and `LIB_PROTOBUF_MUTATOR_DOWNLOAD` CMake options). This is necessary because of how CMake and ExternalProjectAdd work. If these libraries are left to this directory to build, no parent projects would be able to use them, which is necessary if your harnesses are in the parent project. All you need to do is add this in the parent projects root CMakeList:
    ```cmake
    include(${CMAKE_SOURCE_DIR}/lib/AFLplusplus_ultimate_protobuf_mutator/cmake/libprotobuf.cmake)
    include(${CMAKE_SOURCE_DIR}/lib/AFLplusplus_ultimate_protobuf_mutator/cmake/libprotobuf-mutator.cmake)

    set(LIB_PROTOBUF_DOWNLOAD CACHE INTERNAL OFF)
    set(LIB_PROTOBUF_MUTATOR_DOWNLOAD CACHE INTERNAL OFF)
    add_subdirectory(${CMAKE_SOURCE_DIR}/lib/AFLplusplus_ultimate_protobuf_mutator)
    ```
  - This does come with the advantage of being more configurable and allowing you to use the pre-existing build of protobuf if the project you're fuzzing already has it

## Notes
- Only tested on Ubuntu 22.04 with AFL++ 4.20c
- Currently only supports protobuf text format, although it is not difficult to add support for the binary format. May do this in the future if enough people ask
    - Although speed increase is negligible and doesn't beat the tradeoff of being able to easily read the crash inputs
- You **must** disable AFL's trimming feature with the `AFL_DISABLE_TRIM` environment variable. Otherwise it will attempt to trim the text protobufs like they're raw bytes and corrupt them after every mutation
  - Might try to implement a custom trimmer in the future but impact is questionable
- This can be used for AFL QEMU mode (major reason for creating this project), but it requires some linker and ELF wizardry to get the converter harness and static protobuf libraries into the target binary. There is a project underway that does this, so this section will be updated in the future once finished
- Very annoying part of creating custom mutators is that not a single object file that is included in the shared library can be built with the `afl-cc` compilers. Otherwise you will get errors from `ld` when AFL attempts to load it. You can get around this by using `--afl-noopt`, a barely-documented feature of `afl-cc` that will cause the compiler to pass the source files directly down to the base compiler (clang, gcc, etc.)
  - You can see the use of this all throughout the CMake build files, but it comes with the downside that libprotobuf and the compiled protobufs will not have AFL instrumentation (although this is probably more of an upside due to execution speed if anything)


## Credit
This library is heavily inspired by these two projects:
- [libprotobuf-mutator_fuzzing_learning](https://github.com/bruce30262/libprotobuf-mutator_fuzzing_learning/tree/master/5_libprotobuf_aflpp_custom_mutator_input)
  - Recommend looking at this project if you need to use another build system with this mutator as it has an easy-to-understand `Makefile`
  - Also shows extra post-processer in their `afl_custom_init`
- [AFLplusplus-protobuf-mutator](https://github.com/P1umer/AFLplusplus-protobuf-mutator)
  - CMake build system/structure was based on this project