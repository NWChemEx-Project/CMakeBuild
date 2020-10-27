# - Try to find Global Arrays
#
#  The user may specify GLOBALARRAYS_ROOT to aid find_packge in
#  finding an already installed Global Arrays
#
#  Once done this will define
#  GLOBALARRAYS_FOUND - System has Global Arrays
#  GLOBALARRAYS_CONFIG - The ga-config binary path
#  GLOBALARRAYS_INCLUDE_DIR - The Global Arrays include directories
#  GLOBALARRAYS_LIBRARIES - The libraries needed to use Global Arrays

set(GLOBALARRAYS_HINTS ${STAGE_DIR}${CMAKE_INSTALL_PREFIX} ${CMAKE_INSTALL_PREFIX})

find_path(GLOBALARRAYS_INCLUDE_DIR ga.h
          HINTS ${GLOBALARRAYS_HINTS}
          PATHS ${GLOBALARRAYS_ROOT}
          PATH_SUFFIXES include include/ga
          NO_DEFAULT_PATH
         )

find_path(GLOBALARRAYS_CONFIG ga-config
         HINTS ${GLOBALARRAYS_HINTS}
         PATHS ${GLOBALARRAYS_ROOT} 
         PATH_SUFFIXES bin
         NO_DEFAULT_PATH
        )         

find_library(GLOBALARRAYS_C_LIBRARY NAMES ga
             HINTS ${GLOBALARRAYS_HINTS}
             PATHS ${GLOBALARRAYS_ROOT}
             PATH_SUFFIXES lib lib32 lib64
             NO_DEFAULT_PATH
        )

find_library(GLOBALARRAYS_ARMCI_LIBRARY NAMES armci
             HINTS ${GLOBALARRAYS_HINTS}
             PATHS ${GLOBALARRAYS_ROOT}
             PATH_SUFFIXES lib lib32 lib64
             NO_DEFAULT_PATH
        )

# find_library(GLOBALARRAYS_COMEX_LIBRARY NAMES comex
#              HINTS ${GLOBALARRAYS_HINTS}
#              PATHS ${GLOBALARRAYS_ROOT}
#              PATH_SUFFIXES lib lib32 lib64
#              NO_DEFAULT_PATH
#            )

find_package_handle_standard_args(GlobalArrays DEFULT_MSG GLOBALARRAYS_C_LIBRARY
        GLOBALARRAYS_ARMCI_LIBRARY)

set(GLOBALARRAYS_LIBRARIES ${GLOBALARRAYS_C_LIBRARY}
                           ${GLOBALARRAYS_ARMCI_LIBRARY} 
                           )

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GlobalArrays DEFAULT_MSG
                                  GLOBALARRAYS_LIBRARIES
                                  GLOBALARRAYS_INCLUDE_DIR
                                  GLOBALARRAYS_CONFIG
                                 )

set(GLOBALARRAYS_INCLUDE_DIRS ${GLOBALARRAYS_INCLUDE_DIR})
set(GLOBALARRAYS_FOUND ${GlobalArrays_FOUND})

