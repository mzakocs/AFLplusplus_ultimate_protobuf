set(LPM_TARGET libprotobuf-mutator)
set(LPM_INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/_deps)
set(LPM_SRC_DIR ${LPM_INSTALL_DIR}/libprotobuf-mutator-src)
set(LPM_INCLUDE_DIRS ${LPM_SRC_DIR})
set(FETCHCONTENT_BASE_DIR ${LPM_INSTALL_DIR})

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





