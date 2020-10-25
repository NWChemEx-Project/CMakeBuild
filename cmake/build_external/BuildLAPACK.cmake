
find_or_build_dependency(BLAS)
package_dependency(BLAS DEPENDENCY_PATHS)
enable_language(C Fortran)

set(LAPACK_URL https://github.com/Reference-LAPACK/lapack/archive/v3.9.0.tar.gz)

# append platform-specific optimization options for non-Debug builds
set(LAPACK_FLAGS "-Wno-unused-variable -O3")
if(CMAKE_POSITION_INDEPENDENT_CODE)
    set(LAPACK_FLAGS "${LAPACK_FLAGS} -fPIC")
endif()

if(CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
    set(LAPACK_FLAGS "-xHost ${LAPACK_FLAGS}")
elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "ppc64le")
    set(LAPACK_FLAGS "-mtune=native ${LAPACK_FLAGS}")
else()
    set(LAPACK_FLAGS "-march=native ${LAPACK_FLAGS}")
endif()
set(CXX_FLAGS_INIT "${CMAKE_CXX_FLAGS_INIT} ${LAPACK_FLAGS}")

ExternalProject_Add(LAPACK_External
        URL ${LAPACK_URL}
        # UPDATE_DISCONNECTED 1
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=RELEASE
                   -DUSE_OPTIMIZED_BLAS=ON
                   -DBLAS_LIBRARIES=${BLAS_LIBRARIES}
                   -DBUILD_TESTING=OFF
                   -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
                   -DCMAKE_C_FLAGS=${LAPACK_FLAGS}
                   -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
                   -DCMAKE_Fortran_FLAGS=${LAPACK_FLAGS}
                   -DLAPACKE=OFF
                   -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        MAKE_COMMAND $(MAKE)
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install #DESTDIR=${STAGE_DIR}
        CMAKE_CACHE_ARGS ${DEPENDENCY_PATHS} ${CORE_CMAKE_LISTS} ${CORE_CMAKE_STRINGS}
        )

add_dependencies(LAPACK_External BLAS_External)