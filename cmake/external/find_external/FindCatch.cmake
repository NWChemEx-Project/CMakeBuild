# Find NWX_Catch
#
# Catch doesn't by default install itself.  This script will find the
# Catch header file (catch/catch.hpp) and the catch library (catch/libcatch.so).
# The NWX just reminds us this isn't the canonical way provided by Catch
#
# This module defines
#  NWX_Catch_INCLUDE_DIRS, where to find catch/catch.hpp
#  NWX_Catch_LIBARIES, where to find libcatch.so
#  CATHCEX_FOUND, True if we found Catch

find_path(NWX_Catch_INCLUDE_DIR catch/catch.hpp)
#find_path(NWX_Catch_LIBRARY libcatch.so)

find_package_handle_standard_args(NWX_Catch DEFAULT_MSG NWX_Catch_INCLUDE_DIR)
#                                                       NWX_Catch_LIBRARY)

set(NWX_Catch_FOUND ${NWX_Catch_FOUND})
set(NWX_Catch_INCLUDE_DIRS ${NWX_Catch_INCLUDE_DIR})
#set(NWX_Catch_LIBRARIES ${NWX_Catch_LIBRARY})
