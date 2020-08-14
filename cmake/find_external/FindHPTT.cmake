# - Try to find HPTT Library
#
#  To aid find_package in locating HPTT, the user may set the
#  variable HPTT_ROOT_DIR to the root of the HPTT install
#  directory.
#
#  Once done this will define
#  HPTT_FOUND - System has HPTT
#  HPTT_INCLUDE_DIR - The HPTT include directories
#  HPTT_LIBRARY - The library needed to use HPTT

set(HPTT_HINTS ${STAGE_DIR}${CMAKE_INSTALL_PREFIX} ${CMAKE_INSTALL_PREFIX})

find_path(HPTT_INCLUDE_DIR hptt/hptt.h
          HINTS ${HPTT_HINTS}
          PATHS ${HPTT_ROOT_DIR}
          PATH_SUFFIXES include
          DOC "HPTT header"          
          NO_DEFAULT_PATH
          )

find_library(HPTT_LIBRARY
             NAMES hptt
             HINTS ${HPTT_HINTS}
             PATHS ${HPTT_ROOT_DIR}
             PATH_SUFFIXES lib lib64 lib32             
             DOC "HPTT Library"
             NO_DEFAULT_PATH
	  )


include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(HPTT DEFAULT_MSG
                                  HPTT_LIBRARY
                                  HPTT_INCLUDE_DIR)

if(USE_OPENMP)                                  
      find_package(OpenMP REQUIRED)
endif()

set(HPTT_LIBRARIES ${HPTT_LIBRARY} ${OpenMP_CXX_FLAGS})
set(HPTT_INCLUDE_DIRS ${HPTT_INCLUDE_DIR})
