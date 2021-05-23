#
# This file will build Netlib's ScaLAPACK distribution over 
# an existing BLAS and LAPACK installation.
#
enable_language(C Fortran)
foreach(depend BLAS LAPACK)
    find_or_build_dependency(${depend})
    package_dependency(${depend} DEPENDENCY_PATHS)
endforeach()


# set(ScaLAPACK_URL https://github.com/Reference-ScaLAPACK/scalapack)
set(ScaLAPACK_URL https://github.com/NWChemEx-Project/scalapack)

# append platform-specific optimization options for non-Debug builds
# set(ScaLAPACK_FLAGS "-Wno-unused-variable -O3")

if(CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
    set(ScaLAPACK_FLAGS "-xHost ${ScaLAPACK_FLAGS}")
elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "ppc64le")
    set(ScaLAPACK_FLAGS "-mtune=native ${ScaLAPACK_FLAGS}")
else()
    set(ScaLAPACK_FLAGS "-march=native SCALAPACK_F_FLAGS")
endif()
set(CXX_FLAGS_INIT "${CMAKE_CXX_FLAGS_INIT} ${ScaLAPACK_FLAGS}")
set(SCALAPACK_F_FLAGS ${SCALAPACK_FLAGS})

if(NOT BLAS_INT4)
    set(ScaLAPACK_BUILD_INDEX64 "-DInt=long")
    set(ScaLAPACK_FLAGS "-DInt=long ${ScaLAPACK_FLAGS}")
    if( CMAKE_Fortran_COMPILER_ID MATCHES "GNU" OR CMAKE_Fortran_COMPILER_ID MATCHES "Flang" )
        set( _FFD8 "-fdefault-integer-8" )
    elseif( CMAKE_Fortran_COMPILER_ID MATCHES "PGI" )
        set( _FFD8 "-i8" )
    endif()
    set(ScaLAPACK_F_FLAGS "${_FFD8} ${ScaLAPACK_F_FLAGS}")
endif()

ExternalProject_Add(ScaLAPACK_External
                GIT_REPOSITORY ${ScaLAPACK_URL}
                UPDATE_DISCONNECTED 1
                CMAKE_ARGS
                    ${DEPENDENCY_CMAKE_OPTIONS}
                   -DTEST_SCALAPACK=OFF
                   -DSCALAPACK_BUILD_TESTS=OFF
                   -DSCALAPACK_BUILD_TESTING=OFF
                   -DUSE_OPTIMIZED_LAPACK_BLAS=ON
                   #-DBUILD_SHARED_LIBS=OFF
                   -DCMAKE_C_FLAGS=${SCALAPACK_FLAGS}
                   -DCMAKE_Fortran_FLAGS=${SCALAPACK_F_FLAGS}
                #    -DBLAS_LIBRARIES=${BLAS_LIBRARIES}
                #    -DLAPACK_LIBRARIES=${LAPACK_LIBRARIES}
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install #DESTDIR=${STAGE_DIR}
        CMAKE_CACHE_ARGS ${DEPENDENCY_PATHS} ${CORE_CMAKE_LISTS} ${CORE_CMAKE_STRINGS}
        )

add_dependencies(ScaLAPACK_External LAPACK_External BLAS_External)


