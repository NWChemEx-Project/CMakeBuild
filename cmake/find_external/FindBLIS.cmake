# - Try to find BLIS
#
#  In order to aid find_package the user may set BLIS_ROOT_DIR to the root of
#  the installed BLIS.
#
#  Once done this will define
#  BLIS_FOUND - System has BLIS
#  BLIS_INCLUDE_DIR - The BLIS include directories
#  BLIS_LIBRARY - The libraries needed to use BLIS

include(DependencyMacros)

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

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(BLIS DEFAULT_MSG
                                  BLIS_LIBRARY BLIS_INCLUDE_DIR)

set(BLIS_LIBRARIES ${BLIS_LIBRARY})
set(BLIS_INCLUDE_DIRS ${BLIS_INCLUDE_DIR})
set(BLIS_FOUND ${BLIS_FOUND})

list(APPEND BLIS_DEFINITIONS "-DUSE_BLIS")
list(APPEND BLIS_DEFINITIONS "-DBLIS_HEADER=\"blis.h\"")
set(BLIS_HEADER \"blis.h\" CACHE STRING "blis header" FORCE)
