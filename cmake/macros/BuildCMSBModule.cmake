set(CMSB_MACROS ${CMAKE_CURRENT_LIST_DIR})

function(build_cmsb_module SUPER_PROJECT_ROOT)

    #Set the environment up and pull-in macros we'll need
    include(${CMSB_MACROS}/SetPaths.cmake)
    set_paths() #Puts macro paths in module path
    include(OptionMacros)
    include(DependencyMacros)
    include(ExternalProject)
    include(UtilityMacros)

    #We require C++14 get it out of the way early
    option_w_default(CMAKE_CXX_STANDARD 17)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    option_w_default(BLAS_INT4 OFF)
    option_w_default(BLAS_VENDOR BLIS)
    option_w_default(ENABLE_COVERAGE OFF)
    option_w_default(CMAKE_CXX_EXTENSIONS OFF)
    option_w_default(CMAKE_BUILD_TYPE Release)
    option_w_default(USE_OPENMP ON)
    option_w_default(USE_DPCPP OFF)
    option_w_default(ENABLE_DPCPP ${USE_DPCPP})
    option_w_default(USE_CUTENSOR OFF)
    option_w_default(USE_GA_AT OFF)
    option_w_default(USE_GA_DEV OFF)
    option_w_default(USE_GA_PROFILER OFF)
    option_w_default(CUDA_MAXREGCOUNT 64)


    if(USE_DPCPP)
        if(${CMAKE_MINOR_VERSION} EQUAL "19" AND ${CMAKE_PATCH_VERSION} LESS "2") 
            message(FATAL_ERROR "DPCPP build does not work with CMake versions 3.19.0 and 3.19.1. \
            Please use a version >= 3.19.2")
        endif()
        if(USE_OPENMP)
          message(FATAL_ERROR "DPCPP build requires USE_OPENMP=OFF")
        endif()
    endif()

    if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        if(NOT "${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Darwin")
            get_filename_component(__CMSB_GCC_INSTALL_PREFIX "${CMAKE_Fortran_COMPILER}/../.." ABSOLUTE)
            if(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
                set(CMSB_GCC_TOOLCHAIN_FLAG "--gcc-toolchain=${__CMSB_GCC_INSTALL_PREFIX}")
            else()
                if(GCCROOT)
                    set(CMSB_GCC_TOOLCHAIN_FLAG "--gcc-toolchain=${GCCROOT}")
                else()
                    message(FATAL_ERROR "GCCROOT variable not set when using clang compilers. \
                        The GCCROOT path can be found using the command: \"which gcc\" ")
                endif()
            endif()
            message(STATUS "CMSB_GCC_TOOLCHAIN_FLAG: ${CMSB_GCC_TOOLCHAIN_FLAG}")
        endif()
    endif()

    if(CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
        set(CMSB_EXTRA_FLAGS "-xHost")
    elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "ppc64le")
        set(CMSB_EXTRA_FLAGS "-mtune=native")
        if(USE_CUDA)
            #nvcc does not recgonize -mtune=power9
            set(CMSB_EXTRA_FLAGS "-mtune=powerpc64le")
        endif()
    else()
        set(CMSB_EXTRA_FLAGS "-march=native")
    endif()

    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wall ${CMSB_GCC_TOOLCHAIN_FLAG} ${CMSB_EXTRA_FLAGS}")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -Wall ${CMSB_GCC_TOOLCHAIN_FLAG} ${CMSB_EXTRA_FLAGS}")
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -Wall ${CMSB_GCC_TOOLCHAIN_FLAG} ${CMSB_EXTRA_FLAGS}")

    string(TOUPPER ${CMAKE_BUILD_TYPE} CMSB_CMAKE_BUILD_TYPE)
    set(CMSB_CXX_FLAGS CMAKE_CXX_FLAGS_${CMSB_CMAKE_BUILD_TYPE})

    if(NOT BLAS_INT4 AND USE_SCALAPACK AND NOT "${BLAS_VENDOR}" STREQUAL "IntelMKL")
        message( FATAL_ERROR "ReferenceScaLAPACK with ILP64 interface is currently not supported. Please set -DBLAS_INT4=ON" )
    endif()

    print_banner("Configuration Options")
    
    option_w_default(BUILD_SHARED_LIBS OFF)
    option_w_default(CMAKE_POSITION_INDEPENDENT_CODE TRUE)
    option_w_default(BUILD_TESTS ON)    #Should we build the tests?
    option_w_default(BUILD_METHODS ON)
    option_w_default(CMSB_DEBUG_CMAKE TRUE) #Enable lots of extra CMake printing?
    option_w_default(CMAKE_EXPORT_COMPILE_COMMANDS ON)
    option_w_default(CMAKE_VERBOSE_MAKEFILE ${CMSB_DEBUG_CMAKE})
    option_w_default(CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY TRUE)

    print_banner("CMSB Module Paths")

    option_w_default(CMSB_PROJECTS ${PROJECT_NAME}) # List of modules to build
    foreach(__project ${CMSB_PROJECTS})
        #Directory where the sub-project's source is located
        option_w_default(${__project}_SRC_DIR ${SUPER_PROJECT_ROOT}/${__project})
        #Includes should be relative to CMSB_SRC_DIR without last directory
        get_filename_component(${__project}_INCLUDE_DIR "${${__project}_SRC_DIR}"
                DIRECTORY)
        #Directory where your tests are
        option_w_default(${__project}_TEST_DIR
                ${SUPER_PROJECT_ROOT}/${__project}_Test)
        #Name of variable containing your project's dependencies
        option_w_default(${__project}_DEPENDENCIES "")
    endforeach()

    set(SUPER_PROJECT_BINARY_DIR ${CMAKE_BINARY_DIR})
    set(CMSB_CORE_OPTIONS CMAKE_CXX_COMPILER CMAKE_C_COMPILER SUPER_PROJECT_BINARY_DIR
        CMAKE_Fortran_COMPILER CMAKE_BUILD_TYPE BUILD_SHARED_LIBS ${CMSB_CXX_FLAGS}
        CMAKE_INSTALL_PREFIX CMAKE_CXX_STANDARD CMAKE_VERSION PROJECT_VERSION
        CMAKE_POSITION_INDEPENDENT_CODE CMAKE_VERBOSE_MAKEFILE CMAKE_CXX_EXTENSIONS
        CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY CMAKE_EXPORT_COMPILE_COMMANDS MPIEXEC_EXECUTABLE)

    set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

    #Make a list of all CMake variables that should be passed to all dependencies
    bundle_cmake_args(CORE_CMAKE_OPTIONS ${CMSB_CORE_OPTIONS})

    bundle_cmake_list(CORE_CMAKE_LISTS CMAKE_PREFIX_PATH CMAKE_MODULE_PATH
                                       CMAKE_INSTALL_RPATH_USE_LINK_PATH)

    bundle_cmake_strings(CORE_CMAKE_STRINGS ${CMSB_CXX_FLAGS})

    bundle_cmake_args(DEPENDENCY_CMAKE_OPTIONS ${CMSB_CORE_OPTIONS})

    if (USE_SCALAPACK) 
        bundle_cmake_args(DEPENDENCY_CMAKE_OPTIONS USE_SCALAPACK)
        set(TAMM_CXX_FLAGS "${TAMM_CXX_FLAGS} -DUSE_SCALAPACK")
    endif()

    set(TAMM_CXX_FLAGS "${TAMM_CXX_FLAGS} -DOMPI_SKIP_MPICXX")

    bundle_cmake_args(DEPENDENCY_CMAKE_OPTIONS BLAS_INT4 BLAS_VENDOR ENABLE_COVERAGE)

    print_banner("Locating Dependencies and Creating Targets")
    ################################################################################
    #
    # Add the subprojects, their dependencies, and their tests
    #
    ################################################################################

    if(${BLAS_VENDOR} STREQUAL "BLIS")
        list(APPEND TAMM_EXTRA_LIBS -ldl)
    endif()

    bundle_cmake_strings(CORE_CMAKE_STRINGS BLAS_VENDOR)
    set(DEPENDENCY_ROOT_DIRS)

    foreach(__project ${CMSB_PROJECTS})
        foreach(depend ${${__project}_DEPENDENCIES})
            find_or_build_dependency(${depend})
            are_we_building(${depend} were_building)
            if(were_building)
                list(APPEND DEPENDS_WERE_BUILDING ${depend})
            else()
                list(APPEND DEPENDS_WE_FOUND ${depend})
                package_dependency(${depend} DEPENDENCY_PATHS)
            endif()

            is_valid(${depend}_ROOT __deproot_set)
            if(__deproot_set)
                bundle_cmake_args(DEPENDENCY_ROOT_DIRS ${depend}_ROOT)
            endif()
        endforeach()

        if(ENABLE_COVERAGE)
            set(TAMM_CXX_FLAGS "${TAMM_CXX_FLAGS} --coverage -O0")
            list(APPEND TAMM_EXTRA_LIBS --coverage)
        endif()

        if(USE_CUDA)
            set(TAMM_CXX_FLAGS "${TAMM_CXX_FLAGS} -DUSE_CUDA")
        endif()

        if(USE_DPCPP)
            set(TAMM_CXX_FLAGS "${TAMM_CXX_FLAGS} -DUSE_DPCPP") #-fsycl
        endif()      

        if(USE_GA_AT)
            bundle_cmake_strings(CORE_CMAKE_STRINGS USE_GA_AT)
            set(TAMM_CXX_FLAGS "${TAMM_CXX_FLAGS} -DUSE_GA_AT")
            if(NOT "${BLAS_VENDOR}" STREQUAL "IntelMKL")
                message(FATAL_ERROR "USE_GA_AT=ON only works with BLAS_VENDOR=IntelMKL")
            endif()
        endif()

        set(${CMSB_CXX_FLAGS} "${${CMSB_CXX_FLAGS}} ${TAMM_CXX_FLAGS}")
        bundle_cmake_strings(CORE_CMAKE_STRINGS ${CMSB_CXX_FLAGS})

        # if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        #     find_library(stdfs_LIBRARY 
        #         NAMES c++fs 
        #         PATHS ${CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES} 
        #         DOC "LIBC++ FS Library" 
        #     )
        # else()
        if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
            if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "9.1")
                find_library(stdfs_LIBRARY 
                    NAMES stdc++fs 
                    PATHS ${CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES} 
                    DOC "GNU FS Library" 
                )
                message(STATUS "STDFS LIB: ${stdfs_LIBRARY}")
            endif()
        endif()
        
        if(stdfs_LIBRARY)
            list(APPEND TAMM_EXTRA_LIBS ${stdfs_LIBRARY})
        endif()

        if(TAMM_EXTRA_LIBS)
            bundle_cmake_strings(CORE_CMAKE_STRINGS TAMM_EXTRA_LIBS)
            message(STATUS "TAMM_EXTRA_LIBS: ${TAMM_EXTRA_LIBS}")
        endif()

        if(USE_CUDA)
            # if(NOT USE_OPENMP)
            #     message(FATAL_ERROR "CUDA build requires USE_OPENMP=ON")
            # endif()
            bundle_cmake_strings(CORE_CMAKE_STRINGS USE_CUDA NV_GPU_ARCH CUDA_MAXREGCOUNT)
            if(USE_CUTENSOR)
                bundle_cmake_strings(CORE_CMAKE_STRINGS USE_CUTENSOR)
                if(CUTENSOR_INSTALL_PREFIX)
                    bundle_cmake_strings(CORE_CMAKE_STRINGS CUTENSOR_INSTALL_PREFIX)
                else()
                    message(FATAL_ERROR "USE_CUTENSOR=ON, but CUTENSOR_INSTALL_PREFIX not provided")
                endif()
            endif()
        endif()

        if(USE_OPENMP)
            bundle_cmake_strings(CORE_CMAKE_STRINGS USE_OPENMP)
            if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
                if("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Darwin" OR USE_DPCPP)
                    bundle_cmake_strings(CORE_CMAKE_STRINGS OpenMP_C_FLAGS OpenMP_CXX_FLAGS)
                    bundle_cmake_strings(CORE_CMAKE_STRINGS OpenMP_C_LIB_NAMES OpenMP_CXX_LIB_NAMES OpenMP_omp_LIBRARY OpenMP_libiomp5_LIBRARY)
                endif()
            endif()
        endif()  

        if(USE_GA_DEV)
            bundle_cmake_strings(CORE_CMAKE_STRINGS USE_GA_DEV)
            if(USE_GA_PROFILER)
                bundle_cmake_strings(CORE_CMAKE_STRINGS USE_GA_PROFILER)
            endif()
        endif()        

        ExternalProject_Add(${__project}_External
                SOURCE_DIR ${${__project}_SRC_DIR}
                CMAKE_ARGS -DCMSB_DEBUG_CMAKE=${CMSB_DEBUG_CMAKE}
                           -DCMSB_INCLUDE_DIR=${${__project}_INCLUDE_DIR}
                           -DSTAGE_DIR=${STAGE_DIR}
                           ${CORE_CMAKE_OPTIONS}
                           ${DEPENDENCY_ROOT_DIRS}
                BUILD_ALWAYS 1
                INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
                CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                                 ${CORE_CMAKE_STRINGS}
                                 ${DEPENDENCY_PATHS}
                -DCMSB_DEPENDENCIES:STRING=${${__project}_DEPENDENCIES}
                )

        foreach(depend ${${__project}_DEPENDENCIES})
            add_dependencies(${__project}_External ${depend}_External)
        endforeach()

        if(${BUILD_TESTS})
            list(APPEND TEST_DEPENDS "CMakeBuild" "${__project}")
            ExternalProject_Add(${__project}_Tests_External
                    SOURCE_DIR ${${__project}_TEST_DIR}
                    CMAKE_ARGS -DSUPER_PROJECT_ROOT=${SUPER_PROJECT_ROOT}
                               -DCMSB_DEBUG_CMAKE=${CMSB_DEBUG_CMAKE}
                               -DSTAGE_DIR=${STAGE_DIR}
                               -DSTAGE_INSTALL_DIR=${STAGE_INSTALL_DIR}
                               ${CORE_CMAKE_OPTIONS}

                    BUILD_ALWAYS 1
                    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${TEST_STAGE_DIR}
                    CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                                     ${CORE_CMAKE_STRINGS}
                                     ${DEPENDENCY_PATHS}
                                     -DCMSB_DEPENDENCIES:LIST=${TEST_DEPENDS}
                    )
            add_dependencies(${__project}_Tests_External ${__project}_External)

            # This file will allow us to run ctest in the top-level build dir
            # Basically it just defers to the actual top-level CTestTestfile.cmake in the
            # build directory for this project
            file(WRITE ${CMAKE_BINARY_DIR}/CTestTestfile.cmake
                    "subdirs(test_stage${CMAKE_INSTALL_PREFIX}/tests)")
        endif()
        if(${BUILD_METHODS})
            list(APPEND METHOD_DEPENDS "CMakeBuild" "${__project}")
            ExternalProject_Add(${__project}_Methods_External
                    SOURCE_DIR ${${__project}_METHODS_DIR}
                    CMAKE_ARGS -DSUPER_PROJECT_ROOT=${SUPER_PROJECT_ROOT}
                               -DSUPER_PROJECT_BINARY_DIR=${SUPER_PROJECT_BINARY_DIR}
                               -DCMSB_DEBUG_CMAKE=${CMSB_DEBUG_CMAKE}
                               -DSTAGE_DIR=${STAGE_DIR}
                               -DSTAGE_INSTALL_DIR=${STAGE_INSTALL_DIR}
                               ${CORE_CMAKE_OPTIONS}

                    BUILD_ALWAYS 1
                    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${METHODS_STAGE_DIR}
                    CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                                     ${CORE_CMAKE_STRINGS}
                                     ${DEPENDENCY_PATHS}
                                     -DCMSB_DEPENDENCIES:LIST=${METHOD_DEPENDS}
                    )
            add_dependencies(${__project}_Methods_External ${__project}_External)

            # This file will allow us to run ctest in the top-level build dir
            # Basically it just defers to the actual top-level CTestTestfile.cmake in the
            # build directory for this project
            file(APPEND ${CMAKE_BINARY_DIR}/CTestTestfile.cmake
                    "\nsubdirs(methods_stage${CMAKE_INSTALL_PREFIX}/methods)")
        endif()        
    endforeach()

    # Install the staging directory
    install(DIRECTORY ${STAGE_INSTALL_DIR}/
            DESTINATION ${CMAKE_INSTALL_PREFIX} USE_SOURCE_PERMISSIONS)

    if(${PROJECT_NAME} STREQUAL "tamm")
        if(TARGET Libint2::libint2_cxx)
            get_target_property(LI_CD Libint2::libint2_cxx INTERFACE_COMPILE_DEFINITIONS)
            string(REPLACE "=" " " LI_CD ${LI_CD})
            separate_arguments(LI_CD UNIX_COMMAND ${LI_CD})
            list (GET LI_CD 1 LI_BASIS_SET_PATH)
            install(DIRECTORY ${CMAKE_SOURCE_DIR}/methods/basis/
                    DESTINATION ${LI_BASIS_SET_PATH}/basis USE_SOURCE_PERMISSIONS)
        endif()
    endif()

    ############################################################################
    #
    # Let the user know all the settings we worked out
    #
    ############################################################################

    print_banner("Summary of ${PROJECT_NAME} Configuration Settings:")
    message(STATUS "Found the following dependencies: ")
    foreach(__depend ${DEPENDS_WE_FOUND})
        message(STATUS "    ${__depend}")
    endforeach()
    message(STATUS "Will build the following dependencies: ")
    foreach(__depend ${DEPENDS_WERE_BUILDING})
        message(STATUS "    ${__depend}")
    endforeach()

    ############################################################################
    #
    # Make an uninstall target
    #
    ############################################################################
    # configure_file(
    #     "${CMSB_CMAKE}/cmake_uninstall.cmake.in"
    #     "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
    #     IMMEDIATE @ONLY)

    #     add_custom_target(uninstall
    #             COMMAND ${CMAKE_COMMAND} -P
    #             ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)
endfunction()

