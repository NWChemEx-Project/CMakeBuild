# Find LAPACKE
#
# At the moment this is a relatively thin wrapper and lacks real sophistication.
#
# We require that the found LAPACK be MKL, in which case the include path will
# point to mkl.h, or it must have a lapacke.h header file.  To abstract away
# the name in header file we add a compiler definition LAPACKE_HEADER which
# can be used like "#include <LAPACKE_HEADER>" in your C++ files.
#
# Setting LAPACK_LIBRARIES to the libraries required for linking to your LAPACK
# of choice ought to be enough to override what FindLAPACK picks (or doesn't
# pick). If you do this you almost certainly will have to also set
# LAPACK_INCLUDE_DIR to the path to your LAPACK distribution's header file
# and LAPACK_DEFINITIONS to the correct header file.
#
# This module defines
#  LAPACK_INCLUDE_DIRS, where to find lapacke.h or mkl.h
#  LAPACK_LIBRARIES, the libraries to link against for LAPACK support
#  LAPACK_DEFINITIONS, flags to include when compiling against LAPACK
#  LAPACK_LINK_FLAGS, flags to include when linking against LAPACK
#  LAPACK_FOUND, True if we found LAPACK
include(UtilityMacros)
include(FindPackageHandleStandardArgs)

find_package(LAPACK QUIET REQUIRED)
is_valid_and_true(LAPACK_FOUND FINDNWXLAPACK_was_found)
if(FINDNWXLAPACK_was_found)
    set(LAPACKE_LIBRARIES ${LAPACK_LIBRARIES})
    set(LAPACKE_LINK_FLAGS ${LAPACK_LINK_FLAGS})
endif()

find_path(LAPACKE_INCLUDE_DIR mkl.h)
is_valid_and_true(LAPACKE_INCLUDE_DIR __found_mkl)
if(NOT __found_mkl)
    find_path(LAPACKE_INCLUDE_DIR lapacke.h)
endif()

# Avoid overwriting the user's decision
is_valid_and_true(LAPACKE_DEFINITIONS __defs_set)
if(NOT __defs_set)
    if(__found_mkl)
        set(LAPACKE_DEFINITIONS "-DLAPACKE_HEADER=\"mkl.h\"")
    else()
        set(LAPACKE_DEFINITIONS "-DLAPACKE_HEADER=\"lapacke.h\"")
    endif()
endif()
set(LAPACKE_INCLUDE_DIRS ${LAPACKE_INCLUDE_DIR})
find_package_handle_standard_args(LAPACKE DEFAULT_MSG
        LAPACKE_INCLUDE_DIRS
        LAPACKE_LIBRARIES)
