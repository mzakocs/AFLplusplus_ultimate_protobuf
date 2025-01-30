

set(MUTATOR_TARGET example_mutator)
add_library(${MUTATOR_TARGET} SHARED
    mutator.cpp
    ${EXAMPLE_PROTO_SRC}
)

add_dependencies(${MUTATOR_TARGET} 
    afl_ultimate_protobuf_mutator 
    example_proto
)

target_link_libraries(${MUTATOR_TARGET} 
    afl_ultimate_protobuf_mutator
    protobuf::libprotobuf
)

target_include_directories(${MUTATOR_TARGET} PUBLIC
    ${EXAMPLE_PROTO_INCLUDE_DIRS}
    ${AUPM_INCLUDE_DIRS}
)

if (CMAKE_CXX_COMPILER MATCHES "afl")
    # disable AFL instrumentation for mutator if AFL compiler is used, otherwise it will throw an error when loaded
    target_compile_options(${MUTATOR_TARGET}
        PRIVATE --afl-noopt 
    )
endif()
