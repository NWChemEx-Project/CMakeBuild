# - Try to find Microsoft GSL Library
#
#  To aid find_package in locating MS GSL, the user may set the
#  variable MSGSL_ROOT to the root of the GSL install
#  directory.
#
#  Once done this will define
#  MSGSL_FOUND - System has MS GSL
#  MSGSL_INCLUDE_DIR - The MS GSL include directories

set(MSGSL_HINTS ${STAGE_DIR}${CMAKE_INSTALL_PREFIX} ${CMAKE_INSTALL_PREFIX})

find_path(MSGSL_INCLUDE_DIR gsl/gsl
            HINTS ${MSGSL_HINTS}
                  ${MSGSL_ROOT}
            PATH_SUFFIXES include
            NO_DEFAULT_PATH
          )

set(MSGSL_INCLUDE_DIRS ${MSGSL_INCLUDE_DIR})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MSGSL DEFAULT_MSG
                                  MSGSL_INCLUDE_DIR)

set(MSGSL_FOUND ${MSGSL_FOUND})
set(MSGSL_INCLUDE_DIRS ${MSGSL_INCLUDE_DIR})
