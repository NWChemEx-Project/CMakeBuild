# - Try to find Antlr CppRuntime Library
#
#  To aid find_package in locating the Antlr CppRuntime the user may set the
#  variable ANTLRCPPRUNTIME_ROOT_DIR to the root of the Antlr CppRuntime install
#  directory.
#
#  Once done this will define
#  ANTLRCPPRUNTIME_FOUND - System has Antlr CppRuntime
#  ANTLRCPPRUNTIME_INCLUDE_DIR - The Antlr CppRuntime include directories
#  ANTLRCPPRUNTIME_LIBRARY - The library needed to use Antlr CppRuntime

set(ANTLRCPPRUNTIME_HINTS ${STAGE_DIR}${CMAKE_INSTALL_PREFIX} ${CMAKE_INSTALL_PREFIX})

find_path(ANTLRCPPRUNTIME_INCLUDE_DIR antlr4-runtime/antlr4-runtime.h
          HINTS ${ANTLRCPPRUNTIME_HINTS}
          PATHS ${ANTLRCPPRUNTIME_ROOT_DIR}
          PATH_SUFFIXES include
          NO_DEFAULT_PATH
          )

find_library(ANTLRCPPRUNTIME_LIBRARY
             NAMES libantlr4-runtime.a antlr4-runtime
             HINTS ${ANTLRCPPRUNTIME_HINTS}
             PATHS ${ANTLRCPPRUNTIME_ROOT_DIR}
             PATH_SUFFIXES lib lib64 lib32
             NO_DEFAULT_PATH
             )

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(AntlrCppRuntime DEFAULT_MSG
                                  ANTLRCPPRUNTIME_LIBRARY
                                  ANTLRCPPRUNTIME_INCLUDE_DIR)

set(ANTLRCPPRUNTIME_LIBRARIES ${ANTLRCPPRUNTIME_LIBRARY})
set(ANTLRCPPRUNTIME_INCLUDE_DIRS ${ANTLRCPPRUNTIME_INCLUDE_DIR})
