cmake_policy(PUSH)
cmake_policy(SET CMP0074 NEW)
include(ExternalProject)

set(LPM_TARGET libprotobuf-mutator)
set(LPM_EXTERNAL libprotobuf-mutator-src)
set(LPM_INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/_deps/${LPM_EXTERNAL})
set(LPM_INCLUDE_DIRS ${LPM_INSTALL_DIR})
# set(LPM_LIB_DIR ${LPM_INSTALL_DIR}/lib)

# include_directories(${LPM_INCLUDE_DIR})

# # Commands may need to know the format version.
# set(CMAKE_IMPORT_FILE_VERSION 1)

# # Protect against multiple inclusion, which would fail when already imported targets are added once more.
# set(_targetsDefined)
# set(_targetsNotDefined)
# set(_expectedTargets)
# foreach(_expectedTarget libprotobuf-mutator::protobuf-mutator-libfuzzer libprotobuf-mutator::protobuf-mutator)
#   list(APPEND _expectedTargets ${_expectedTarget})
#   if(NOT TARGET ${_expectedTarget})
#     list(APPEND _targetsNotDefined ${_expectedTarget})
#   endif()
#   if(TARGET ${_expectedTarget})
#     list(APPEND _targetsDefined ${_expectedTarget})
#   endif()
# endforeach()
# if("${_targetsDefined}" STREQUAL "${_expectedTargets}")
#   unset(_targetsDefined)
#   unset(_targetsNotDefined)
#   unset(_expectedTargets)
#   set(CMAKE_IMPORT_FILE_VERSION)
#   cmake_policy(POP)
#   return()
# endif()
# if(NOT "${_targetsDefined}" STREQUAL "")
#   message(FATAL_ERROR "Some (but not all) targets in this export set were already defined.\nTargets Defined: ${_targetsDefined}\nTargets not yet defined: ${_targetsNotDefined}\n")
# endif()
# unset(_targetsDefined)
# unset(_targetsNotDefined)
# unset(_expectedTargets)

# # Create ${LPM_INCLUDE_DIR}/src to bypass check of INTERFACE_INCLUDE_DIRECTORIES in set_target_properties()
# file(MAKE_DIRECTORY ${LPM_INCLUDE_DIR}/src)

# # Create imported target libprotobuf-mutator::protobuf-mutator-libfuzzer
# add_library(libprotobuf-mutator::protobuf-mutator-libfuzzer STATIC IMPORTED)

# set_target_properties(libprotobuf-mutator::protobuf-mutator-libfuzzer PROPERTIES
#   INTERFACE_INCLUDE_DIRECTORIES "${LPM_INCLUDE_DIR};${LPM_INCLUDE_DIR}/src"
#   INTERFACE_LINK_LIBRARIES "libprotobuf-mutator::protobuf-mutator;protobuf"
# )

# # Create imported target libprotobuf-mutator::protobuf-mutator
# add_library(libprotobuf-mutator::protobuf-mutator STATIC IMPORTED)

# set_target_properties(libprotobuf-mutator::protobuf-mutator PROPERTIES
#   INTERFACE_INCLUDE_DIRECTORIES "${LPM_INCLUDE_DIR};${LPM_INCLUDE_DIR}/src"
#   INTERFACE_LINK_LIBRARIES "protobuf"
# )

# # Import target "libprotobuf-mutator::protobuf-mutator-libfuzzer" for configuration ""
# set_property(TARGET libprotobuf-mutator::protobuf-mutator-libfuzzer APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
# set_target_properties(libprotobuf-mutator::protobuf-mutator-libfuzzer PROPERTIES
#   IMPORTED_LINK_INTERFACE_LANGUAGES_NOCONFIG "CXX"
#   IMPORTED_LOCATION_NOCONFIG "${LPM_LIB_DIR}/libprotobuf-mutator-libfuzzer.a"
#   )

# list(APPEND _IMPORT_CHECK_TARGETS libprotobuf-mutator::protobuf-mutator-libfuzzer )
# list(APPEND _IMPORT_CHECK_FILES_FOR_libprotobuf-mutator::protobuf-mutator-libfuzzer "${_IMPORT_PREFIX}/lib/libprotobuf-mutator-libfuzzer.a" )

# # Import target "libprotobuf-mutator::protobuf-mutator" for configuration ""
# set_property(TARGET libprotobuf-mutator::protobuf-mutator APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
# set_target_properties(libprotobuf-mutator::protobuf-mutator PROPERTIES
#   IMPORTED_LINK_INTERFACE_LANGUAGES_NOCONFIG "CXX"
#   IMPORTED_LOCATION_NOCONFIG "${LPM_LIB_DIR}/libprotobuf-mutator.a"
#   )

# list(APPEND _IMPORT_CHECK_TARGETS libprotobuf-mutator::protobuf-mutator )
# list(APPEND _IMPORT_CHECK_FILES_FOR_libprotobuf-mutator::protobuf-mutator "${LPM_LIB_DIR}/libprotobuf-mutator.a" )

FIND_PACKAGE(Protobuf CONFIG REQUIRED)
include(FetchContent)
set(LIB_PROTO_MUTATOR_DOWNLOAD_PROTOBUF CACHE INTERNAL OFF)
set(LIB_PROTO_MUTATOR_TESTING CACHE INTERNAL OFF)
message(STATUS "Fetching libprotobuf-mutator...")
FetchContent_Declare(${LPM_TARGET}
  GIT_REPOSITORY "https://github.com/mzakocs/libprotobuf-mutator.git"
  GIT_TAG "master"
  GIT_SHALLOW TRUE
  GIT_SUBMODULES ""
  OVERRIDE_FIND_PACKAGE
)
FetchContent_MakeAvailable(${LPM_TARGET})

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)

cmake_policy(POP)





