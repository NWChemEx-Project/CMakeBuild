
include(ExternalProject)

#Keep it simple for now, build if user does not provide the following cmake variables
if (SCALAPACK_LIBRARY_PATH AND SCALAPACK_LIBRARIES)
    add_library(scalapack${TARGET_SUFFIX} INTERFACE)
else()
    set(SCALAPACK_ROOT_DIR ${CMAKE_INSTALL_PREFIX}/scalapack)
    message(STATUS "Building SCALAPACK at: ${SCALAPACK_ROOT_DIR}")

    ExternalProject_Add(scalapack${TARGET_SUFFIX}
        URL http://www.netlib.org/scalapack/scalapack.tgz
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=RELEASE -DBUILD_TESTING=OFF -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
        -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
        -DCMAKE_INSTALL_PREFIX=${SCALAPACK_ROOT_DIR}
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install
    )

endif()
