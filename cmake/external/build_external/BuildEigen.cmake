
include(ExternalProject)
find_package(Eigen_NWX)

if (EIGEN_FOUND)
    add_library(eigen_nwx INTERFACE)
else()
    set(EIGEN3_INSTALL_PATH ${CMAKE_INSTALL_PREFIX}/eigen3)
    message(STATUS "Building Eigen3 at: ${EIGEN3_INSTALL_PATH}")
    set(EIGEN_PREFIX ${PROJECT_BINARY_DIR}/external/eigen)

    ExternalProject_Add(eigen_nwx
        URL http://bitbucket.org/eigen/eigen/get/3.3.4.tar.gz
        SOURCE_DIR ${EIGEN_PREFIX}
        UPDATE_COMMAND mkdir -p "${EIGEN_PREFIX}/build"
        BINARY_DIR ${EIGEN_PREFIX}/build
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
        -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
            -DCMAKE_INSTALL_PREFIX=${EIGEN3_INSTALL_PATH}
        #BUILD_COMMAND ${CMAKE_MAKE_PROGRAM} -j${NWX_PROC_COUNT} blas
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install
    )
endif()

