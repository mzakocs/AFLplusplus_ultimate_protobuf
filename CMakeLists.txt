CMAKE_MINIMUM_REQUIRED(VERSION 3.24)
PROJECT(AFLplusplus_ultimate_protobuf_mutator CXX)

enable_language(C)
enable_language(CXX)

set(CMAKE_CXX_STANDARD 14)

OPTION(LIB_PROTOBUF_DOWNLOAD
       "Automatically download libprotobuf" ON)

OPTION(LIB_PROTOBUF_MUTATOR_DOWNLOAD
       "Automatically download libprotobuf-mutator" ON)

# External dependencies
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

if (LIB_PROTOBUF_DOWNLOAD)
  include(libprotobuf)
endif()

if(LIB_PROTOBUF_MUTATOR_DOWNLOAD)
  include(libprotobuf-mutator)
endif()

# Main library
set(LIB_NAME afl_ultimate_protobuf_mutator)
add_library(${LIB_NAME} INTERFACE)
target_include_directories(${LIB_NAME} INTERFACE ${PROJECT_SOURCE_DIR})
add_dependencies(${LIB_NAME} INTERFACE ${PROTOBUF_TARGET})
add_dependencies(${LIB_NAME} INTERFACE ${LPM_TARGET})
target_link_libraries(${LIB_NAME} INTERFACE Protobuf protobuf-mutator)
add_subdirectory(example)
