find_or_build_dependency(NWX_BLAS _was_Found)

enable_language(C Fortran)
#This uses a mock superbuild

ExternalProject_Add(NWX_CBLAS_External
        SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/NWX_CBLAS
        CMAKE_ARGS -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
                   -DCMAKE_C_COMILER=${CMAKE_C_COMPILER}
                   -DSTAGE_DIR=${STAGE_DIR}
                   ${CORE_CMAKE_OPTIONS}
        BUILD_ALWAYS 1
        INSTALL_COMMAND $(MAKE)
        CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                         ${CORE_CMAKE_STRINGS}
        )
add_dependencies(NWX_CBLAS_External NWX_BLAS_External)
