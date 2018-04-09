################################################################################
#
# These are macros for finding dependencies.
#
################################################################################

include(DebuggingMacros)
include(UtilityMacros)
include(AssertMacros)

function(package_dependency __depend __lists)
    string(TOUPPER ${__depend} __DEPEND)
    get_property(${__DEPEND}_INCLUDE_DIRS TARGET ${__depend}_External
            PROPERTY INTERFACE_INCLUDE_DIRECTORIES)
    get_property(${__DEPEND}_LIBRARIES TARGET ${__depend}_External
            PROPERTY INTERFACE_LINK_LIBRARIES)
    bundle_cmake_list(${__lists} ${__DEPEND}_INCLUDE_DIRS
            ${__DEPEND}_LIBRARIES)
    set(${__lists} ${${__lists}} PARENT_SCOPE)
endfunction()

function(are_we_building __name __value)
    if(NOT TARGET ${__name}_External)
        set(${__value} TRUE PARENT_SCOPE)
    else()
        package_dependency(${__name} __temp)
        is_valid(__temp ${__value})
        if(${__value})
            set(${__value} FALSE PARENT_SCOPE)
        else()
            set(${__value} TRUE PARENT_SCOPE)
        endif()
    endif()
endfunction()

function(print_dependency __name)
    message("Target: ${__name}")
    foreach(prefix "INTERFACE_")
        foreach(_prop INCLUDE_DIRECTORIES LINK_LIBRARIES COMPILE_DEFINITIONS
                LINK_FLAGS)
            get_property(__value TARGET ${__name} PROPERTY ${prefix}${_prop})
            is_valid(__value __has_prop)
            if(__has_prop)
                message("  ${_prop} : ${__value}")
                if(prefix STREQUAL "INTERFACE_")
                    set(is_interface TRUE)
                endif()
            endif()
        endforeach()
        if(is_interface)
            break()
        endif()
    endforeach()
endfunction()

function(find_dependency __name)
    if(TARGET ${__name}_External)
        debug_message("${__name} already handled.")
    else()
        #This will be messy for packages relying on Config files if we haven't
        #built them yet
        is_valid_and_true(BUILD_${__name} __dont_look_for)
        if(__dont_look_for)
            message(STATUS "Per user's request building bundled ${__name}")
        elseif(NWX_DEBUG_CMAKE)
            find_package(${__name})
        else()
            find_package(${__name} QUIET)
        endif()
        string(TOUPPER ${__name} __NAME)
        is_valid_and_true(${__NAME}_FOUND _upper)
        is_valid_and_true(${__name}_FOUND _lower)
        if(_upper OR _lower)
            set(_tname ${__name}_External)
            add_library(${_tname} INTERFACE)
            is_valid(${__NAME}_INCLUDE_DIRS __has_includes)
            if(__has_includes)
                target_include_directories(${_tname} INTERFACE
                        ${${__NAME}_INCLUDE_DIRS})
            endif()

            is_valid(${__NAME}_LIBRARIES __has_libs)
            if(__has_libs)
                target_link_libraries(${_tname} INTERFACE
                        ${${__NAME}_LIBRARIES})
            endif()

            is_valid(${__NAME}_DEFINITIONS __has_defs)
            if(__has_defs)
                target_compile_defintions(${_tname} INTERFACE ${__NAME}_DEFINITIONS)
            endif()

            is_valid(${__NAME}_LINK_FLAGS __has_lflags)
            if(__has_lflags)
                target_link_flags(${_tname} INTERFACE ${__NAME}_LINK_FLAGS)
            endif()

            if(NWX_DEBUG_CMAKE)
                print_dependency(${_tname})
            endif()
        endif()
    endif()
endfunction()

function(find_or_build_dependency __name)
        find_dependency(${__name})
        are_we_building(${__name} __are_building)
        if(__are_building)
            is_valid(BUILD_${__name} __is_set)
            if(__is_set AND NOT BUILD_${__name})
                message(FATAL_ERROR "Could not locate ${__name} and user has "
                        "requested we do not build one.")
            endif()
            debug_message("Unable to locate ${__name}.  Building one instead.")
            include(Build${__name})
        endif()
endfunction()

function(makify_dependency __depend __incs __libs)
    string(TOUPPER ${__depend} __DEPEND)
    get_property(${__DEPEND}_INCLUDE_DIRS TARGET ${__depend}_External
            PROPERTY INTERFACE_INCLUDE_DIRECTORIES)
    string_concat(${__DEPEND}_INCLUDE_DIRS "-I" " " ${__incs})
    get_property(${__DEPEND}_LIBRARIES TARGET ${__depend}_External
            PROPERTY INTERFACE_LINK_LIBRARIES)
    foreach(__lib ${${__DEPEND}_LIBRARIES})
        # Remove the actual library from the path
        get_filename_component(_lib_path ${__lib} DIRECTORY)
        # Get only library name with extension
        get_filename_component(_name_lib ${__lib} NAME_WE)
        # Strip the lib prefix
        string(SUBSTRING ${_name_lib} 3 -1 _name_lib)
        set(${__libs} "${${__libs}} -L${_lib_path} -l${_name_lib}")
    endforeach()
    set(${__incs} ${${__incs}} PARENT_SCOPE)
    set(${__libs} ${${__libs}} PARENT_SCOPE)
endfunction()


