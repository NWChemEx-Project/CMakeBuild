#
# Attempts to find a LAPACK distribution.
#
# After this module runs the following variables are set:
#   LAPACK_LIBRARIES : The literal LAPACK library(s) to link against
#   LAPACK_FOUND     : True if we found a LAPACK library
#
include(FindPackageHandleStandardArgs)
find_library(LAPACK_LIBRARIES liblapack${CMAKE_STATIC_LIBRARY_SUFFIX})
find_package_handle_standard_args(LAPACK DEFAULT_MSG LAPACK_LIBRARIES)
