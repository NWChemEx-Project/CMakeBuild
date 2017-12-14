# Find NWX_BLAS
#
# At the moment this is a relatively thin wrapper and lacks real sophistication.
#
# We require that the found BLAS be MKL, in which case the include path will
# point to mkl.h, or it must have a cblas.h header file.  To abstract away
# the name in header file we add a compiler definition CBLAS_HEADER which can be
# used like "#include <CBLAS_HEADER>" in your C++ files.
#
# Setting BLAS_LIBRARIES to the libraries required for linking to your BLAS of
# choice ought to be enough to override what FindBLAS picks (or doesn't pick).
# If you do this you almost certainly will have to also set NWX_BLAS_INCLUDE_DIR
# to the path to your BLAS distribution's header file and NWX_BLAS_DEFINITIONS
# to the correct header file.
#
# This module defines
#  NWX_BLAS_INCLUDE_DIRS, where to find cblas.h or mkl.h
#  NWX_BLAS_LIBRARIES, the libraries to link against for BLAS support
#  NWX_BLAS_DEFINITIONS, flags to include when compiling against BLAS
#  NWX_BLAS_LINK_FLAGS, flags to include when linking against BLAS
#  NWX_BLAS_FOUND, True if we found NWX_BLAS
include(UtilityMacros)
include(FindPackageHandleStandardArgs)

find_package(BLAS QUIET REQUIRED)
is_valid_and_true(BLAS_FOUND FINDNWXBLAS_was_found)
if(FINDNWXBLAS_was_found)
    set(NWX_BLAS_LIBRARIES ${BLAS_LIBRARIES})
    set(NWX_BLAS_LINK_FLAGS ${BLAS_LINK_FLAGS})
endif()

find_path(NWX_BLAS_INCLUDE_DIR mkl.h)
is_valid_and_true(NWX_BLAS_INCLUDE_DIR __found_mkl)
if(NOT __found_mkl)
    find_path(NWX_BLAS_INCLUDE_DIR cblas.h)
endif()

# Avoid overwriting the user's decision
is_valid_and_true(NWX_BLAS_DEFINITIONS __defs_set)
if(NOT __defs_set)
    if(__found_mkl)
        set(NWX_BLAS_DEFINITIONS "-DCBLAS_HEADER=\"mkl.h\"")
    else()
        set(NWX_BLAS_DEFINITIONS "-DCBLAS_HEADER=\"cblas.h\"")
    endif()
endif()
set(NWX_BLAS_INCLUDE_DIRS ${NWX_BLAS_INCLUDE_DIR})
find_package_handle_standard_args(NWX_BLAS DEFAULT_MSG NWX_BLAS_INCLUDE_DIRS
                                                       NWX_BLAS_LIBRARIES)

