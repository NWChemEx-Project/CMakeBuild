
include(ExternalProject)

if (SCALAPACK_LIBRARIES)
    add_library(scalapack${TARGET_SUFFIX} INTERFACE)
elseif(BUILD_NETLIB_BLAS_LAPACK)
    set(SCALAPACK_ROOT_DIR ${CMAKE_INSTALL_PREFIX}/scalapack)
    message(STATUS "Building SCALAPACK at: ${SCALAPACK_ROOT_DIR}")

    ExternalProject_Add(scalapack${TARGET_SUFFIX}
        URL http://www.netlib.org/scalapack/scalapack.tgz
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=RELEASE -DBUILD_TESTING=OFF 
        -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
        -DCMAKE_INSTALL_PREFIX=${SCALAPACK_ROOT_DIR}
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}        
    )
else()
    message(ERROR "Please provide the SCALAPACK_LIBRARIES cmake variable or 
    set BUILD_NETLIB_BLAS_LAPACK to ON if you the NWChemEx build to install Netlib SCALAPACK.")

endif()
