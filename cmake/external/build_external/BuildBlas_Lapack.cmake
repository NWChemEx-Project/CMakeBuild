
include(ExternalProject)

if (BLAS_INCLUDE_PATH AND BLAS_LIBRARY_PATH AND BLAS_LIBRARIES AND LAPACK_LIBRARIES)
    add_library(blas_lapack${TARGET_SUFFIX} INTERFACE)
elseif(BUILD_NETLIB_BLAS_LAPACK)
    set(BLAS_LAPACK_ROOT_DIR ${CMAKE_INSTALL_PREFIX}/blas_lapack)
    message(STATUS "Building BLAS+LAPACK at: ${BLAS_LAPACK_ROOT_DIR}")

    ExternalProject_Add(blas_lapack${TARGET_SUFFIX}
        URL http://www.netlib.org/lapack/lapack-3.7.1.tgz
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=RELEASE -DCBLAS=ON -DBUILD_TESTING=OFF 
        -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
        -DLAPACKE=ON -DCMAKE_INSTALL_PREFIX=${BLAS_LAPACK_ROOT_DIR}
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
        )
else()
    message(FATAL_ERROR "Please provide the BLAS/LAPACK cmake variables specified or 
    set BUILD_NETLIB_BLAS_LAPACK to ON if you the NWChemEx build to install Netlib BLAS and LAPACK.")
endif()
