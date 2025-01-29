set(HARNESS_TARGET example_harness)
add_executable(${HARNESS_TARGET} 
    harness.cpp
    ${EXAMPLE_PROTO_SRC}
)

add_dependencies(${HARNESS_TARGET} 
    protobuf::libprotobuf
    example_proto
)

target_compile_options(${HARNESS_TARGET}
    PRIVATE -g -fsanitize=address -fno-omit-frame-pointer
)

target_link_libraries(${HARNESS_TARGET} 
    PRIVATE -fsanitize=address
    protobuf::libprotobuf
)
