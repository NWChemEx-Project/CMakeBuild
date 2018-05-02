cmake_minimum_required(VERSION ${CMAKE_VERSION})
project(GlobalArrays VERSION 5.7 LANGUAGES C Fortran)

include(DependencyMacros)
include(ExternalProject)
foreach(depend NWX_MPI CBLAS LAPACKE )#ScaLAPACK)
    find_dependency(${depend})
    makify_dependency(${depend} ${depend}_INCS ${depend}_LIBS)
endforeach()

#string(REPLACE ";" " " GA_ScaLAPACK_LIBRARIES "${ScaLAPACK_LIBRARIES}")
#set(GA_SCALAPACK "--with-scalapack8=${GA_ScaLAPACK_LIBRARIES}")

set(GA_BLAS "--with-blas8=${CBLAS_LIBS}")
set(GA_LAPACK "--with-lapack=${LAPACKE_LIBS}")
set(GA_MPI "--with-mpi=${NWX_MPI_INCS} ${NWX_MPI_LIBS}")

set(GA_SYSVSHMEM "ARMCI_DEFAULT_SHMMAX_UBOUND=131072")

if (USE_OFFLOAD)
    set(GA_OFFLOAD "INTEL_64ALIGN=1")
endif()

set(GA_CXXFLAGS "${CMAKE_CXX_FLAGS} -fPIC")
set(GA_CFLAGS "${CMAKE_C_FLAGS} -fPIC")
set(GA_FFLAGS "${CMAKE_Fortran_Flags} -fPIC")


# Build GA
set(GA_INSTALL_DIR ${STAGE_DIR}${CMAKE_INSTALL_PREFIX})
ExternalProject_Add(GlobalArrays_External
        URL https://github.com/GlobalArrays/ga/releases/download/v${PROJECT_VERSION}/ga-${PROJECT_VERSION}.tar.gz
        CONFIGURE_COMMAND ./configure --with-tcgmsg
                                      ${GA_MPI}
                                      --enable-underscoring
                                      --disable-mpi-tests
                                      --prefix=${GA_INSTALL_DIR}
                                      ${GA_SCALAPACK}
                                      ${GA_BLAS}
                                      ${GA_LAPACK}
                                      ${ARMCI_NETWORK}
                                      ${GA_OFFLOAD}
                                      ${GA_SYSVSHMEM}
                                      CC=${CMAKE_C_COMPILER}
                                      CFLAGS=${GA_CFLAGS}
                                      CXX=${CMAKE_CXX_COMPILER}
                                      CXXFLAGS=${GA_CXXFLAGS}
                                      F77=${CMAKE_Fortran_COMPILER}
                                      FFLAGS=${GA_FFLAGS}
        BUILD_IN_SOURCE 1
        #LOG_CONFIGURE 1
        #LOG_BUILD 1
        )
