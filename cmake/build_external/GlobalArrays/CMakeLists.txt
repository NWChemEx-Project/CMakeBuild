cmake_minimum_required(VERSION ${CMAKE_VERSION})
project(GlobalArrays VERSION 5.8 LANGUAGES C CXX Fortran)

include(DependencyMacros)
include(ExternalProject)


if( BLAS_LIBRARIES )
  set( blas_LIBRARIES ${BLAS_LIBRARIES} )
endif()

if( LAPACK_LIBRARIES )
  set( lapack_LIBRARIES ${LAPACK_LIBRARIES} )
endif()

set(_GA_DEPS LAPACK BLAS MPI)
if (USE_SCALAPACK)
  list(INSERT _GA_DEPS 0 ScaLAPACK)
endif()

foreach(depend ${_GA_DEPS})
  cmsb_find_dependency(${depend})
  makify_dependency(${depend} ${depend}_INCS ${depend}_LIBS)
endforeach()

set(GA_BLAS "--with-blas8=${BLAS_LIBS}")
if(BLAS_INT4)
  set(GA_BLAS "--with-blas4=${BLAS_LIBS}")
endif()

set(GA_LAPACK "--with-lapack=${LAPACK_LIBS}")

if (USE_SCALAPACK) 
  set(GA_SCALAPACK "--with-scalapack8=${ScaLAPACK_LIBS}")
  if(BLAS_INT4)
    set(GA_SCALAPACK "--with-scalapack=${ScaLAPACK_LIBS}")
  endif()
else()
  set(GA_SCALAPACK "--without-scalapack")
endif()

set(GA_MPI "--with-mpi=${MPI_INCS} ${MPI_LIBS}")

set(GA_SYSVSHMEM "ARMCI_DEFAULT_SHMMAX_UBOUND=131072")

if (USE_OFFLOAD)
  set(GA_OFFLOAD "INTEL_64ALIGN=1")
endif()

set(GA_CXXFLAGS "${CMAKE_CXX_FLAGS} -fPIC")
set(GA_CFLAGS "${CMAKE_C_FLAGS} -fPIC")
set(GA_FFLAGS "${CMAKE_Fortran_Flags} -fPIC")

string (STRIP ${GA_CXXFLAGS} GA_CXXFLAGS)
string (STRIP ${GA_CFLAGS} GA_CFLAGS)
string (STRIP ${GA_FFLAGS} GA_FFLAGS)


# Build GA
set(GA_INSTALL_DIR ${STAGE_DIR}${CMAKE_INSTALL_PREFIX})

if(USE_GA_DEV)
    if(USE_GA_PROFILER)
        set(GA_PROFILER_CONFIG "--enable-profiling")
    endif()
    ExternalProject_Add(GlobalArrays_External
        #URL https://github.com/GlobalArrays/ga/releases/download/v${PROJECT_VERSION}/ga-${PROJECT_VERSION}.tar.gz
        GIT_REPOSITORY https://github.com/GlobalArrays/ga.git
        GIT_TAG develop
        UPDATE_DISCONNECTED 1        
        PATCH_COMMAND ./autogen.sh
        CONFIGURE_COMMAND                      
        CC=${CMAKE_C_COMPILER}
        CFLAGS=${GA_CFLAGS}
        CXX=${CMAKE_CXX_COMPILER}
        # CXXFLAGS=${GA_CXXFLAGS}
        F77=${CMAKE_Fortran_COMPILER}
        FFLAGS=${GA_FFLAGS} ./configure --with-tcgmsg
                                      ${GA_MPI}
                                      ${GA_PROFILER_CONFIG}
                                      --enable-underscoring
                                      --disable-mpi-tests
                                      --prefix=${GA_INSTALL_DIR}
                                      ${GA_SCALAPACK}
                                      ${GA_BLAS}
                                      ${GA_LAPACK}
                                      ${GA_RUNTIME}
                                      ${GA_OFFLOAD}
                                      ${GA_SYSVSHMEM}
                 
        BUILD_IN_SOURCE 1
        #LOG_CONFIGURE 1
        #LOG_BUILD 1
    )


else()

    ExternalProject_Add(GlobalArrays_External
        URL https://github.com/GlobalArrays/ga/releases/download/v${PROJECT_VERSION}/ga-${PROJECT_VERSION}.tar.gz
        CONFIGURE_COMMAND                      
        CC=${CMAKE_C_COMPILER}
        CFLAGS=${GA_CFLAGS}
        CXX=${CMAKE_CXX_COMPILER}
        # CXXFLAGS=${GA_CXXFLAGS}
        F77=${CMAKE_Fortran_COMPILER}
        FFLAGS=${GA_FFLAGS} ./configure --with-tcgmsg
                                    ${GA_MPI}
                                    --enable-underscoring
                                    --disable-mpi-tests
                                    --prefix=${GA_INSTALL_DIR}
                                    ${GA_SCALAPACK}
                                    ${GA_BLAS}
                                    ${GA_LAPACK}
                                    ${GA_RUNTIME}
                                    ${GA_OFFLOAD}
                                    ${GA_SYSVSHMEM}
                
        BUILD_IN_SOURCE 1
        #LOG_CONFIGURE 1
        #LOG_BUILD 1
    )

endif()
