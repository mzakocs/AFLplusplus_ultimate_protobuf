

set(EXAMPLE_MUTATOR_TARGET example_mutator)
add_library(${EXAMPLE_MUTATOR_TARGET} SHARED
    mutator.cpp
    ${EXAMPLE_PROTO_SRC}
)

add_dependencies(${EXAMPLE_MUTATOR_TARGET} 
    afl_ultimate_protobuf_mutator 
    example_proto
)

target_link_libraries(${EXAMPLE_MUTATOR_TARGET} 
    afl_ultimate_protobuf_mutator
    protobuf::libprotobuf
)

target_include_directories(${EXAMPLE_MUTATOR_TARGET} PUBLIC
    ${EXAMPLE_PROTO_INCLUDE_DIRS}
    ${AUPM_INCLUDE_DIRS}
)

if (CMAKE_CXX_COMPILER MATCHES "afl")
    # disable AFL instrumentation for mutator if AFL compiler is used, otherwise it will throw an error when loaded
    target_compile_options(${EXAMPLE_MUTATOR_TARGET}
        PRIVATE --afl-noopt 
    )
endif()
