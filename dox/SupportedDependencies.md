Supported Dependencies
======================

CMakeBuild relies on CMake's `find_package` module for locating dependencies
and setting paths up correctly.  CMakeBuild takes it a step further by 
attempting to build a dependency for the user if it can't find that 
dependency. 

CMakeBuild can find and build the following:

--------------------------------------------------------------------------------
| Name            | Brief Description                                          |  
| :-------------: | :--------------------------------------------------------- |  
| BLAS            | Basic Linear Algebra Subprograms (builds BLIS as default)  |
| LAPACK          | Linear Algebra PACKage (can build Netlib version)          |
| ScaLAPCK        | Scalable LAPACK (can build Netlib version)                 |
| Eigen3          | The Eigen C++ matrix library                               |
| LibInt          | Computes Gaussian integrals for quantum mechanics          |
| HDF5            | The HDF5 Library                                           |
| HPTT            | High-Performance Tensor Transpose library                  |
| MSGSL           | Guidelines Support Library (GSL)                           |
| TAL-SH          | Tensor Algebra Library for Shared Memory Computers         |
| GlobalArrays    | The Global Arrays distributed matrix library               |
--------------------------------------------------------------------------------

 
    
