# Protobuf
protobuf_generate_cpp(
            EXAMPLE_PROTO_SRC 
            EXAMPLE_PROTO_HDR
            example.proto)

set(EXAMPLE_PROTO_TARGET example_proto)
add_library(${EXAMPLE_PROTO_TARGET} STATIC ${EXAMPLE_PROTO_SRC} ${EXAMPLE_PROTO_HDR})

target_link_libraries(${EXAMPLE_PROTO_TARGET} PUBLIC Protobuf)

target_include_directories(${EXAMPLE_PROTO_TARGET} PUBLIC
    ${CMAKE_CURRENT_BINARY_DIR}
)

target_compile_options(${EXAMPLE_PROTO_TARGET} PRIVATE "-fPIC")

if (CMAKE_CXX_COMPILER MATCHES "afl")
    target_compile_options(${EXAMPLE_PROTO_TARGET} PRIVATE 
        --afl-noopt 
    )
endif()

# Harness
add_subdirectory(harness)

# Mutator
add_subdirectory(mutator)

# Corpus Creator
set(CORPUS_PROTO_CREATOR_NAME corpus_proto_creator)
add_executable(${CORPUS_PROTO_CREATOR_NAME} 
    corpus_proto_creator.cpp
)

target_link_libraries(${CORPUS_PROTO_CREATOR_NAME}
    Protobuf
    example_proto
)
