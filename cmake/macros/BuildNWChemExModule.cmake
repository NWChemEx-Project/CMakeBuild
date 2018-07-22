set(NWXBASE_MACROS ${CMAKE_CURRENT_LIST_DIR})

function(build_nwchemex_module SUPER_PROJECT_ROOT)

    #Set the environment up and pull-in macros we'll need
    include(${NWXBASE_MACROS}/SetPaths.cmake)
    set_paths() #Puts macro paths in module path
    include(OptionMacros)
    include(DependencyMacros)
    include(ExternalProject)
    include(UtilityMacros)

    #We require C++14 get it out of the way early
    option_w_default(CMAKE_CXX_STANDARD 14)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -Wall")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3")

    print_banner("Configuration Options")

    option_w_default(CMAKE_BUILD_TYPE Release)
    option_w_default(BUILD_SHARED_LIBS TRUE)
    option_w_default(CMAKE_POSITION_INDEPENDENT_CODE TRUE)
    option_w_default(BUILD_TESTS TRUE)    #Should we build the tests?
    option_w_default(NWX_DEBUG_CMAKE TRUE) #Enable lots of extra CMake printing?
    option_w_default(CMAKE_EXPORT_COMPILE_COMMANDS ON)
    option_w_default(CMAKE_VERBOSE_MAKEFILE ${NWX_DEBUG_CMAKE})
    option_w_default(CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY TRUE)

    print_banner("NWChemEx Module Paths")

    option_w_default(NWX_PROJECTS ${PROJECT_NAME}) # List of modules to build
    foreach(__project ${NWX_PROJECTS})
        #Directory where the sub-project's source is located
        option_w_default(${__project}_SRC_DIR ${SUPER_PROJECT_ROOT}/${__project})
        #Includes should be relative to NWX_SRC_DIR without last directory
        get_filename_component(${__project}_INCLUDE_DIR "${${__project}_SRC_DIR}"
                DIRECTORY)
        #Directory where your tests are
        option_w_default(${__project}_TEST_DIR
                ${SUPER_PROJECT_ROOT}/${__project}_Test)
        #Name of variable containing your project's dependencies
        option_w_default(${__project}_DEPENDENCIES "")
    endforeach()

    #Make a list of all CMake variables that should be passed to all dependencies
    bundle_cmake_args(CORE_CMAKE_OPTIONS CMAKE_CXX_COMPILER CMAKE_C_COMPILER
            CMAKE_Fortran_COMPILER CMAKE_BUILD_TYPE BUILD_SHARED_LIBS
            CMAKE_INSTALL_PREFIX CMAKE_CXX_STANDARD CMAKE_VERSION PROJECT_VERSION
            CMAKE_POSITION_INDEPENDENT_CODE CMAKE_VERBOSE_MAKEFILE
            CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY CMAKE_EXPORT_COMPILE_COMMANDS)

    bundle_cmake_list(CORE_CMAKE_LISTS CMAKE_PREFIX_PATH CMAKE_INSTALL_RPATH
            CMAKE_MODULE_PATH)

    bundle_cmake_strings(CORE_CMAKE_STRINGS CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG)

    set (CMAKE_BUILD_TYPE Release)
    bundle_cmake_args(DEPENDENCY_CMAKE_OPTIONS CMAKE_CXX_COMPILER CMAKE_C_COMPILER
            CMAKE_Fortran_COMPILER CMAKE_BUILD_TYPE BUILD_SHARED_LIBS
            CMAKE_INSTALL_PREFIX CMAKE_CXX_STANDARD CMAKE_VERSION PROJECT_VERSION
            CMAKE_POSITION_INDEPENDENT_CODE CMAKE_VERBOSE_MAKEFILE
            CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY CMAKE_EXPORT_COMPILE_COMMANDS)

    print_banner("Locating Dependencies and Creating Targets")
    ################################################################################
    #
    # Add the subprojects, their dependencies, and their tests
    #
    ################################################################################

    foreach(__project ${NWX_PROJECTS})
        foreach(depend ${${__project}_DEPENDENCIES})
            find_or_build_dependency(${depend})
            are_we_building(${depend} were_building)
            if(were_building)
                list(APPEND DEPENDS_WERE_BUILDING ${depend})
            else()
                list(APPEND DEPENDS_WE_FOUND ${depend})
                package_dependency(${depend} DEPENDENCY_PATHS)
            endif()

        endforeach()

        ExternalProject_Add(${__project}_External
                SOURCE_DIR ${${__project}_SRC_DIR}
                CMAKE_ARGS -DNWX_DEBUG_CMAKE=${NWX_DEBUG_CMAKE}
                           -DNWX_INCLUDE_DIR=${${__project}_INCLUDE_DIR}
                           ${CORE_CMAKE_OPTIONS}
                BUILD_ALWAYS 1
                INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
                CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                                 ${CORE_CMAKE_STRINGS}
                                 ${DEPENDENCY_PATHS}
                -DNWX_DEPENDENCIES:STRING=${${__project}_DEPENDENCIES}
                )

        foreach(depend ${${__project}_DEPENDENCIES})
            add_dependencies(${__project}_External ${depend}_External)
        endforeach()

        if(${BUILD_TESTS})
            list(APPEND TEST_DEPENDS "CMakeBuild" "${__project}")
            ExternalProject_Add(${__project}_Tests_External
                    SOURCE_DIR ${${__project}_TEST_DIR}
                    CMAKE_ARGS -DSUPER_PROJECT_ROOT=${SUPER_PROJECT_TEST}
                               -DNWX_DEBUG_CMAKE=${NWX_DEBUG_CMAKE}
                               -DSTAGE_INSTALL_DIR=${STAGE_INSTALL_DIR}
                               ${CORE_CMAKE_OPTIONS}

                    BUILD_ALWAYS 1
                    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${TEST_STAGE_DIR}
                    CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                                     ${CORE_CMAKE_STRINGS}
                                     -DNWX_DEPENDENCIES:LIST=${TEST_DEPENDS}
                    )
            add_dependencies(${__project}_Tests_External ${__project}_External)

            # This file will allow us to run ctest in the top-level build dir
            # Basically it just defers to the actual top-level CTestTestfile.cmake in the
            # build directory for this project
            file(WRITE ${CMAKE_BINARY_DIR}/CTestTestfile.cmake
                    "subdirs(test_stage${CMAKE_INSTALL_PREFIX}/tests)")
        endif()
    endforeach()

    # Install the staging directory
    install(DIRECTORY ${STAGE_INSTALL_DIR}/
            DESTINATION ${CMAKE_INSTALL_PREFIX} USE_SOURCE_PERMISSIONS)

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
    configure_file(
        "${NWXBASE_CMAKE}/cmake_uninstall.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
        IMMEDIATE @ONLY)

        add_custom_target(uninstall
                COMMAND ${CMAKE_COMMAND} -P
                ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)
endfunction()
