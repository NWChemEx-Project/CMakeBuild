# Find NWX_CBLAS
#
# At the moment this is a relatively thin wrapper.  Given the variability in
# BLAS distributions *cough* mkl *cough* find module attempts to provide the
# user a unified API to the returned CBLAS implementation by defining a C macro
# CBLAS_HEADER, which can be used in your source files like:
# `#include CBLAS_HEADER`, it's passed to your library via the
# `NWX_CBLAS_DEFINITIONS` cmake variable
#
# This module defines
#  NWX_CBLAS_INCLUDE_DIRS, where to find cblas.h or mkl.h
#  NWX_CBLAS_LIBRARIES, the libraries to link against for BLAS support
#  NWX_CBLAS_DEFINITIONS, flags to include when compiling against BLAS
#  NWX_CBLAS_LINK_FLAGS, flags to include when linking against BLAS
#  NWX_CBLAS_FOUND, True if we found NWX_BLAS
#
# Implementation notes:
#
# Finding a compatible CBLAS library and understanding what we found is not an
# easy task.  Here's my strategy:
#
#   1. Call the traditional FindBLAS.cmake file
#      a. If the user specified their libraries with BLAS_LIBRARIES then this
#         will give it to us
#      b. FindBLAS.cmake can sometimes find MKL, if it does then we can use that
#      c. The next best scenario is it didn't find anything at which point we
#         assume we are looking for a library libcblas.a
#      d. The worst scenario is it found libblas.a
#         - Odds are libblas.a is not a CBLAS implementation, but we'll try it
#           anyways
#  2. Figure out the appropriate header file
#     a. For the time-being the only way we're assuming we got MKL is if it
#        comes back from FindBLAS, then we know it's `mkl.h`
#     b. Given a) that means the correct header file is `cblas.h`
#  3. Verify we got it right by trying to compile a function that calls cblas
#

include(UtilityMacros)
include(FindPackageHandleStandardArgs)
include(CheckCXXSourceCompiles)

set(FINDNWXCBLAS_is_mkl FALSE)
find_package(BLAS QUIET REQUIRED)
is_valid_and_true(BLAS_FOUND FINDNWXCBLAS_was_found)

if(FINDNWXCBLAS_was_found)
    #Great FindBLAS found us something, it's probably junk
    #Best case scenario, it's MKL. Intel likes their branding, which we can use
    #to our advantage by looking if the string "mkl" appears in any of the
    #library names
    string(FIND "${BLAS_LIBRARIES}" "mkl" FINDNWXCBLAS_substring_found)
    is_valid_and_true(FINDNWXCBLAS_substring_found FINDNWXCBLAS_is_mkl)
else()
    find_library(BLAS_LIBRARIES libcblas${CMAKE_STATIC_LIBRARY_SUFFIX})
endif()

#Now let's worry about header files
if(FINDNWXCBLAS_is_mkl)
    #Let's get a good guess for mkl, grab substring up to "/lib"
    string(FIND "${BLAS_LIBRARIES}" "/lib" FINDNWXCBLAS_PATH_END)
    string(SUBSTRING "${BLAS_LIBRARIES}" 0 ${FINDNWXCBLAS_PATH_END}
            FINDNWXCBLAS_MKL_HINT)
    find_path(NWX_CBLAS_INCLUDE_DIR mkl.h
              HINTS ${FINDNWXCBLAS_MKL_HINT}/include
            )
    list(APPEND NWX_CBLAS_DEFINITIONS "-DCBLAS_HEADER=\"mkl.h\"")
else()
    find_path(NWX_CBLAS_INCLUDE_DIR cblas.h)
    list(APPEND NWX_CBLAS_DEFINITIONS "-DCBLAS_HEADER=\"cblas.h\"")
endif()

#Check that we've actually got stuff to try
find_package_handle_standard_args(NWX_CBLAS_files DEFAULT_MSG
                                    NWX_CBLAS_INCLUDE_DIR
                                    BLAS_LIBRARIES)

is_valid_and_true(NWX_CBLAS_files_FOUND FINDNWXCBLAS_have_files)
if(FINDNWXCBLAS_have_files)
    set(CMAKE_REQUIRED_DEFINITIONS ${NWX_CBLAS_DEFINITIONS})
    set(CMAKE_REQUIRED_INCLUDES ${NWX_CBLAS_INCLUDE_DIR})
    set(CMAKE_REQUIRED_LIBRARIES ${BLAS_LIBRARIES})
    check_cxx_source_compiles(
        "#include CBLAS_HEADER
        int main ()
        {
            int N=10;
            float alpha=3.4;
            float X[10]={1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8,9.9,10.10};
            float Y[10]={1.1,2.2,3.3,4.4,5.5,6.6,7.7,8.8,9.9,10.10};
            int incX=1;
            int incY=1;
            float result = cblas_sdsdot(N, alpha, X, incX, Y, incY);
            return 0;
        }"
    IS_ACTUALLY_CBLAS
    )
    if(NOT IS_ACTUALLY_CBLAS)#Guess it's only BLAS after all...
        message(WARNING "BLAS found by traditional FindBLAS, ${BLAS_LIBRARY},
                         does not appear to support a CBLAS API")
        find_path(NWX_CBLAS_LIBRARIES libcblas${CMAKE_STATIC_LIBRARY_SUFFIX})
    else()#Wow it actually is CBLAS...
        set(NWX_CBLAS_LIBRARIES ${BLAS_LIBRARIES})
    endif()
endif()
set(NWX_CBLAS_INCLUDE_DIRS ${NWX_CBLAS_INCLUDE_DIR})
find_package_handle_standard_args(NWX_CBLAS DEFAULT_MSG NWX_CBLAS_INCLUDE_DIRS
                                                        NWX_CBLAS_LIBRARIES)



