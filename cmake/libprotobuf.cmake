set(PROTOBUF_TARGET Protobuf)
set(PROTOBUF_EXTERNAL protobuf-src)
set(PROTOBUF_INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/_deps/${PROTOBUF_EXTERNAL})
set(PROTOBUF_INCLUDE_DIRS ${PROTOBUF_INSTALL_DIR}/src)
# include_directories(${PROTOBUF_INCLUDE_DIRS})


# IF(CMAKE_BUILD_TYPE MATCHES Debug)
#   set(PROTOBUF_LIBRARY protobufd)
# ELSE()
#   set(PROTOBUF_LIBRARY protobuf)
# ENDIF()
# set(LIB_PATH ${PROTOBUF_INSTALL_DIR}/lib/lib${PROTOBUF_LIBRARY}.a)
# add_library(protobuf STATIC IMPORTED)
# set_property(TARGET protobuf PROPERTY IMPORTED_LOCATION ${LIB_PATH})
# add_dependencies(protobuf ${PROTOBUF_TARGET})

# set(PROTOBUF_PROTOC_EXECUTABLE ${PROTOBUF_INSTALL_DIR}/bin/protoc)
# list(APPEND PROTOBUF_BUILD_BYPRODUCTS ${PROTOBUF_PROTOC_EXECUTABLE})

# set(PROTOBUF_PROTOC_TARGET protoc)
# if(NOT TARGET ${PROTOBUF_PROTOC_TARGET})
#   add_executable(${PROTOBUF_PROTOC_TARGET} IMPORTED)
# endif()
# set_property(TARGET ${PROTOBUF_PROTOC_TARGET} PROPERTY IMPORTED_LOCATION
#              ${PROTOBUF_PROTOC_EXECUTABLE})
# add_dependencies(${PROTOBUF_PROTOC_TARGET} ${PROTOBUF_TARGET})

# include (ExternalProject)
# ExternalProject_Add(${PROTOBUF_TARGET}
#     PREFIX ${PROTOBUF_INSTALL_DIR}
#     GIT_REPOSITORY https://github.com/google/protobuf.git
#     GIT_TAG v21.12 # pre-absl version
#     CONFIGURE_COMMAND ${CMAKE_COMMAND} ${PROTOBUF_INSTALL_DIR}/src/${PROTOBUF_TARGET}
#         -G${CMAKE_GENERATOR}
#         -DCMAKE_INSTALL_PREFIX=${PROTOBUF_INSTALL_DIR}
#         -DCMAKE_INSTALL_LIBDIR=lib
#         -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
#         -DCMAKE_POSITION_INDEPENDENT_CODE=ON
#         -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
#         -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
#         -DCMAKE_C_FLAGS=${PROTOBUF_CFLAGS}
#         -DCMAKE_CXX_FLAGS=${PROTOBUF_CXXFLAGS}
#         -Dprotobuf_BUILD_TESTS=OFF
#     BUILD_BYPRODUCTS ${PROTOBUF_BUILD_BYPRODUCTS}
# )
include(FetchContent)
set(protobuf_BUILD_TESTS CACHE INTERNAL OFF)
message(STATUS "Fetching libprotobuf...")
FetchContent_Declare(${PROTOBUF_TARGET}
  GIT_REPOSITORY "http://github.com/protocolbuffers/protobuf.git"
  GIT_TAG "v21.12" # NOTE: Do not try to get post-absl versions of protobuf working. Believe me it's not worth it
  PATCH_COMMAND git apply --ignore-whitespace "${CMAKE_CURRENT_LIST_DIR}/0001-protobuf-generate-libprotobuf.patch"
  GIT_SHALLOW TRUE
  GIT_SUBMODULES ""
  OVERRIDE_FIND_PACKAGE
)
FetchContent_MakeAvailable(${PROTOBUF_TARGET})
# target_include_directories(${PROTOBUF_TARGET} ${PROTOBUF_INCLUDE_DIR})
# set(Protobuf_INCLUDE_DIR ${PROTOBUF_INCLUDE_DIR})
# set(Protobuf_LIBRARIES ${PROTOBUF_LIBRARIES})
# set(Protobuf_PROTOC_EXECUTABLE ${PROTOBUF_PROTOC_EXECUTABLE})
# list(APPEND CMAKE_PREFIX_PATH ${PROTOBUF_INSTALL_DIR})

#set(absl_ROOT ${PROTOBUF_INSTALL_DIR}/lib/cmake/absl/)
#set(absl_INCLUDE_DIRS ${Protobuf_INCLUDE_DIRS}/absl)
#set(absl_LIBRARIES ${Protobuf_LIBRARIES})
#list(APPEND CMAKE_PREFIX_PATH ${PROTOBUF_INSTALL_DIR}/lib/cmake/absl/)
