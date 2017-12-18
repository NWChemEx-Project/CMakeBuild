include(ExternalProject)
enable_language(C Fortran)

#BLAS wants it's options in Makefile.inc
set(BLAS_MAKEFILE "${CMAKE_BINARY_DIR}/make.inc")
set(BLAS_BUILD_DIR "${CMAKE_BINARY_DIR}/NWChemExBase/NWX_BLAS_External-prefix")
set(BLAS_BUILD_DIR "${BLAS_BUILD_DIR}/src/NWX_BLAS_External/BLAS-3.8.0/")
set(MAKEFILE_DEST "${BLAS_BUILD_DIR}/make.inc")
set(BLAS_LIBRARY "libblas.a")
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
        URL http://www.netlib.org/blas/blas-3.8.0.tgz
        CONFIGURE_COMMAND ${CMAKE_COMMAND} -E copy ${BLAS_MAKEFILE}
                                                   ${MAKEFILE_DEST}
        BUILD_COMMAND cd BLAS-3.8.0 && $(MAKE)
        BUILD_IN_SOURCE TRUE
        INSTALL_COMMAND ${CMAKE_COMMAND} -E copy
                                         ${BLAS_BUILD_DIR}/${BLAS_LIBRARY}
                                         ${BLAS_INSTALL}
)



