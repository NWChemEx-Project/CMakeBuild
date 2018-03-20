# - Try to find Global Arrays
#
#  The user may specify GLOBALARRAYS_ROOT_DIR to aid find_packge in
#  finding an already installed Global Arrays
#
#  Once done this will define
#  GLOBALARRAYS_FOUND - System has Global Arrays
#  GLOBALARRAYS_CONFIG - The ga-config binary path
#  GLOBALARRAYS_INCLUDE_DIR - The Global Arrays include directories
#  GLOBALARRAYS_LIBRARIES - The libraries needed to use Global Arrays

if(NOT DEFINED GLOBALARRAYS_ROOT_DIR)
    find_package(PkgConfig)
    pkg_check_modules(PC_GLOBALARRAYS QUIET ga)
endif()

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

find_path(GLOBALARRAYS_INCLUDE_DIR ga.h
          HINTS ${PC_GLOBALARRAYS_INCLUDEDIR}
                ${PC_GLOBALARRAYS_INCLUDE_DIRS}
          PATHS ${GLOBALARRAYS_ROOT_DIR}
         )

find_path(GLOBALARRAYS_CONFIG ga-config
         HINTS ${PC_GLOBALARRAYS_BINDIR}
               ${PC_GLOBALARRAYS_BIN_DIRS}
         PATHS ${GLOBALARRAYS_ROOT_DIR} 
         PATH_SUFFIXES bin
        )         

find_library(GLOBALARRAYS_C_LIBRARY NAMES ga
             HINTS ${PC_GLOBALARRAYS_LIBDIR}
                   ${PC_GLOBALARRAYS_LIBRARY_DIRS}
             PATHS ${GLOBALARRAYS_ROOT_DIR}
        )

find_library(GLOBALARRAYS_ARMCI_LIBRARY NAMES armci
             HINTS ${PC_GLOBALARRAYS_LIBDIR}
                   ${PC_GLOBALARRAYS_LIBRARY_DIRS}
             PATHS ${GLOBALARRAYS_ROOT_DIR}
        )

set(GLOBALARRAYS_LIBRARIES ${GLOBALARRAYS_C_LIBRARY}
                           ${GLOBALARRAYS_ARMCI_LIBRARY} 
                           ${CMAKE_THREAD_LIBS_INIT})

find_package(LibRT)
if(LIBRT_LIBRARIES)
  set(GLOBALARRAYS_LIBRARIES ${GLOBALARRAYS_LIBRARIES} ${LIBRT_LIBRARIES})
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GlobalArrays DEFAULT_MSG
                                  GLOBALARRAYS_LIBRARIES
                                  GLOBALARRAYS_INCLUDE_DIR
                                  GLOBALARRAYS_CONFIG
)
set(GLOBALARRAYS_INCLUDE_DIRS ${GLOBALARRAYS_INCLUDE_DIR})
set(GLOBALARRAYS_FOUND ${GlobalArrays_FOUND})

#Get GA + dependent libs using ga-config script
#Usually the dependent libs are MPI, blas, lapack, pthreads, librt
#The ga-config script does not need to verify that these dependency libs actually exist since
#that is already done by the corresponding FindPackage module and passed to GA configure in BuildGlobalArrays.cmake
execute_process(COMMAND ${GLOBALARRAYS_CONFIG}/ga-config --libs OUTPUT_VARIABLE GA_CONFIG_LIBS OUTPUT_STRIP_TRAILING_WHITESPACE)
execute_process(COMMAND ${GLOBALARRAYS_CONFIG}/ga-config --ldflags OUTPUT_VARIABLE GA_CONFIG_LDFLAGS OUTPUT_STRIP_TRAILING_WHITESPACE)

#Linker options for Threads & librt will be provided through ga-config in the next release (5.6.4) of GA
set(GLOBALARRAYS_LIBRARIES ${GLOBALARRAYS_LIBRARIES} ${GA_CONFIG_LDFLAGS} ${GA_CONFIG_LIBS})



