## AFLplusplus_ultimate_protobuf
This is the ultimate framework for introducing protobuf mutation into AFL++. There are other projects that have attempted to do this before, but they are either incomplete or only partially functional. This is a lightweight and easy-to-modify custom mutator that makes using libprotobuf-mutator with AFL just as easy as it is with libFuzzer.

## Build
- This project uses the `CMake` build system. Run the script below to build
```bash
mkdir build
cd build
cmake ..
make -j`nproc`
```

## Example
- See `./example` to see an example mutator and harness
- Run `./run.sh` from within the directory to build and run an example fuzzer
  - AFL++ must be built and installed though
- `mutator.cpp` exists solely to import the generated protobufs and pass it to `DEFINE_PROTO_MUTATOR`
  - Can also just call `DEFINE_PROTO_MUTATOR_CUSTOM_INIT`, `DEFINE_PROTO_MUTATOR_CUSTOM_FUZZ`, or `DEFINE_PROTO_MUTATOR_CUSTOM_DEINIT` individually and then define your own `afl_custom_*` functions
    - For example, if you only call `DEFINE_PROTO_MUTATOR_CUSTOM_INIT` and `DEFINE_PROTO_MUTATOR_CUSTOM_FUZZ` in your `mutator.h`, you can then define `afl_custom_deinit` yourself and do whatever you want in there
    - Useful if you don't want to maintain your own custom `lpm_afl_mutator.h`
    - There are also tons of extra `afl_custom_*` functions that can add functionality to your mutator (more info on the [AFL++ wiki](https://aflplus.plus/docs/custom_mutators/))
- `harness.cpp` is the harness that `afl-fuzz` will actually target, handles file i/o and converts the protobuf to the actual fuzzing input format
  - For example, if you write a protobuf schema to represent JavaScript, the harness will be responsible for converting the protobuf structure into a string of JavaScript code (and then feeding it to the JavaScript engine for execution)

## Notes
- Only tested on Ubuntu 22.04 with AFL++ 4.20c
- Currently only supports protobuf text format, although it is not difficult to add support for the binary format. May do this in the future if enough people ask
    - Although speed increase is negligible and doesn't beat the tradeoff of being able to easily read the crash inputs
- You **must** disable AFL's trimming feature with the `AFL_DISABLE_TRIM` environment variable. Otherwise it will attempt to trim the text protobufs like they're raw bytes and corrupt them after every mutation
  - Want to implement a custom trimmer in the future

## Credit
This library is heavily inspired by these two projects:
- [libprotobuf-mutator_fuzzing_learning](https://github.com/bruce30262/libprotobuf-mutator_fuzzing_learning/tree/master/5_libprotobuf_aflpp_custom_mutator_input)
  - Recommend looking at this project if you need to use another build system with this mutator as it has an easy-to-understand `Makefile`
    - Highly recommend using my [absl-less fork of libprotobuf-mutator](https://github.com/mzakocs/libprotobuf-mutator) with `LIB_PROTO_MUTATOR_DOWNLOAD_PROTOBUF` enabled if including the dependencies another way however
  - Also shows extra post-processer in their `afl_custom_init`
- [AFLplusplus-protobuf-mutator](https://github.com/P1umer/AFLplusplus-protobuf-mutator)
  - A lot of the CMake build system was originally based on the build system from this project
  - Inspired the creation of AFLplusplus_ultimate_protobuf