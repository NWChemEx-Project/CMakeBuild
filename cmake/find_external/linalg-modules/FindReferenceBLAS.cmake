include(UtilityMacros)

set( referenceblas_LIBRARY_NAME libblis.a blis )

set( referenceblas_SPREFIX "${STAGE_INSTALL_DIR}" )
set( referenceblas_IPREFIX "${CMAKE_INSTALL_PREFIX}" )

find_path( referenceblas_INCLUDE_DIR
  NAMES blis/blis.h
  HINTS ${referenceblas_SPREFIX} ${referenceblas_IPREFIX}
  PATHS ${referenceblas_INCLUDE_DIR}
  PATH_SUFFIXES include
  DOC "Reference BLAS header"
)

find_library( referenceblas_LIBRARY
  NAMES ${referenceblas_LIBRARY_NAME}
  HINTS ${referenceblas_SPREFIX} ${referenceblas_IPREFIX}
  PATHS ${referenceblas_LIBRARY_DIR} ${CMAKE_C_IMPLICIT_LINK_DIRECTORIES} 
  PATH_SUFFIXES lib lib64 lib32
  DOC "Reference BLAS Library"
)

# Reference BLAS is always LP64
set( ReferenceBLAS_ilp64_FOUND FALSE )
set( ReferenceBLAS_lp64_FOUND  TRUE  )

if( referenceblas_INCLUDE_DIR )
  set( ReferenceBLAS_INCLUDE_DIR ${referenceblas_INCLUDE_DIR} )
endif()

if( referenceblas_LIBRARY )
  find_package( Threads QUIET )
  set( ReferenceBLAS_LIBRARIES ${referenceblas_LIBRARY} Threads::Threads "m")
endif()

list(APPEND ReferenceBLAS_COMPILE_DEFINITIONS "TAMM_LAPACK_INT=int32_t")
list(APPEND ReferenceBLAS_COMPILE_DEFINITIONS "TAMM_LAPACK_COMPLEX8=std::complex<float>")
list(APPEND ReferenceBLAS_COMPILE_DEFINITIONS "TAMM_LAPACK_COMPLEX16=std::complex<double>")
list(APPEND ReferenceBLAS_COMPILE_DEFINITIONS "TAMM_BLA_REFERENCE")
list(APPEND ReferenceBLAS_COMPILE_DEFINITIONS "USE_BLIS")

include(FindPackageHandleStandardArgs)
is_valid(ReferenceBLAS_C_COMPILE_FLAGS __has_cflags)
if(__has_cflags)
  find_package_handle_standard_args( ReferenceBLAS
    REQUIRED_VARS ReferenceBLAS_LIBRARIES ReferenceBLAS_INCLUDE_DIR 
      ReferenceBLAS_COMPILE_DEFINITIONS ReferenceBLAS_C_COMPILE_FLAGS 
    VERSION_VAR ReferenceBLAS_VERSION_STRING
    HANDLE_COMPONENTS
  )
else()
  find_package_handle_standard_args( ReferenceBLAS
    REQUIRED_VARS ReferenceBLAS_LIBRARIES ReferenceBLAS_INCLUDE_DIR 
      ReferenceBLAS_COMPILE_DEFINITIONS  
    VERSION_VAR ReferenceBLAS_VERSION_STRING
    HANDLE_COMPONENTS
  )
endif()

if( ReferenceBLAS_FOUND AND NOT TARGET ReferenceBLAS::blas )

  add_library( ReferenceBLAS::blas INTERFACE IMPORTED )
  set_target_properties( ReferenceBLAS::blas PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${ReferenceBLAS_INCLUDE_DIR}"
    INTERFACE_LINK_LIBRARIES      "${ReferenceBLAS_LIBRARIES}"
    INTERFACE_COMPILE_OPTIONS     "${ReferenceBLAS_C_COMPILE_FLAGS}"
    INTERFACE_COMPILE_DEFINITIONS "${ReferenceBLAS_COMPILE_DEFINITIONS}"    
  )

endif()

