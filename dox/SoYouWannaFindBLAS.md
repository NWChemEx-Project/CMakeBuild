So You Wanna Find BLAS/LAPACK
=============================

BLAS/LAPACK are hallmarks of high-performance computing.  At first glance CMake
appears to make it easy to find BLAS/LAPACK, just call `find_package(BLAS)` or
`find_package(LAPACK)` and the `FindBLAS.cmake` and `FindLAPACK.cmake` module
files supplied with CMake will give you BLAS/LAPACK.  If was this easy we
wouldn't need an entire page dedicated to the complexities of finding 
BLAS/LAPACK...

Contents
--------

1. [TL;DR User Version](#tl;dr-user-version)
2. [Understanding the Problem](#understanding-the-problem)
3. [What the BLAS/LAPACK Detection Should Do](#what-the-findblas/findlapack-and-findcblas/findlapacke-modules-should-do)
4. [What the BLAS/LAPACK Detection Actually Does](#current-status-of-findblas/findlapack-and-findcblas/findlapacke)

TL;DR User Version
------------------

If you care what version of BLAS/LAPACK and CBLAS/LAPACKE are utilized set the
following variables:

| Variable             | Value                                              |
| :------------------: | :--------------------------------------------------|
| BLAS_LIBRARIES       | path/to/blas/library.a  (path includes library)    |
| CBLAS_LIBRARIES      | path/to/cblas/lbirary.a (path includes library)    |
| CBLAS_INCLUDE_DIRS   | path/to/cblas/include/dir (path excludes header)   |
| LAPACK_LIBRARIES     | path/to/lapack/library.a (path includes library)   |
| LAPACKE_LIBRARIES    | path/to/lapacke/library.a (path includes library)  |
| LAPACKE_INCLUDE_DIRS | path/to/lapacke/include/dir (path excludes header) |

If you only set BLAS/LAPACK libraries we will build the wrapper CBLAS/LAPACKE
libraries around your specified BLAS/LAPACK library.  If you are using MKL it 
suffices to set `MKL_LIBRARIES` and `MKL_INCLUDE_DIRS` and we will set all of 
the above for you.  If you set no variables, we'll build them all for you.

Understanding the Problem
-------------------------

First things first, BLAS/LAPACK are standard APIs, not libraries.  Various 
research groups/vendors have implemented these standards into libraries 
(which they often simply call BLAS/LAPACK adding to the confusion).  
Unfortunately, either there is no standard file structure to a BLAS/LAPACK 
installation or the various groups/vendors all decided to ignore it.  What this
means is locating a given group's/vendor's implementation tends to be a 
procedure that is specific to one particular implementation.  Adding to the fun, 
the standards were designed in an era where people liked Fortran and the ABIs 
all have Fortran linkage.  What this means is once you've figured out what 
libraries you need to link against, it's easy to call any BLAS/LAPACK 
implementation from Fortran and a royal pain to call it from any other language.

Calling BLAS/LAPACK from languages derived from C is typically facilitated by
going through CBLAS/LAPACKE.  CBLAS/LAPACKE are thin wrapper libraries over a 
standard BLAS/LAPACK implementation designed to give it C-like linkage.  
Unfortunately, their adoption is not as widespread as one would like with most
codes still relying on BLAS/LAPACK directly.  Given that NWChemExBase's target
software stack is written primarily in C/C++ we will insist on using 
CBLAS/LAPACKE.  Finally, note that for most CBLAS/LAPACKE implementations one 
still needs to link against the underlying BLAS/LAPACK implementation so we 
don't avoid the problem of finding them.

What the FindBLAS/FindLAPACK and FindCBLAS/FindLAPACKE Modules Should Do
------------------------------------------------------------------------

At the heart of this problem we need to find two sets of headers (one for 
CBLAS and one for LAPACKE) and four libraries.  Additionally, the BLAS library
must be compatible (same ABI) with the CBLAS library and the LAPACK library. The
LAPACK library must be compatible with the LAPACKE library.  That's for 
"standard" distributions.  Then there's non-standard distributions.  For MKL, 
it's a lot more complicated with the actual set of libraries being given by 
Intel's link line advisor 
([link](https://software.intel.com/en-us/articles/intel-mkl-link-line-advisor)).
There's also the Accelerate framework on Macs that needs to be handled and 
there's (probably) other vendor specific implementations to worry about (Cray?).

The above assumes we have to find all the necessary libraries/includes.  In 
truth, there are 16 possibilities for user inputs (assuming if a user provides 
us CBLAS/LAPACKE we get the library and the header file).  These inputs range
from we're given nothing, to we're given a single library, to we're given 
everything.  Doing this in a robust manner is difficult.

Making matters more fun, just because we found the libraries/headers doesn't
mean our dependencies can.  Hence it will fall upon NWChemExBase to manually set
the paths for all dependencies wanting BLAS/LAPACK support.  This becomes 
increasingly difficult for the non-standard distributions like MKL as many 
dependencies may not recognize that it is actually BLAS/LAPACK and 
CBLAS/LAPACKE.

Current Status of FindBLAS/FindLAPACK and FindCBLAS/FindLAPACKE
---------------------------------------------------------------

Given the statement of what the various find modules should do, let's discuss
what the ones included in NWChemExBase actually do.  Generally speaking there's
really only two find modules: the ones for BLAS/LAPACK and the ones for
CBLAS/LAPACKE.  This is because the FindBLAS and FindLAPACK modules are almost
identical (aside from replacing BLAS with LAPACK) and similarly the FindCBLAS
and FindLAPACKE modules are basically the same.  Hence for simplicity we will
only talk about the BLAS/CBLAS modules, but you can assume the same applies to
the LAPACK/LAPACKE modules as well.
