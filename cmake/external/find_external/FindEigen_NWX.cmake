# - Try to find Eigen3
#  Once done this will define
#  EIGEN_FOUND - System has Eigen3
#  EIGEN_INCLUDE_DIRS - The Eigen3 include directories

find_package(PkgConfig)
pkg_check_modules(PC_EIGEN eigen3)

find_path(EIGEN_INCLUDE_DIR Eigen/src/Core/util/Macros.h
          HINTS ${PC_EIGEN_INCLUDEDIR} ${PC_EIGEN_INCLUDE_DIRS} 
          PATH_SUFFIXES eigen3)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(EIGEN DEFAULT_MSG
                                  EIGEN_INCLUDE_DIR)

mark_as_advanced(EIGEN_INCLUDE_DIR)

set(EIGEN_INCLUDE_DIRS ${EIGEN_INCLUDE_DIR})
