# Protobuf
FIND_PACKAGE(Protobuf REQUIRED)
include("${PROTOBUF_INSTALL_DIR}/cmake/protobuf-generate.cmake")

add_custom_target(example_proto ALL)
add_dependencies(example_proto protobuf::libprotobuf)
protobuf_generate(
    LANGUAGE cpp
    TARGET example_proto
    PROTOS example.proto
    OUT_VAR EXAMPLE_PROTO_SRC
)

# Harness
add_subdirectory(fuzzer)

# Mutator
add_subdirectory(mutator)

# Corpus Creator
set(CORPUS_PROTO_CREATOR_NAME corpus_proto_creator)
add_executable(${CORPUS_PROTO_CREATOR_NAME}
    ${EXAMPLE_PROTO_SRC} 
    corpus_proto_creator.cpp
)

add_dependencies(${CORPUS_PROTO_CREATOR_NAME}
    example_proto
    protobuf::libprotobuf
)

target_link_libraries(${CORPUS_PROTO_CREATOR_NAME}
    protobuf::libprotobuf
)

target_include_directories(${CORPUS_PROTO_CREATOR_NAME} PUBLIC
    ${PROTOBUF_INCLUDE_DIRS}
)