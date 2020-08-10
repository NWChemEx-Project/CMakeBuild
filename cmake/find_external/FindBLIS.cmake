# - Try to find BLIS
#
#  In order to aid find_package the user may set BLIS_ROOT_DIR to the root of
#  the installed BLIS.
#
#  Once done this will define
#  BLIS_FOUND - System has BLIS
#  BLIS_INCLUDE_DIR - The BLIS include directories
#  BLIS_LIBRARY - The libraries needed to use BLIS
#  BLIS_COMPILE_DEFINITIONS - BLIS compile definitions

# include(DependencyMacros)

set(BLIS_HINTS ${STAGE_DIR}${CMAKE_INSTALL_PREFIX} ${CMAKE_INSTALL_PREFIX})

find_path(BLIS_INCLUDE_DIR blis/blis.h
            HINTS ${BLIS_HINTS}
            PATHS ${BLIS_ROOT_DIR}
            PATH_SUFFIXES include
            NO_DEFAULT_PATH
          )

find_library(BLIS_LIBRARY 
             NAMES libblis.a blis
             HINTS ${BLIS_HINTS}
             PATHS ${BLIS_ROOT_DIR}
             PATH_SUFFIXES lib lib32 lib64
             NO_DEFAULT_PATH
        )

set(BLIS_LIBRARIES ${BLIS_LIBRARY})
set(BLIS_INCLUDE_DIRS ${BLIS_INCLUDE_DIR})
set(BLIS_COMPILE_DEFINITIONS "USE_BLIS")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(BLIS 
                              REQUIRED_VARS BLIS_LIBRARIES BLIS_INCLUDE_DIR BLIS_COMPILE_DEFINITIONS
                              HANDLE_COMPONENTS)

set(BLIS_FOUND ${BLIS_FOUND})



