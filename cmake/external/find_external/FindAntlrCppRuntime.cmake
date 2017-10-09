# - Try to find Antlr CppRuntime Library
#  Once done this will define
#  ANTLR_CPP_RUNTIME_FOUND - System has Antlr CppRuntime
#  ANTLR_CPP_RUNTIME_INCLUDE_DIRS - The Antlr CppRuntime include directories
#  ANTLR_CPP_RUNTIME_LIBRARIES - The libraries needed to use Antlr CppRuntime

find_package(PkgConfig)
pkg_check_modules(PC_ANTLR_CPP_RUNTIME QUIET libantlr4-runtime)

find_path(ANTLR_CPP_RUNTIME_INCLUDE_DIR antlr4-runtime.h
          HINTS ${PC_ANTLR_CPP_RUNTIME_INCLUDEDIR} ${PC_ANTLR_CPP_RUNTIME_INCLUDE_DIRS} 
          PATH_SUFFIXES antlr4-runtime)

find_library(ANTLR_CPP_RUNTIME_LIBRARY NAMES libantlr4-runtime${CMAKE_STATIC_LIBRARY_SUFFIX}
             HINTS ${PC_ANTLR_CPP_RUNTIME_LIBDIR} ${PC_ANTLR_CPP_RUNTIME_LIBRARY_DIRS})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ANTLR_CPP_RUNTIME DEFAULT_MSG
                                  ANTLR_CPP_RUNTIME_LIBRARY ANTLR_CPP_RUNTIME_INCLUDE_DIR)

mark_as_advanced(ANTLR_CPP_RUNTIME_INCLUDE_DIR ANTLR_CPP_RUNTIME_LIBRARY)

set(ANTLR_CPP_RUNTIME_LIBRARIES ${ANTLR_CPP_RUNTIME_LIBRARY})
set(ANTLR_CPP_RUNTIME_INCLUDE_DIRS ${ANTLR_CPP_RUNTIME_INCLUDE_DIR})
