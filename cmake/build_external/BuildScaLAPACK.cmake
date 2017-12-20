enable_language(C Fortran)
ExternalProject_Add(ScaLAPACK_External
        URL http://www.netlib.org/scalapack/scalapack-2.0.2.tgz
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=RELEASE
                   -DBUILD_TESTING=OFF
                   -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
                   -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
                   -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}        
    )
