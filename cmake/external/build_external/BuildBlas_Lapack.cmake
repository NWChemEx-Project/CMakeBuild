
include(ExternalProject)

if(NOT NWX_PROC_COUNT)
set(NWX_PROC_COUNT 2)
endif()

# TODO: Use find_package
# find_package(BLAS)
# find_package(LAPACK)
# if (BLAS_FOUND AND LAPACK_FOUND)

#Keep it simple for now, build if user does not provide the following cmake variables
if (BLAS_INCLUDE_PATH AND BLAS_LIBRARY_PATH AND BLAS_LIBRARIES AND LAPACK_LIBRARIES)
    add_library(blas_lapack_nwx INTERFACE)
else()
    set(BLAS_LAPACK_INSTALL_PATH ${CMAKE_INSTALL_PREFIX}/blas_lapack)
    message(STATUS "Building BLAS+LAPACK at: ${BLAS_LAPACK_INSTALL_PATH}")
    set(BLAS_LAPACK_PREFIX ${PROJECT_BINARY_DIR}/external/blas_lapack)

    ExternalProject_Add(blas_lapack_nwx
        URL http://www.netlib.org/lapack/lapack-3.7.1.tgz
        SOURCE_DIR ${BLAS_LAPACK_PREFIX}
        UPDATE_COMMAND mkdir -p "${BLAS_LAPACK_PREFIX}/build"
        BINARY_DIR ${BLAS_LAPACK_PREFIX}/build
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=RELEASE -DCBLAS=ON -DBUILD_TESTING=OFF -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
        -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
        -DLAPACKE=ON -DCMAKE_INSTALL_PREFIX=${BLAS_LAPACK_INSTALL_PATH}
        BUILD_COMMAND ${CMAKE_MAKE_PROGRAM} -j${NWX_PROC_COUNT}
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install
    )

    # set(BLAS_INCLUDE_PATH ${BLAS_LAPACK_INSTALL_PATH}/include)
    # set(BLAS_LIBRARY_PATH ${BLAS_LAPACK_INSTALL_PATH}/lib)

endif()
