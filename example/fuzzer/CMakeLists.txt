set(HARNESS_NAME example_harness)
add_executable(${HARNESS_NAME} 
    harness.cpp
    ${EXAMPLE_PROTO_SRC}
)
add_dependencies(${HARNESS_NAME} 
    protobuf::libprotobuf
    example_proto
)
target_compile_options(${HARNESS_NAME}
    PRIVATE -g -fsanitize=address -fno-omit-frame-pointer 
)
target_link_libraries(${HARNESS_NAME} 
    PRIVATE -fsanitize=address
    protobuf::libprotobuf
)