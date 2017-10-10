# - Try to find LibInt
#  Once done this will define
#  LIBINT_FOUND - System has Libint
#  LIBINT_INCLUDE_DIRS - The Libint include directories
#  LIBINT_LIBRARIES - The libraries needed to use Libint

find_package(PkgConfig)
pkg_check_modules(PC_LIBINT libint2)

find_path(LIBINT_INCLUDE_DIR libint2.hpp
          HINTS ${PC_LIBINT_INCLUDEDIR} ${PC_LIBINT_INCLUDE_DIRS} 
          PATH_SUFFIXES libint2)# include libint/include)

find_library(LIBINT_LIBRARY NAMES libint2${CMAKE_STATIC_LIBRARY_SUFFIX}
             HINTS ${PC_LIBINT_LIBDIR} ${PC_LIBINT_LIBRARY_DIRS})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LIBINT DEFAULT_MSG
                                  LIBINT_LIBRARY LIBINT_INCLUDE_DIR)

mark_as_advanced(LIBINT_INCLUDE_DIR LIBINT_LIBRARY)

set(LIBINT_LIBRARIES ${LIBINT_LIBRARY})
set(LIBINT_INCLUDE_DIRS ${LIBINT_INCLUDE_DIR})
