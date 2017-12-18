cmake_minimum_required(VERSION ${CMAKE_VERSION})
project(NWX_CBLAS VERSION 0.0.0 LANGUAGES C Fortran)

include(DependencyMacros)
include(ExternalProject)
find_dependency(NWX_BLAS NWX_BLAS_INCLUDE_DIRS
                         NWX_BLAS_LIBRARIES
                         NWX_BLAS_DEFINITIONS
                         NWX_BLAS_LINK_FLAGS
                         _BLAS_FOUND)

#CBLAS want's it's options in Makefile.in
set(CBLAS_MAKEFILE "${CMAKE_BINARY_DIR}/Makefile.in")
set(CBLAS_BUILD_DIR "${CMAKE_BINARY_DIR}/NWX_CBLAS-prefix/src/NWX_CBLAS")
set(MAKEFILE_DEST "${CBLAS_BUILD_DIR}/Makefile.in")

set(CBLAS_LIB "libcblas.a")
file(WRITE  ${CBLAS_MAKEFILE} "SHELL = /bin/sh\n")
file(APPEND ${CBLAS_MAKEFILE} "PLAT = LINUX\n")
file(APPEND ${CBLAS_MAKEFILE} "BLLIB = ${NWX_BLAS_LIBRARIES}\n")
file(APPEND ${CBLAS_MAKEFILE} "CBLIB = ../lib/${CBLAS_LIB}\n")
file(APPEND ${CBLAS_MAKEFILE} "CC = ${CMAKE_C_COMPILER}\n")
file(APPEND ${CBLAS_MAKEFILE} "FC = ${CMAKE_Fortran_COMPILER}\n")
file(APPEND ${CBLAS_MAKEFILE} "LOADER = $(FC)\n")
file(APPEND ${CBLAS_MAKEFILE} "CFLAGS = -O3 -DADD_ -fPIC\n")
file(APPEND ${CBLAS_MAKEFILE} "FFLAGS = -fPIC\n")
file(APPEND ${CBLAS_MAKEFILE} "ARCH = ${CMAKE_AR}\n")
file(APPEND ${CBLAS_MAKEFILE} "ARCHFLAGS = cr\n")
file(APPEND ${CBLAS_MAKEFILE} "RANLIB = echo\n")

set(CBLAS_INSTALL_DIR ${STAGE_DIR}${CMAKE_INSTALL_PREFIX})
ExternalProject_Add(NWX_CBLAS
        URL http://www.netlib.org/blas/blast-forum/cblas.tgz
        CONFIGURE_COMMAND ${CMAKE_COMMAND} -E copy ${CBLAS_MAKEFILE}
                                                   ${MAKEFILE_DEST}
        BUILD_COMMAND $(MAKE) alllib
        BUILD_IN_SOURCE TRUE
        INSTALL_COMMAND ${CMAKE_COMMAND} -E copy
                                        ${CBLAS_BUILD_DIR}/lib/${CBLAS_LIB}
                                        ${CBLAS_INSTALL_DIR}/lib/${CBLAS_LIB}
                        COMMAND ${CMAKE_COMMAND} -E copy
                                ${CBLAS_BUILD_DIR}/include/cblas_f77.h
                                ${CBLAS_INSTALL_DIR}/include/cblas_f77.h
                        COMMAND ${CMAKE_COMMAND} -E copy
                                ${CBLAS_BUILD_DIR}/include/cblas.h
                                ${CBLAS_INSTALL_DIR}/include/cblas.h
        )
