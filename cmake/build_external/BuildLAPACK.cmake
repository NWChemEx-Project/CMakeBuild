
enable_language(C Fortran)
find_or_build_dependency(BLAS)
package_dependency(BLAS DEPENDENCY_PATHS)

set(LAPACK_URL https://github.com/Reference-LAPACK/lapack.git)

# append platform-specific optimization options for non-Debug builds
# set(LAPACK_FLAGS "-Wno-unused-variable")

if(CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
    set(LAPACK_FLAGS "-xHost ${LAPACK_FLAGS}")
elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "ppc64le")
    set(LAPACK_FLAGS "-mtune=native ${LAPACK_FLAGS}")
else()
    set(LAPACK_FLAGS "-march=native ${LAPACK_FLAGS}")
endif()
set(CXX_FLAGS_INIT "${CMAKE_CXX_FLAGS_INIT} ${LAPACK_FLAGS}")

set(LAPACK_BUILD_INDEX64 "-DBUILD_INDEX64=ON")
if(BLAS_INT4)
    set(LAPACK_BUILD_INDEX64 "-DBUILD_INDEX64=OFF")
endif()

ExternalProject_Add(LAPACK_External
        GIT_REPOSITORY ${LAPACK_URL}
        GIT_TAG 8960228bf20c3d5bf718ebd63e92041992bf29d9
        UPDATE_DISCONNECTED 1
        CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS}
                   -DUSE_OPTIMIZED_BLAS=ON
                   -DBLAS_LIBRARIES=${BLAS_LIBRARIES}
                   -DBUILD_TESTING=OFF
                   -DCMAKE_C_FLAGS=${LAPACK_FLAGS}
                   -DCMAKE_Fortran_FLAGS=${LAPACK_FLAGS}
                   -DLAPACKE=OFF
                   ${LAPACK_BUILD_INDEX64}
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install #DESTDIR=${STAGE_DIR}
        CMAKE_CACHE_ARGS ${DEPENDENCY_PATHS} ${CORE_CMAKE_LISTS} ${CORE_CMAKE_STRINGS}
        )

add_dependencies(LAPACK_External BLAS_External)