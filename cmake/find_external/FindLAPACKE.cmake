# Find LAPACKE
#
# At the moment this is a relatively thin wrapper.  Given the variability in
# BLAS distributions *cough* mkl *cough* find module attempts to provide the
# user a unified API to the returned LAPACKE implementation by defining a C
# macro LAPACKE_HEADER, which can be used in your source files like:
# `#include LAPACKE_HEADER`, it's passed to your library via the
# `LAPACKE_DEFINITIONS` cmake variable
#
# This module defines
#  LAPACKE_INCLUDE_DIR, the path to includes for LAPACKE
#  LAPACKE_INCLUDE_DIRS, path to includes for LAPACKE and all dependencies
#  LAPACKE_LIBRARY, path to the LAPACKE library(s)
#  LAPACKE_LIBRARIES, the LAPACKE library(s) and all dependencies
#  LAPACKE_DEFINITIONS, flags to include when compiling against LAPACKE
#  LAPACKE_LINK_FLAGS, flags to include when linking against LAPACKE
#  LAPACKE_FOUND, True if we found LAPACKE
#
# Users can override paths in this module in several ways:
# 1. Set LAPACKE_INCLUDE_DIRS and/or LAPACKE_LIBRARIES
#    - This will not look for includes/libraries for LAPACKE or its dependencies
# 2. Set LAPACKE_INCLUDE_DIR and/or LAPACKE_LIBRARY
#    - This will not look for includes/libraries for LAPACKE, but will look for
#      includes/libraries for the dependencies
# 3. Set X_INCLUDE_DIR and/or X_LIBRARY (X=BLAS and/or LAPACK)
#    - This will look for includes/libraries for LAPACKE, but not its
#      dependencies

include(FindPackageHandleStandardArgs)
set(FINDLAPACKE_is_mkl FALSE)

is_valid(LAPACKE_LIBRARIES FINDLAPACKE_LIBS_SET)
if(NOT FINDLAPACKE_LIBS_SET)
    find_library(LAPACKE_LIBRARY NAMES lapacke)
    find_package_handle_standard_args(LAPACKE DEFAULT_MSG LAPACKE_LIBRARY)
    #Now we have to find a LAPACK library
    find_package(LAPACK)

    #This is where'd we check that it's compatible, but as you can see we don't

    #and a BLAS implementation
    find_package(BLAS)

    #This is where'd we check that it's compatible, but as you can see we don't

    set(LAPACKE_LIBRARIES ${LAPACKE_LIBRARY} ${LAPACK_LIBRARIES}
                          ${BLAS_LIBRARIES})
endif()

set(FINDLAPACKE_HEADER lapacke.h)
    #Let's see if it's MKL. Intel likes their branding, which we can use
    #to our advantage by looking if the string "mkl" appears in any of the
    #library names
string(FIND "${LAPACKE_LIBRARIES}" "mkl" FINDLAPACKE_substring_found)
if(NOT "${FINDLAPACKE_substring_found}" STREQUAL "-1")
    set(FINDLAPACKE_HEADER mkl.h)
    list(GET LAPACKE_LIBRARIES 0 _some_mkl_lib)
    get_filename_component(_mkl_lib_path ${_some_mkl_lib} DIRECTORY)
    find_library(LAPACKE_LIBRARY NAMES mkl_core PATHS ${_mkl_lib_path})
    find_path(LAPACKE_INCLUDE_DIR NAMES ${FINDLAPACKE_HEADER} PATHS ${LAPACKE_INCLUDE_DIRS})
    find_package_handle_standard_args(LAPACKE DEFAULT_MSG LAPACKE_LIBRARY LAPACKE_INCLUDE_DIR)

    list(APPEND LAPACKE_DEFINITIONS "-DTAMM_LAPACK_INT=MKL_INT")
else()
    list(APPEND LAPACKE_DEFINITIONS "-DTAMM_LAPACK_INT=lapack_int")
endif()

is_valid(LAPACKE_INCLUDE_DIRS FINDLAPACKE_INCS_SET)
if(NOT FINDLAPACKE_INCS_SET)
    find_path(LAPACKE_INCLUDE_DIR ${FINDLAPACKE_HEADER})
    find_package_handle_standard_args(LAPACKE DEFAULT_MSG LAPACKE_INCLUDE_DIR)

    set(LAPACKE_INCLUDE_DIRS ${LAPACKE_INCLUDE_DIR})
endif()
list(APPEND LAPACKE_DEFINITIONS "-DLAPACKE_HEADER=\"${FINDLAPACKE_HEADER}\"")

find_package_handle_standard_args(LAPACKE DEFAULT_MSG LAPACKE_INCLUDE_DIR
                                                      LAPACKE_LIBRARY)
