cmake_policy(PUSH)
cmake_policy(SET CMP0074 NEW)
include(ExternalProject)

set(LPM_TARGET libprotobuf-mutator)
set(LPM_EXTERNAL external.lpm)
set(LPM_INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/${LPM_EXTERNAL})

set(LPM_INCLUDE_DIR ${LPM_INSTALL_DIR}/include/libprotobuf-mutator)
set(LPM_LIB_DIR ${LPM_INSTALL_DIR}/lib)

set(CMAKE_IMPORT_FILE_VERSION 1)

# Protect against multiple inclusion, which would fail when already imported targets are added once more.
set(_targetsDefined)
set(_targetsNotDefined)
set(_expectedTargets)
foreach(_expectedTarget protobuf-mutator-libfuzzer protobuf-mutator)
  list(APPEND _expectedTargets ${_expectedTarget})
  if(NOT TARGET ${_expectedTarget})
    list(APPEND _targetsNotDefined ${_expectedTarget})
  endif()
  if(TARGET ${_expectedTarget})
    list(APPEND _targetsDefined ${_expectedTarget})
  endif()
endforeach()
if("${_targetsDefined}" STREQUAL "${_expectedTargets}")
  unset(_targetsDefined)
  unset(_targetsNotDefined)
  unset(_expectedTargets)
  set(CMAKE_IMPORT_FILE_VERSION)
  cmake_policy(POP)
  return()
endif()
if(NOT "${_targetsDefined}" STREQUAL "")
  message(FATAL_ERROR "Some (but not all) targets in this export set were already defined.\nTargets Defined: ${_targetsDefined}\nTargets not yet defined: ${_targetsNotDefined}\n")
endif()
unset(_targetsDefined)
unset(_targetsNotDefined)
unset(_expectedTargets)

# Create ${LPM_INCLUDE_DIR}/src to bypass check of INTERFACE_INCLUDE_DIRECTORIES in set_target_properties()
file(MAKE_DIRECTORY ${LPM_INCLUDE_DIR}/src)

# Create imported target protobuf-mutator
set(LPM_LIBRARY protobuf-mutator)
add_library(${LPM_LIBRARY} STATIC IMPORTED)

set_target_properties(${LPM_LIBRARY} PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES "${LPM_INCLUDE_DIR};${LPM_INCLUDE_DIR}/src"
  INTERFACE_LINK_LIBRARIES "${PROTOBUF_LIBRARIES}"
)

# Import target "protobuf-mutator" for configuration ""
set_property(TARGET ${LPM_LIBRARY} APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(${LPM_LIBRARY} PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_NOCONFIG "CXX"
  IMPORTED_LOCATION_NOCONFIG "${LPM_LIB_DIR}/libprotobuf-mutator.a"
)

# list(APPEND _IMPORT_CHECK_TARGETS ${LPM_LIBRARY})
# list(APPEND _IMPORT_CHECK_FILES_FOR_protobuf-mutator "${LPM_LIB_DIR}/libprotobuf-mutator.a" )

set(LPM_GIT_URL      https://github.com/google/libprotobuf-mutator.git)  
set(LPM_GIT_TAG      v1.4)
set(LPM_CONFIGURE    cd ${LPM_INSTALL_DIR}/src/${LPM_TARGET} && ${CMAKE_COMMAND} .                   
                        -DLIB_PROTO_MUTATOR_DOWNLOAD_PROTOBUF=OFF
                        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                        -DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
                        -DCMAKE_INSTALL_PREFIX=${LPM_INSTALL_DIR} 
                        -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER} 
                        -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
                        -DCMAKE_C_FLAGS=${PROTOBUF_CFLAGS}
                        -DCMAKE_CXX_FLAGS=${PROTOBUF_CXXFLAGS}
                        -DProtobuf_LIBRARIES=${Protobuf_LIBRARIES}
                        -DProtobuf_INCLUDE_DIR=${Protobuf_INCLUDE_DIRS}
			                  -DLIB_PROTO_MUTATOR_TESTING=OFF)
set(LPM_MAKE         cd ${LPM_INSTALL_DIR}/src/${LPM_TARGET} && make)
set(LPM_INSTALL      cd ${LPM_INSTALL_DIR}/src/${LPM_TARGET} && make install)

set(PROTOBUF_CFLAGS "${CMAKE_C_FLAGS} ${NO_FUZZING_FLAGS} -w -fPIC")
set(PROTOBUF_CXXFLAGS "${CMAKE_CXX_FLAGS} ${NO_FUZZING_FLAGS} -fPIC")

# Important to disable AFL instrumentation on anything the mutator will link here
#   Otherwise you will get a "undefined symbol: __afl_area_ptr" error when trying to load the mutator
if(CMAKE_CXX_COMPILER MATCHES "afl")
  set(PROTOBUF_CFLAGS "${PROTOBUF_CFLAGS} --afl-noopt")
  set(PROTOBUF_CXXFLAGS "${PROTOBUF_CXXFLAGS} --afl-noopt")
endif()

message(STATUS "Configuring libprotobuf-mutator...")
ExternalProject_Add(    ${LPM_TARGET}
    PREFIX              ${LPM_INSTALL_DIR}
    GIT_REPOSITORY      ${LPM_GIT_URL}
    GIT_TAG             ${LPM_GIT_TAG}         
    CONFIGURE_COMMAND   ${LPM_CONFIGURE}
    BUILD_COMMAND       ${LPM_MAKE}
    INSTALL_COMMAND     ${LPM_INSTALL}
)

# must have this otherwise the find_package(Protobuf) will fail inside libprotobuf-mutator CMake build
#   if using protobuf from another source, set PROTOBUF_TARGET to the appropriate libprotobuf target
add_dependencies(${LPM_TARGET} ${PROTOBUF_TARGET})

set(CMAKE_IMPORT_FILE_VERSION)

cmake_policy(POP)
