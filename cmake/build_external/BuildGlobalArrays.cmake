#
# This file builds Global Arrays.
#
include(UtilityMacros)
include(DependencyMacros)

enable_language(Fortran)

# Now find or build GA's dependencies
# foreach(depend BLAS LAPACK NWX_MPI)
#     find_or_build_dependency(${depend})
#     package_dependency(${depend} DEPENDENCY_PATHS)
# endforeach()

# Get index user choose
is_valid_and_true(ARMCI_NETWORK __set)
if (NOT __set)
    message(STATUS "ARMCI network not set, defaulting to MPI_PROGRESS_RANK")
    set(ARMCI_NETWORK MPI_PROGRESS_RANK)
endif()

set(GA_REPO "https://github.com/GlobalArrays/ga.git")
if(USE_GA_DEV)
    set(GA_REPO "https://github.com/ajaypanyala/ga.git")
endif()

if(GCCROOT)
    set(Clang_GCCROOT "-DGCCROOT=${GCCROOT}")
endif()

if(DEFINED TAMM_EXTRA_LIBS)
    set(GA_CMB_EXTRA_LIBS "-DGA_EXTRA_LIBS=${TAMM_EXTRA_LIBS}")
endif()

if(${BLAS_VENDOR} STREQUAL "ReferenceBLAS")
    find_or_build_dependency(BLAS)
    find_or_build_dependency(LAPACK)
    # We not support externally provided Ref. BLAS for now.
    set(GA_BLASROOT "-DReferenceBLASROOT=${CMAKE_INSTALL_PREFIX}")
    set(GA_LAPACKROOT "-DReferenceLAPACKROOT=${CMAKE_INSTALL_PREFIX}")
endif()

if(USE_DPCPP)
    set(GA_DPCPP "-DENABLE_DPCPP=ON")
endif()

message(STATUS ${CMAKE_BINARY_DIR}/stage)
ExternalProject_Add(GlobalArrays_External
    # # URL https://github.com/GlobalArrays/ga/releases/download/v${PROJECT_VERSION}/ga-${PROJECT_VERSION}.tar.gz
    GIT_REPOSITORY ${GA_REPO}
    GIT_TAG develop
    UPDATE_DISCONNECTED 1
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS} -DENABLE_CXX=ON -DENABLE_BLAS=ON -DBLAS_VENDOR=${BLAS_VENDOR} ${GA_BLASROOT} ${GA_LAPACKROOT}
    ${GA_DPCPP} -DGA_RUNTIME=${ARMCI_NETWORK} -DENABLE_PROFILING=${USE_GA_PROFILER} ${GA_CMB_EXTRA_LIBS} ${Clang_GCCROOT}
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                    ${CORE_CMAKE_STRINGS}
)

# # Establish the dependencies
if(${BLAS_VENDOR} STREQUAL "ReferenceBLAS")
 add_dependencies(GlobalArrays_External BLAS_External
                                        LAPACK_External)
endif()


