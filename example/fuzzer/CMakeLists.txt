set(EXAMPLE_HARNESS_TARGET example_harness)
add_executable(${EXAMPLE_HARNESS_TARGET} 
    harness.cpp
    ${EXAMPLE_PROTO_SRC}
)

add_dependencies(${EXAMPLE_HARNESS_TARGET} 
    protobuf::libprotobuf
    example_proto
)

target_compile_options(${EXAMPLE_HARNESS_TARGET}
    PRIVATE -g -fsanitize=address -fno-omit-frame-pointer
)

target_link_libraries(${EXAMPLE_HARNESS_TARGET} 
    PRIVATE -fsanitize=address
    protobuf::libprotobuf
)
