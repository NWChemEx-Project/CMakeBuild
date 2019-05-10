# - Try to find Microsoft GSL Library
#
#  To aid find_package in locating MS GSL, the user may set the
#  variable CXXBLACS_ROOT_DIR to the root of the GSL install
#  directory.
#
#  Once done this will define
#  CXXBLACS_FOUND - System has MS GSL
#  CXXBLACS_INCLUDE_DIR - The MS GSL include directories

if(NOT DEFINED CXXBLACS_ROOT_DIR)
    find_package(PkgConfig)
    pkg_check_modules(PC_CXXBLACS QUIET CXXBLACS)
endif()

find_path(CXXBLACS_INCLUDE_DIR cxxblacs.hpp cxxblacs/blacs.hpp
          HINTS ${PC_CXXBLACS_INCLUDEDIR}
                ${PC_CXXBLACS_INCLUDE_DIRS}
          PATHS ${CXXBLACS_ROOT_DIR}
          )

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MSGSL DEFAULT_MSG
                                  CXXBLACS_INCLUDE_DIR)

set(CXXBLACS_FOUND ${CXXBLACS_FOUND})
set(CXXBLACS_INCLUDE_DIRS ${CXXBLACS_INCLUDE_DIR})
