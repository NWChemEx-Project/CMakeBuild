################################################################################
#
# Macros for defining new targets.
#
# General definitions so they aren't defined for each function:
#     name      : The name of the target
#     flags     : These are compile-time flags to pass to the compiler
#     includes  : The directories containing include files for the target
#     libraries : The libraries the target needs to link against
#
################################################################################

include(CTest)
enable_testing()

include(UtilityMacros)
include(DependencyMacros)
include(AssertMacros)

#Little trick so we always know this directory even when we are in a function
set(DIR_OF_TARGET_MACROS ${CMAKE_CURRENT_LIST_DIR})


function(nwchemex_set_up_target __name __flags __lflags __install)
    set(__headers_copy ${${__includes}})
    make_full_paths(__headers_copy)
    foreach(__depend ${NWX_DEPENDENCIES})
        find_dependency(${__depend} __DEPEND_INCLUDES
                                    __DEPEND_LIBRARIES
                                    __DEPEND_FLAG
                                    __DEPEND_LFLAG
                                    __${__depend}_found)
        assert(__${__depend}_found)
    endforeach()
    list(APPEND __all_flags ${__flags} ${__DEPEND_FLAG})
    list(APPEND __all_lflags ${__lflags} ${__DEPEND_LFLAG})
    list(APPEND __DEPEND_INCLUDES ${NWX_INCLUDE_DIR})
    debug_message("Adding target ${__name}:")
    debug_message("    Include Directories: ${__DEPEND_INCLUDES}")
    debug_message("    Compile Flags: ${__all_flags}")
    debug_message("    Link Libraries: ${__DEPEND_LIBRARIES}")
    debug_message("    Link Flags: ${__all_lflags}")
    target_link_libraries(${__name} PRIVATE "${__DEPEND_LIBRARIES}")
    target_compile_options(${__name} PRIVATE "${__all_flags}")
    target_include_directories(${__name} PRIVATE ${__DEPEND_INCLUDES})
    set_property(TARGET ${__name} PROPERTY CXX_STANDARD ${CMAKE_CXX_STANDARD})
    set_property(TARGET ${__name} PROPERTY LINK_FLAGS "${__all_lflags}")
    install(TARGETS ${__name} DESTINATION ${__install})
endfunction()

function(nwchemex_add_executable __name __srcs __flags __lflags)
    set(__srcs_copy ${${__srcs}})
    make_full_paths(__srcs_copy)
    add_executable(${__name} ${__srcs_copy})
    nwchemex_set_up_target(${__name}
                           "${${__flags}}"
                           "${${__lflags}}"
                           bin/${__name})
endfunction()

function(nwchemex_add_library __name __srcs __headers __flags __lflags)
    set(__srcs_copy ${${__srcs}})
    make_full_paths(__srcs_copy)
    is_valid(__srcs_copy HAS_LIBRARY)
    if(HAS_LIBRARY)
        add_library(${__name} ${__srcs_copy})
        nwchemex_set_up_target(${__name}
                "${${_flags}}"
                "${${__lflags}}"
                lib/${__name})
    endif()
    set(NWCHEMEX_LIBRARY_NAME ${__name})
    set(NWCHEMEX_LIBRARY_HEADERS ${${__headers}})
    get_filename_component(__CONFIG_FILE ${DIR_OF_TARGET_MACROS} DIRECTORY)
    configure_file("${__CONFIG_FILE}/NWChemExTargetConfig.cmake.in"
                    ${__name}Config.cmake @ONLY)
    install(FILES ${CMAKE_BINARY_DIR}/${__name}Config.cmake
            DESTINATION share/cmake/${__name})
    foreach(__header_i ${${__headers}})
        #We want to preserve structure so get directory (if it exists)
        get_filename_component(__header_i_dir ${__header_i} DIRECTORY)
        install(FILES ${__header_i}
                DESTINATION include/${__name}/${__header_i_dir})
    endforeach()
endfunction()

function(nwchemex_add_test __name __test_file)
    set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
    set(__file_copy ${__test_file})
    make_full_paths(__file_copy)
    add_executable(${__name} ${__file_copy})
    nwchemex_set_up_target(${__name} "" "" "tests")
    add_test(NAME ${__name} COMMAND ./${__name})
    #target_include_directories(${__name} PRIVATE ${NWCHEMEXBASE_INCLUDE_DIRS})
    install(FILES ${CMAKE_BINARY_DIR}/CTestTestfile.cmake DESTINATION tests)
endfunction()

function(add_cxx_unit_test __name)
    nwchemex_add_test(${__name} ${__name}.cpp)
    set_tests_properties(${__name} PROPERTIES LABELS "UnitTest")
endfunction()

function(add_cmake_macro_test __name)
    install(FILES ${__name}.cmake DESTINATION tests)
    list(GET CMAKE_MODULE_PATH 0 _stage_dir)
    set(_macro_dir "${_stage_dir}/share/cmake/NWChemExBase/macros")
    add_test(NAME ${__name}
             COMMAND ${CMAKE_COMMAND} -DCMAKE_MODULE_PATH=${_macro_dir}
                                      -P ${__name}.cmake)
    install(FILES ${CMAKE_BINARY_DIR}/CTestTestfile.cmake DESTINATION tests)
endfunction()

function(add_nwxbase_test __name)
    include(ExternalProject)
    ExternalProject_Add(${__name}
        PREFIX ${__name}
        DOWNLOAD_DIR ${__name}
        BINARY_DIR ${__name}/build
        SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/${__name}
        CMAKE_ARGS -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
                   -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
                   -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
                   -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
        BUILD_ALWAYS 1
        CMAKE_CACHE_ARGS -DCMAKE_PREFIX_PATH:LIST=${CMAKE_PREFIX_PATH}
                         -DCMAKE_MODULE_PATH:LIST=${CMAKE_MODULE_PATH}
        INSTALL_COMMAND ""
    )
    set(working_dir ${CMAKE_BINARY_DIR}/${__name}/build/test_stage/${CMAKE_INSTALL_PREFIX})
    add_test(NAME ${__name}
             COMMAND ${working_dir}/tests/${__name})
    install(FILES ${CMAKE_BINARY_DIR}/CTestTestfile.cmake DESTINATION tests)
endfunction()
