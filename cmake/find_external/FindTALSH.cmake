# - Try to find TAL_SH Library
#
#  To aid find_package in locating TAL_SH, the user may set the
#  variable TALSH_ROOT_DIR to the root of the TAL_SH install
#  directory.
#
#  Once done this will define
#  TALSH_FOUND - System has TAL_SH
#  TALSH_INCLUDE_DIR - The TAL_SH include directories
#  TALSH_LIBRARY - The library needed to use TAL_SH

set(TALSH_HINTS ${STAGE_DIR}${CMAKE_INSTALL_PREFIX} ${CMAKE_INSTALL_PREFIX})

find_path(TALSH_INCLUDE_DIR talsh.h
          HINTS ${TALSH_HINTS}
          PATHS ${TALSH_ROOT_DIR}
          PATH_SUFFIXES include
          NO_DEFAULT_PATH
          )

find_library(TALSH_LIBRARY
             NAMES talsh
             HINTS ${TALSH_HINTS}
             PATHS ${TALSH_ROOT_DIR}
             PATH_SUFFIXES lib lib32 lib64
             NO_DEFAULT_PATH
	      )


include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(TALSH DEFAULT_MSG
                                  TALSH_LIBRARY
                                  TALSH_INCLUDE_DIR)

find_package(CUDA REQUIRED)
find_package(OpenMP REQUIRED)

set(TALSH_LIBRARIES ${TALSH_LIBRARY} ${CUDA_LIBRARIES} ${CUDA_CUBLAS_LIBRARIES} ${OpenMP_CXX_FLAGS})
set(TALSH_INCLUDE_DIRS ${TALSH_INCLUDE_DIR} ${CUDA_INCLUDE_DIRS})

set(TALSH_COMPILE_DEFINITIONS USE_TALSH)

if(USE_CUTENSOR)
      set(TALSH_INCLUDE_DIRS ${TALSH_INCLUDE_DIRS} ${CUTENSOR_INSTALL_PREFIX}/include)
      set(TALSH_COMPILE_DEFINITIONS USE_TALSH USE_CUTENSOR)
endif()



