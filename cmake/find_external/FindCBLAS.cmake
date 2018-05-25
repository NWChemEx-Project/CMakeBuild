# Find CBLAS
#
# At the moment this is a relatively thin wrapper.  Given the variability in
# BLAS distributions *cough* mkl *cough* find module attempts to provide the
# user a unified API to the returned CBLAS implementation by defining a C macro
# CBLAS_HEADER, which can be used in your source files like:
# `#include CBLAS_HEADER`, it's passed to your library via the
# `CBLAS_DEFINITIONS` cmake variable
#
# This module defines
#  CBLAS_INCLUDE_DIR, only the includes for CBLAS
#  CBLAS_INCLUDE_DIRS, all includes for CBLAS and its dependencies
#  CBLAS_LIBRARY,   only the CBLAS library
#  CBLAS_LIBRARIES, CBLAS library and those of its dependencies
#  CBLAS_DEFINITIONS, flags to include when compiling against CBLAS
#  CBLAS_LINK_FLAGS, flags to include when linking against CBLAS
#  CBLAS_FOUND, True if we found CBLAS
#
# Users can override paths in this module in several ways:
# 1. Set CBLAS_INCLUDE_DIRS and/or CBLAS_LIBRARIES
#    - This will not look for includes/libraries for CBLAS or its dependencies
# 2. Set CBLAS_INCLUDE_DIR and/or CBLAS_LIBRARY
#    - This will not look for includes/libraries for CBLAS, but will look for
#      includes/libraries for the dependencies
# 3. Set BLAS_INCLUDE_DIR and/or BLAS_LIBRARY
#    - This will look for includes/libraries for CBLAS, but not its dependencies

include(FindPackageHandleStandardArgs)
set(FINDCBLAS_is_mkl FALSE)
set(FINDCBLAS_HEADER cblas.h)
is_valid(CBLAS_LIBRARIES FINDCBLAS_LIBS_SET)
if(NOT FINDCBLAS_LIBS_SET)
    find_library(CBLAS_LIBRARY NAMES cblas)
    find_package_handle_standard_args(CBLAS DEFAULT_MSG CBLAS_LIBRARY)
    #Now we have to find a BLAS library compatible with our CBLAS implementation
    find_package(BLAS)
    #This is where'd we check that it's compatible, but as you can see we don't
    set(CBLAS_LIBRARIES ${CBLAS_LIBRARY} ${BLAS_LIBRARIES})
endif()

#Let's see if it's MKL. Intel likes their branding, which we can use to our
#advantage by looking if the string "mkl" appears in any of the library names
string(FIND "${CBLAS_LIBRARIES}" "mkl" FINDCBLAS_substring_found)
if(NOT "${FINDCBLAS_substring_found}" STREQUAL "-1")
    set(FINDCBLAS_HEADER mkl.h)
endif()

is_valid(CBLAS_INCLUDE_DIRS FINDCBLAS_INCS_SET)
if(NOT FINDCBLAS_INCS_SET)
    find_path(CBLAS_INCLUDE_DIR ${FINDCBLAS_HEADER})
    find_package_handle_standard_args(CBLAS DEFAULT_MSG CBLAS_INCLUDE_DIR)
    set(CBLAS_INCLUDE_DIRS ${CBLAS_INCLUDE_DIR})
endif()
list(APPEND CBLAS_DEFINITIONS "-DCBLAS_HEADER=\"${FINDCBLAS_HEADER}\"")


find_package_handle_standard_args(CBLAS DEFAULT_MSG CBLAS_INCLUDE_DIRS
                                                    CBLAS_LIBRARIES)
