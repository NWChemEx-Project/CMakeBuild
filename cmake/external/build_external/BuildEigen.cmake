
include(ExternalProject)
find_package(Eigen)

if (EIGEN_FOUND)
    add_library(eigen_nwx INTERFACE)
else()
    set(EIGEN_ROOT_DIR ${CMAKE_INSTALL_PREFIX}/eigen3)
    message(STATUS "Building Eigen3 at: ${EIGEN_ROOT_DIR}")

    ExternalProject_Add(eigen_nwx
        URL http://bitbucket.org/eigen/eigen/get/3.3.4.tar.gz
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
        -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
            -DCMAKE_INSTALL_PREFIX=${EIGEN_ROOT_DIR}
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install
    )
endif()

