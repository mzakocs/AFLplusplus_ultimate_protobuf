My branch of `libprotobuf` backports [this](https://github.com/protocolbuffers/protobuf/commit/ad55f52fdb4557953593cd096b903b0347b02f25) commit in libprotobuf to v21.12 (last pre-absl version), allows this project to use the `protobuf_generate` CMake function by just including `protobuf_generate.cmake` 

My branch of `libprotobuf-mutator` removes any absl dependencies from the library

If you couldn't tell I don't like absl, it's not worth the linker headache
