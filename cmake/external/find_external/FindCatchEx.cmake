# Find CatchEx
#
# Catch doesn't by default install itself.  This script will find the
# Catch header file (catch/catch.hpp) and the catch library (catch/libcatch.so).
# The Ex just reminds us this isn't the canonical way provide by Catch
#
# This module defines
#  CATCHEX_INCLUDE_DIRS, where to find catch/catch.hpp
#  CATCHEX_LIBARIES, where to find libcatch.so
#  CATHCEX_FOUND, True if we found Catch

find_path(CATCHEX_INCLUDE_DIR catch/catch.hpp)
#find_path(CATCHEX_LIBRARY libcatch.so)

find_package_handle_standard_args(CATCHEX DEFAULT_MSG CATCHEX_INCLUDE_DIR)
#                                                       CATCHEX_LIBRARY)

set(CatchEx_FOUND ${CATCHEX_FOUND})
set(CATCHEX_INCLUDE_DIRS ${CATCHEX_INCLUDE_DIR})
#set(CATCHEX_LIBRARIES ${CATCHEX_LIBRARY})
