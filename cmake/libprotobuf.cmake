set(PROTOBUF_TARGET Protobuf)

set(PROTOBUF_INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/_deps)
set(PROTOBUF_SRC_DIR ${PROTOBUF_INSTALL_DIR}/protobuf-src)
set(PROTOBUF_INCLUDE_DIRS ${PROTOBUF_SRC_DIR}/src)
set(FETCHCONTENT_BASE_DIR ${PROTOBUF_INSTALL_DIR})

include(FetchContent)
set(protobuf_BUILD_TESTS CACHE INTERNAL OFF)
message(STATUS "Fetching libprotobuf...")
FetchContent_Declare(${PROTOBUF_TARGET}
  GIT_REPOSITORY "https://github.com/mzakocs/protobuf.git"
  GIT_TAG "main"
  GIT_SHALLOW TRUE
  GIT_SUBMODULES ""
  OVERRIDE_FIND_PACKAGE
)
FetchContent_MakeAvailable(${PROTOBUF_TARGET})