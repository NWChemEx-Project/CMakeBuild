include(ExternalProject)
enable_language(C Fortran)


set(BLAS_VERSION 3.8.0)
set(BLAS_MAKEFILE ${CMAKE_BINARY_DIR}/make.inc)
set(BLAS_ROOT_DIR ${CMAKE_BINARY_DIR}/NWChemExBase/NWX_BLAS_External)
set(BLAS_SRC_DIR  ${BLAS_ROOT_DIR}/BLAS-${BLAS_VERSION})
set(MAKEFILE_DEST ${BLAS_SRC_DIR}/make.inc)
set(BLAS_LIBRARY "libblas${CMAKE_STATIC_LIBRARY_SUFFIX}")

#BLAS wants it's options in Makefile.inc
file(WRITE ${BLAS_MAKEFILE} "SHELL = /bin/sh\n")
file(APPEND ${BLAS_MAKEFILE} "PLAT = _LINUX\n" )
file(APPEND ${BLAS_MAKEFILE} "FORTRAN  = ${CMAKE_Fortran_COMPILER}\n")
file(APPEND ${BLAS_MAKEFILE} "OPTS     = -O3 -fPIC\n")
file(APPEND ${BLAS_MAKEFILE} "DRVOPTS  = $(OPTS)\n")
file(APPEND ${BLAS_MAKEFILE} "NOOPT    = \n")
file(APPEND ${BLAS_MAKEFILE} "LOADER   = ${CMAKE_Fortran_COMPILER}\n")
file(APPEND ${BLAS_MAKEFILE} "LOADOPTS = \n")
file(APPEND ${BLAS_MAKEFILE} "ARCH     = ${CMAKE_AR}\n")
file(APPEND ${BLAS_MAKEFILE} "ARCHFLAGS= cr\n")
file(APPEND ${BLAS_MAKEFILE} "RANLIB   = echo\n")
file(APPEND ${BLAS_MAKEFILE} "BLASLIB      = ${BLAS_LIBRARY}\n")

set(BLAS_INSTALL ${STAGE_DIR}${CMAKE_INSTALL_PREFIX}/lib/${BLAS_LIBRARY})
ExternalProject_Add(NWX_BLAS_External
        PREFIX NWX_BLAS_External
        DOWNLOAD_DIR ${BLAS_ROOT_DIR}
        URL http://www.netlib.org/blas/blas-3.8.0.tgz
        URL_HASH MD5=3E6E783ECEFC3B0B461722A939A16D9B
        SOURCE_DIR ${BLAS_SRC_DIR}
        CONFIGURE_COMMAND ${CMAKE_COMMAND} -E copy ${BLAS_MAKEFILE}
                                                   ${MAKEFILE_DEST}
        BUILD_IN_SOURCE TRUE
        INSTALL_COMMAND ${CMAKE_COMMAND} -E copy
                                         ${BLAS_SRC_DIR}/${BLAS_LIBRARY}
                                         ${BLAS_INSTALL}
)



