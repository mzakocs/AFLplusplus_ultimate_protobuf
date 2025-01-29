

set(MUTATOR_NAME example_mutator)
add_library(${MUTATOR_NAME} SHARED
    mutator.cpp
    ${EXAMPLE_PROTO_SRC}
)

add_dependencies(${MUTATOR_NAME} 
    afl_ultimate_protobuf_mutator 
    example_proto
)

target_link_libraries(${MUTATOR_NAME} 
    afl_ultimate_protobuf_mutator
)
