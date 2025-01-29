CMAKE_MINIMUM_REQUIRED(VERSION 3.24)
PROJECT(AFLplusplus_ultimate_protobuf_mutator CXX)

enable_language(C)
enable_language(CXX)

set(CMAKE_CXX_STANDARD 14)

OPTION(LIB_PROTOBUF_DOWNLOAD
       "Automatically download working Protobuf" ON)

OPTION(LIB_PROTOBUF_MUTATOR_DOWNLOAD
       "Automatically download working LPM" ON)

# External dependencies
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

# External dependencies
include(CheckCCompilerFlag)
include(CheckCXXCompilerFlag)

include_directories(${PROJECT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_BINARY_DIR})

# check -fPIC
set(CMAKE_REQUIRED_FLAGS "-fPIC")
check_cxx_compiler_flag(-fPIC PIC)
unset(CMAKE_REQUIRED_FLAGS)

if (PIC)
    set(EXTRA_FLAGS "${EXTRA_FLAGS} -fPIC")
endif()

set(C_EXTRA_FLAGS "${C_EXTRA_FLAGS} ${EXTRA_FLAGS}")
set(CXX_EXTRA_FLAGS "${CXX_EXTRA_FLAGS} ${EXTRA_FLAGS}")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${C_EXTRA_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CXX_EXTRA_FLAGS}")

set(PROTOBUF_CFLAGS "${CMAKE_C_FLAGS} ${NO_FUZZING_FLAGS} -w")
set(PROTOBUF_CXXFLAGS "${CMAKE_CXX_FLAGS} ${NO_FUZZING_FLAGS} -w")
if(CMAKE_USE_PTHREADS_INIT)
  set(PROTOBUF_CFLAGS "${PROTOBUF_CFLAGS} -pthread")
  set(PROTOBUF_CXXFLAGS "${PROTOBUF_CXXFLAGS} -pthread")
endif()

if (LIB_PROTOBUF_DOWNLOAD)
  include(libprotobuf)
else()
  # Untested
  find_package(Protobuf REQUIRED)
  include_directories(${PROTOBUF_INCLUDE_DIRS})
  include_directories(${CMAKE_CURRENT_BINARY_DIR})
endif()

if(LIB_PROTOBUF_MUTATOR_DOWNLOAD)
    include(libprotobuf-mutator)
else()
    # Untested
    find_package(libprotobuf-mutator REQUIRED)
    message("Found LPM :${libprotobuf-mutator_DIR}")
    if(libprotobuf-mutator_FOUND)
        get_filename_component(_IMPORT_PREFIX "${libprotobuf-mutator_DIR}" PATH)
        get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
        get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
        SET(LPM_INCLUDE_DIRS "${_IMPORT_PREFIX}/include/libprotobuf-mutator")
    endif(libprotobuf-mutator_FOUND)
endif()

set(LIB_NAME afl_ultimate_protobuf_mutator)
add_library(${LIB_NAME} INTERFACE)
target_include_directories(${LIB_NAME} INTERFACE 
  lpm_afl_mutator.h 
  ${PROTOBUF_INCLUDE_DIRS}
  ${LPM_INCLUDE_DIRS}
)
if(LIB_PROTOBUF_MUTATOR_DOWNLOAD)
    add_dependencies(${LIB_NAME} INTERFACE protobuf-mutator)
endif()
target_link_libraries(${LIB_NAME} INTERFACE protobuf-mutator)
add_subdirectory(example)
