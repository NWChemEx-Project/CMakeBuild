
include(ExternalProject)
find_package(GTest)

#GTEST_FOUND,GTEST_INCLUDE_DIRS,GTEST_LIBRARIES,GTEST_MAIN_LIBRARIES,GTEST_BOTH_LIBRARIES

if(NOT NWX_PROC_COUNT)
    set(NWX_PROC_COUNT 2)
endif()

if(GTEST_FOUND)
   add_library(gtest_nwx INTERFACE)
else()
    set(GTEST_INSTALL_PATH ${CMAKE_INSTALL_PREFIX}/googletest)
    message(STATUS "Building GOOGLETEST at: ${GTEST_INSTALL_PATH}")
    set(GTEST_PREFIX ${PROJECT_BINARY_DIR}/external/googletest)

    ExternalProject_Add(gtest_nwx
        URL https://github.com/google/googletest/archive/release-1.8.0.tar.gz
        SOURCE_DIR ${GTEST_PREFIX}
        UPDATE_COMMAND mkdir -p "${GTEST_PREFIX}/build"
        BINARY_DIR ${GTEST_PREFIX}/build
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
        -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_INSTALL_PREFIX=${GTEST_INSTALL_PATH}
        BUILD_COMMAND ${CMAKE_MAKE_PROGRAM} -j${NWX_PROC_COUNT}
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install
    )
endif()
