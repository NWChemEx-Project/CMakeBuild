# - Try to find Eigen
#  Once done this will define
#  EIGEN3_FOUND - System has Eigen
#  EIGEN3_INCLUDE_DIR - The Eigen include directories

if(NOT DEFINED EIGEN3_ROOT_DIR)
      find_package(PkgConfig)
      pkg_check_modules(PC_EIGEN3 QUIET eigen3)
endif()

find_path(EIGEN3_INCLUDE_DIR Eigen/src/Core/util/Macros.h
          HINTS ${PC_EIGEN3_INCLUDEDIR} ${PC_EIGEN3_INCLUDE_DIRS} 
          PATHS ${EIGEN3_ROOT_DIR}
          PATH_SUFFIXES eigen3)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Eigen3 DEFAULT_MSG
                                  EIGEN3_INCLUDE_DIR)
