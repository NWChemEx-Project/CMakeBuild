
include(ExternalProject)
find_package(GTest)

#GTEST_FOUND,GTEST_INCLUDE_DIRS,GTEST_LIBRARIES,GTEST_MAIN_LIBRARIES,GTEST_BOTH_LIBRARIES

if(GTEST_FOUND)
   add_library(gtest_nwx INTERFACE)
else()
    set(GTEST_ROOT_DIR ${CMAKE_INSTALL_PREFIX}/googletest)
    message(STATUS "Building GOOGLETEST at: ${GTEST_ROOT_DIR}")

    ExternalProject_Add(gtest_nwx
        URL https://github.com/google/googletest/archive/release-1.8.0.tar.gz
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
        -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_INSTALL_PREFIX=${GTEST_ROOT_DIR}
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install
    )
endif()
