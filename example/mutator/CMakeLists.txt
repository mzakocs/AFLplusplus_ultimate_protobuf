set(MUTATOR_NAME example_mutator)
add_library(${MUTATOR_NAME} SHARED
    mutator.cpp
    ${EXAMPLE_PROTO_SRC}
)

target_link_libraries(${MUTATOR_NAME} 
    afl_ultimate_protobuf_mutator
    example_proto
)

if (CMAKE_CXX_COMPILER MATCHES "afl")
    # disable AFL instrumentation for mutator if AFL compiler is used, otherwise it will throw an error when loaded
    target_compile_options(${MUTATOR_NAME} PRIVATE 
        --afl-noopt 
    )
endif()