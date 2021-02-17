#
# This file builds Global Arrays.
#
include(UtilityMacros)
include(DependencyMacros)

enable_language(Fortran)

if(USE_GA_AT)
    # Now find or build GA's dependencies
    if(USE_SCALAPACK)
        find_or_build_dependency(ScaLAPACK)
        package_dependency(ScaLAPACK DEPENDENCY_PATHS)
    endif()
    foreach(depend LAPACK BLAS MPI)
        find_or_build_dependency(${depend})
        package_dependency(${depend} DEPENDENCY_PATHS)
    endforeach()

    if("${LINALG_VENDOR}" STREQUAL "IntelMKL")
        set(BLA_VENDOR_MKL ON)
        set(BLA_LAPACK_INT       "MKL_INT")
        set(BLA_LAPACK_COMPLEX8  "MKL_Complex8")
        set(BLA_LAPACK_COMPLEX16 "MKL_Complex16")        
    elseif("${LINALG_VENDOR}" STREQUAL "IBMESSL")
        set(BLA_VENDOR_ESSL ON)
        set(BLA_LAPACK_INT "int64_t")
        if(BLAS_INT4)
            set(BLA_LAPACK_INT "int32_t")
        endif()
        set(BLA_LAPACK_COMPLEX8  "std::complex<float>")
        set(BLA_LAPACK_COMPLEX16 "std::complex<double>")        
    elseif("${LINALG_VENDOR}" STREQUAL "BLIS")
        set(USE_BLIS ON)
        set(BLA_VENDOR_BLIS ON)
        set(BLA_LAPACK_INT "int64_t")
        if(BLAS_INT4)
            set(BLA_LAPACK_INT "int32_t")
        endif()
        set(BLA_LAPACK_COMPLEX8  "std::complex<float>")
        set(BLA_LAPACK_COMPLEX16 "std::complex<double>")
    endif()
    
    ##########################################################
    # Determine aggregate remote memory copy interface (ARMCI)
    ##########################################################

    #Possible choices
    set(GA_RUNTIME_OPTIONS MPI-PR OPENIB MPI-TS)
    # (BGML DCMF OPENIB GEMINI DMAPP PORTALS GM VIA
    #  LAPI MPI-SPAWN MPI-PT MPI-MT MPI-PR MPI-TS MPI3 OFI
    #  OFA SOCKETS MELLANOX)

    # Get index user choose
    is_valid_and_true(GA_RUNTIME __set)
    if (NOT __set)
        message(STATUS "ARMCI network not set, defaulting to MPI-PR")
        set(GA_RUNTIME "--with-mpi-pr")
    else()
        list(FIND GA_RUNTIME_OPTIONS ${GA_RUNTIME} _index)
        if(${_index} EQUAL -1)
            message(WARNING "Unrecognized ARMCI Network, defaulting to MPI-PR")
            set(GA_RUNTIME "--with-mpi-pr")
        elseif(${_index} EQUAL 4)
            message(WARNING "We discourage the use of GA_RUNTIME=DMAPP")
            message(WARNING "Please consider using GA_RUNTIME=MPI-PR instead")
            set(GA_RUNTIME "--with-dmapp")
        else()
            string(TOLOWER ${GA_RUNTIME} _ga_runtime)
            set(GA_RUNTIME "--with-${_ga_runtime}")
        endif()
    endif()

    # message(STATUS ${CMAKE_BINARY_DIR}/stage)
    # Add the mock CMake-ified GA project
    ExternalProject_Add(GlobalArrays_External
            SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/GlobalArrays
            CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS}
                    -DSUPER_PROJECT_ROOT=${SUPER_PROJECT_ROOT}
                    -DCMSB_DEBUG_CMAKE=${CMSB_DEBUG_CMAKE}
                    -DGA_RUNTIME=${GA_RUNTIME}
                    -DSTAGE_DIR=${STAGE_DIR}
                    -DUSE_GA_DEV=${USE_GA_DEV}
                    -DUSE_GA_PROFILER=${USE_GA_PROFILER}
            #BUILD_ALWAYS 1
            INSTALL_COMMAND ""
            CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                            ${CORE_CMAKE_STRINGS}
                            ${DEPENDENCY_PATHS}
    )

    set(GA_INSTALL_DIR ${STAGE_DIR}${CMAKE_INSTALL_PREFIX})

    CONFIGURE_FILE( ${CMAKE_CURRENT_LIST_DIR}/GlobalArrays/ga_linalg.h.in
                    ${CMAKE_CURRENT_BINARY_DIR}/ga_linalg.h )

    set(GENH_LOC ${GA_INSTALL_DIR}/include/ga_linalg.h)
 
    add_custom_command(
        OUTPUT ${GENH_LOC}
        COMMAND ${CMAKE_COMMAND} -E make_directory  ${GA_INSTALL_DIR}/include
        COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/ga_linalg.h
            ${GENH_LOC}
        DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/ga_linalg.h                                      
    )

    add_custom_target(
        GenerateLAH ALL
        DEPENDS ${GENH_LOC}
    )                     

    # Establish the dependencies
    if(USE_SCALAPACK)
        add_dependencies(GlobalArrays_External ScaLAPACK_External LAPACK_External 
                         BLAS_External MPI_External GenerateLAH)
    else()
        add_dependencies(GlobalArrays_External LAPACK_External 
                         BLAS_External MPI_External GenerateLAH)
    endif()
