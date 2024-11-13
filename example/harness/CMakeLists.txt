set(HARNESS_NAME example_harness)
add_executable(${HARNESS_NAME} 
    harness.cpp
    ${EXAMPLE_PROTO_SRC}
)

target_compile_options(${HARNESS_NAME} PRIVATE 
    -fsanitize=address -fno-omit-frame-pointer 
)

target_link_libraries(${HARNESS_NAME} PRIVATE 
    -fsanitize=address
    example_proto
    Protobuf
)