if (GLOBALARRAYS_FOUND)
  #GA, MPI, Blas, Lapack, std fortran libs are already figured out by CMakeBuild
  #Get optional libs using ga-config: pthreads, librt, libm (paths verified by GA)
  execute_process(COMMAND ${GLOBALARRAYS_CONFIG}/ga-config --libs OUTPUT_VARIABLE GA_CONFIG_LIBS OUTPUT_STRIP_TRAILING_WHITESPACE)
  execute_process(COMMAND ${GLOBALARRAYS_CONFIG}/ga-config --flibs OUTPUT_VARIABLE GA_CONFIG_F_LIBS OUTPUT_STRIP_TRAILING_WHITESPACE)
  #execute_process(COMMAND ${GLOBALARRAYS_CONFIG}/ga-config --ldflags OUTPUT_VARIABLE GA_CONFIG_LDFLAGS OUTPUT_STRIP_TRAILING_WHITESPACE)

  set(GA_ALL_CONFIG_LIBS "${GA_CONFIG_LIBS} ${GA_CONFIG_F_LIBS}")
  string(REPLACE " " ";" GA_LIBS_LIST ${GA_ALL_CONFIG_LIBS})
  foreach(__lib ${GA_LIBS_LIST})
    if(NOT __lmath) 
     string(COMPARE EQUAL "-lm" ${__lib} __lmath) 
    endif()
    if(NOT __lpthread) 
      string(COMPARE EQUAL "-lpthread" ${__lib} __lpthread) 
    endif()
    if(NOT __lrt) 
      string(COMPARE EQUAL "-lrt" ${__lib} __lrt) 
    endif()
    if(NOT __lgfortran) 
      string(COMPARE EQUAL "-lgfortran" ${__lib} __lgfortran) 
    endif()    
    if(NOT __lquadmath) 
      string(COMPARE EQUAL "-lquadmath" ${__lib} __lquadmath) 
    endif()        
    if(NOT __lifcoremt_pic) 
      string(COMPARE EQUAL "-lifcoremt_pic" ${__lib} __lifcoremt_pic) 
    endif()  
    if(NOT __libverbs) 
      string(COMPARE EQUAL "-libverbs" ${__lib} __libverbs) 
    endif()    
    if(NOT __lifport) 
      string(COMPARE EQUAL "-lifport" ${__lib} __lifport) 
    endif()
    if(NOT __lifcoremt) 
      string(COMPARE EQUAL "-lifcoremt" ${__lib} __lifcoremt) 
    endif()
    if(NOT __limf) 
      string(COMPARE EQUAL "-limf" ${__lib} __limf) 
    endif()
    if(NOT __lsvml) 
      string(COMPARE EQUAL "-lsvml" ${__lib} __lsvml) 
    endif()
    if(NOT __lipgo) 
      string(COMPARE EQUAL "-lipgo" ${__lib} __lipgo) 
    endif()       
    if(NOT __lirc) 
      string(COMPARE EQUAL "-lirc" ${__lib} __lirc) 
    endif()        
    if(NOT __lirc_s) 
      string(COMPARE EQUAL "-lirc_s" ${__lib} __lirc_s) 
    endif()                    
  endforeach()

  enable_language(Fortran)
  function(ga_find_flibs __flibvar __flib_name)
    if(${__flibvar})
      find_library(GA_Fortran_LIBRARY
        NAMES "${__flib_name}.so" "${__flib_name}.a"
        HINTS ${CMAKE_Fortran_IMPLICIT_LINK_DIRECTORIES}
      )
      set(GLOBALARRAYS_LIBRARIES ${GLOBALARRAYS_LIBRARIES} ${GA_Fortran_LIBRARY} PARENT_SCOPE)
    endif()
  endfunction()

  ga_find_flibs(__lifcoremt_pic "libifcoremt_pic")
  ga_find_flibs(__lgfortran "libgfortran")
  ga_find_flibs(__lquadmath "libquadmath")
  ga_find_flibs(__lifcoremt "libifcoremt")
  ga_find_flibs(__lifport "libifport")
  ga_find_flibs(__limf "libimf")
  ga_find_flibs(__lsvml "libsvml")
  ga_find_flibs(__lipgo "libipgo")
  ga_find_flibs(__lirc "libirc")
  ga_find_flibs(__lirc_s "libirc_s")

  # if(__lifcoremt_pic)
  #   enable_language(Fortran)
  #   find_library(GA_IFCOREMT_LIBRARY
  #     NAMES libifcoremt_pic.so libifcoremt_pic.a 
  #     HINTS ${CMAKE_Fortran_IMPLICIT_LINK_DIRECTORIES}
  #   )
  #   set(GLOBALARRAYS_LIBRARIES ${GLOBALARRAYS_LIBRARIES} ${GA_IFCOREMT_LIBRARY})
  # endif()

  # if(__lgfortran)
  #   enable_language(Fortran)
  #   find_library(GA_STANDARDFORTRAN_LIBRARY
  #     NAMES libgfortran.so libgfortran.a
  #     HINTS ${CMAKE_Fortran_IMPLICIT_LINK_DIRECTORIES}
  #   )
  #   set(GLOBALARRAYS_LIBRARIES ${GLOBALARRAYS_LIBRARIES} ${GA_STANDARDFORTRAN_LIBRARY})
  # endif()

  # if(__lquadmath)
  #   enable_language(Fortran)
  #   find_library(GA_QMATH_LIBRARY
  #     NAMES  libquadmath.so libquadmath.a
  #     HINTS ${CMAKE_Fortran_IMPLICIT_LINK_DIRECTORIES}
  #   )
  #   set(GLOBALARRAYS_LIBRARIES ${GLOBALARRAYS_LIBRARIES} ${GA_QMATH_LIBRARY})
  # endif()

  if(__lpthread)
    set(THREADS_PREFER_PTHREAD_FLAG ON)
    find_package(Threads REQUIRED)
    set(GLOBALARRAYS_LIBRARIES ${GLOBALARRAYS_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})
  endif()

  if(__lrt)
    find_package(LibRT REQUIRED)
  else()
    #For now since GA does not export librt in some configurations
    find_package(LibRT QUIET)
  endif()
  if(LIBRT_LIBRARIES)
    set(GLOBALARRAYS_LIBRARIES ${GLOBALARRAYS_LIBRARIES} ${LIBRT_LIBRARIES})
  endif()

  if(__lmath)
    find_package(LibM REQUIRED)
    set(GLOBALARRAYS_LIBRARIES ${GLOBALARRAYS_LIBRARIES} ${LIBM_LIBRARIES})
  endif()

  if(__libverbs)
    find_package(Ibverbs REQUIRED)
    set(GLOBALARRAYS_LIBRARIES ${GLOBALARRAYS_LIBRARIES} ${IBVERBS_LIBRARIES})
  endif()
endif()



