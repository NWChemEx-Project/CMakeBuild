find_or_build_dependency(NWX_CBLAS _was_found)

ExternalProject_Add(NWX_LAPACK_External
    URL http://www.netlib.org/lapack/lapack-3.7.1.tgz
    CMAKE_ARGS -DCMAKE_BUILD_TYPE=RELEASE
               -DUSE_OPTIMIZED_BLAS=ON
               -DBUILD_TESTING=OFF
               -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
               -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
               -DLAPACKE=ON
               -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    MAKE_COMMAND $(MAKE)
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    )
add_dependencies(NWX_LAPACK_External NWX_CBLAS_External)
