# Protobuf
FIND_PACKAGE(Protobuf REQUIRED)
include("${PROTOBUF_SRC_DIR}/cmake/protobuf-generate.cmake")

set(EXAMPLE_PROTO_TARGET example_proto)
add_custom_target(${EXAMPLE_PROTO_TARGET} ALL)
add_dependencies(${EXAMPLE_PROTO_TARGET} protobuf::libprotobuf)
protobuf_generate(
    LANGUAGE cpp
    TARGET ${EXAMPLE_PROTO_TARGET}
    PROTOS example.proto
    OUT_VAR EXAMPLE_PROTO_SRC
)
set(EXAMPLE_PROTO_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR})

# Harness
add_subdirectory(fuzzer)

# Mutator
add_subdirectory(mutator)

# Corpus Creator
set(CORPUS_PROTO_CREATOR_TARGET corpus_proto_creator)
add_executable(${CORPUS_PROTO_CREATOR_TARGET}
    ${EXAMPLE_PROTO_SRC} 
    corpus_proto_creator.cpp
)

add_dependencies(${CORPUS_PROTO_CREATOR_TARGET}
    example_proto
    protobuf::libprotobuf
)

target_link_libraries(${CORPUS_PROTO_CREATOR_TARGET}
    protobuf::libprotobuf
)

target_include_directories(${CORPUS_PROTO_CREATOR_TARGET} PUBLIC
    ${PROTOBUF_INCLUDE_DIRS}
    ${EXAMPLE_PROTO_INCLUDE_DIRS}
)