else()

    # Get index user choose
    is_valid_and_true(GA_RUNTIME __set)
    if (NOT __set)
        message(STATUS "ARMCI network not set, defaulting to MPI_PROGRESS_RANK")
        set(GA_RUNTIME MPI_PROGRESS_RANK)
    endif()

    set(GA_REPO "https://github.com/GlobalArrays/ga.git")
    if(USE_GA_DEV)
        set(GA_REPO "https://github.com/ajaypanyala/ga.git")
    endif()

    if(GCCROOT)
        set(Clang_GCCROOT "-DGCCROOT=${GCCROOT}")
    endif()

    if(DEFINED TAMM_EXTRA_LIBS)
        set(GA_CMSB_EXTRA_LIBS "-DGA_EXTRA_LIBS=${TAMM_EXTRA_LIBS}")
    endif()


    if(BLAS_INT4)
        set(LINALG_REQUIRED_COMPONENTS "lp64")
    else()
        set(LINALG_REQUIRED_COMPONENTS "ilp64")
    endif()

    if("${LINALG_VENDOR}" STREQUAL "IntelMKL")
        set(LINALG_THREAD_LAYER "sequential")
        if(USE_OPENMP)
            set(LINALG_THREAD_LAYER "openmp")
        endif()
    elseif("${LINALG_VENDOR}" STREQUAL "IBMESSL")
        if(USE_OPENMP)
            set(LINALG_THREAD_LAYER "smp")
        endif()
    endif()

    if(LINALG_THREAD_LAYER)
      set(GA_LINALG_THREAD_LAYER "-DLINALG_THREAD_LAYER=${LINALG_THREAD_LAYER}")
    endif()

    set(GA_LINALG_ROOT   "-DLINALG_PREFIX=${LINALG_PREFIX}")

    if(${LINALG_VENDOR} STREQUAL "BLIS" OR ${LINALG_VENDOR} STREQUAL "IBMESSL")
        set(BLAS_PREFERENCE_LIST ${LINALG_VENDOR})
        set(LAPACK_PREFERENCE_LIST ReferenceLAPACK)

        set(LINALG_PREFER_STATIC ON)
        if(BUILD_SHARED_LIBS)
          set(LINALG_PREFER_STATIC OFF)
        endif()
        set(${LINALG_VENDOR}_PREFERS_STATIC    ${LINALG_PREFER_STATIC})
        set(ReferenceLAPACK_PREFERS_STATIC     ${LINALG_PREFER_STATIC})
        set(ReferenceScaLAPACK_PREFERS_STATIC  ${LINALG_PREFER_STATIC})
    
        set(${LINALG_VENDOR}_THREAD_LAYER  ${LINALG_THREAD_LAYER})
        set(BLAS_REQUIRED_COMPONENTS       ${LINALG_REQUIRED_COMPONENTS})
        set(LAPACK_REQUIRED_COMPONENTS     ${LINALG_REQUIRED_COMPONENTS})
        set(ScaLAPACK_REQUIRED_COMPONENTS  ${LINALG_REQUIRED_COMPONENTS})

        if(${LINALG_VENDOR} STREQUAL "BLIS")
            set(GA_LINALG_ROOT   "-DLINALG_PREFIX=${CMAKE_INSTALL_PREFIX}")
        endif()

        if(USE_SCALAPACK)
            set(ScaLAPACK_PREFERENCE_LIST ReferenceScaLAPACK)
            find_or_build_dependency(ScaLAPACK)
            list(APPEND  GA_LINALG_ROOT "-DScaLAPACK_PREFIX=${CMAKE_INSTALL_PREFIX}")
        else()
            find_or_build_dependency(LAPACK)
            #include(BuildBLAS)
        endif()

        list(APPEND  GA_LINALG_ROOT "-DLAPACK_PREFIX=${CMAKE_INSTALL_PREFIX}")
    endif()

    if(USE_SCALAPACK)
        set(GA_ScaLAPACK "-DENABLE_SCALAPACK=ON")
    endif()

    if(USE_DPCPP)
        set(GA_DPCPP "-DENABLE_DPCPP=ON")
    endif()

    message(STATUS "GlobalArrays CMake Options: ${DEPENDENCY_CMAKE_OPTIONS} \
    -DENABLE_BLAS=ON -DLINALG_VENDOR=${LINALG_VENDOR} ${GA_LINALG_ROOT} \
    ${GA_DPCPP} -DGA_RUNTIME=${GA_RUNTIME} -DENABLE_PROFILING=${USE_GA_PROFILER} \
    ${GA_CMSB_EXTRA_LIBS} ${Clang_GCCROOT} ${GA_LINALG_THREAD_LAYER} \
    -DLINALG_REQUIRED_COMPONENTS=${LINALG_REQUIRED_COMPONENTS} ${GA_ScaLAPACK}")

    ExternalProject_Add(GlobalArrays_External
        # # URL https://github.com/GlobalArrays/ga/releases/download/v${PROJECT_VERSION}/ga-${PROJECT_VERSION}.tar.gz
        GIT_REPOSITORY ${GA_REPO}
        GIT_TAG develop
        UPDATE_DISCONNECTED 1
        CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS} -DENABLE_BLAS=ON -DLINALG_VENDOR=${LINALG_VENDOR} ${GA_LINALG_ROOT}
        ${GA_DPCPP} -DGA_RUNTIME=${GA_RUNTIME} -DENABLE_PROFILING=${USE_GA_PROFILER} ${GA_CMSB_EXTRA_LIBS} ${Clang_GCCROOT}
        ${GA_LINALG_THREAD_LAYER} -DLINALG_REQUIRED_COMPONENTS=${LINALG_REQUIRED_COMPONENTS} ${GA_ScaLAPACK}
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
        CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                        ${CORE_CMAKE_STRINGS}
    )

    # # Establish the dependencies
    if(${LINALG_VENDOR} STREQUAL "BLIS" OR ${LINALG_VENDOR} STREQUAL "IBMESSL")
        if(${LINALG_VENDOR} STREQUAL "BLIS")
            add_dependencies(GlobalArrays_External BLAS_External LAPACK_External)
        elseif(${LINALG_VENDOR} STREQUAL "IBMESSL")
            add_dependencies(GlobalArrays_External LAPACK_External)
        endif()
        if(USE_SCALAPACK)
            add_dependencies(GlobalArrays_External ScaLAPACK_External)
        endif()
    endif()

endif()


