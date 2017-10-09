# - Try to find LibInt2
#  Once done this will define
#  LIBINT2_FOUND - System has LibInt2
#  LIBINT2_INCLUDE_DIRS - The LibInt2 include directories
#  LIBINT2_LIBRARIES - The libraries needed to use LibInt2

find_package(PkgConfig)
pkg_check_modules(PC_LIBINT2 libint2)

find_path(LIBINT2_INCLUDE_DIR libint2.hpp
          HINTS ${PC_LIBINT2_INCLUDEDIR} ${PC_LIBINT2_INCLUDE_DIRS} 
          PATH_SUFFIXES libint2)# include libint2/include)

find_library(LIBINT2_LIBRARY NAMES libint2${CMAKE_STATIC_LIBRARY_SUFFIX}
             HINTS ${PC_LIBINT2_LIBDIR} ${PC_LIBINT2_LIBRARY_DIRS})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LIBINT2 DEFAULT_MSG
                                  LIBINT2_LIBRARY LIBINT2_INCLUDE_DIR)

mark_as_advanced(LIBINT2_INCLUDE_DIR LIBINT2_LIBRARY)

set(LIBINT2_LIBRARIES ${LIBINT2_LIBRARY})
set(LIBINT2_INCLUDE_DIRS ${LIBINT2_INCLUDE_DIR})
