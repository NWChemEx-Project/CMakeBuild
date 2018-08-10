# - Try to find Microsoft GSL Library
#
#  To aid find_package in locating GSL, the user may set the
#  variable GSL_ROOT_DIR to the root of the GSL install
#  directory.
#
#  Once done this will define
#  GSL_FOUND - System has GSL
#  GSL_INCLUDE_DIR - The GSL include directories

find_path(GSL_INCLUDE_DIR gsl/gsl
          HINTS ${PC_GSL_INCLUDEDIR}
                ${PC_GSL_INCLUDE_DIRS}
          PATHS ${GSL_ROOT_DIR}
          )

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GSL DEFAULT_MSG
                                  GSL_INCLUDE_DIR)

set(GSL_INCLUDE_DIRS ${GSL_INCLUDE_DIR})
