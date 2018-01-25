################################################################################
#
# These are macros for finding dependencies.
#
################################################################################

include(DebuggingMacros)
include(UtilityMacros)
include(AssertMacros)

function(find_dependency __name _include_dirs _libraries _definitions
                                _link_flags _found)
    #This will be messy for packages relying on Config files if we haven't built
    #them yet
    is_valid_and_true(BUILD_${__name} __dont_look_for)
    if(__dont_look_for)
        message(STATUS "Per user's request building bundled ${__name}")
    elseif(NWX_DEBUG_CMAKE)
        find_package(${__name})
    else()
        find_package(${__name} QUIET)
    endif()
    string(TOUPPER ${__name} __NAME)
    if(${__name}_FOUND OR ${__NAME}_FOUND)
        debug_message("Found ${__name}:")
        foreach(__VAR_TYPE _INCLUDE_DIRS _LIBRARIES _DEFINITIONS _LINK_FLAGS)
            string(TOLOWER ${__VAR_TYPE} __var_type)
            set(__var ${__NAME}${__VAR_TYPE})
            set(__parent_var ${${__var_type}})
            is_valid(${__var} has_var)
            if(has_var)
                debug_message("    ${__var}: ${${__var}}")
                list(APPEND ${__parent_var} ${${__var}})
                set(${__parent_var} ${${__parent_var}} PARENT_SCOPE)
            endif()
        endforeach()
        set(${_found} TRUE PARENT_SCOPE)
    else()
        set(${_found} FALSE PARENT_SCOPE)
    endif()
endfunction()


function(find_or_build_dependency __name __was_found)
    if(TARGET ${__name}_External)
        debug_message("${__name} already handled.")
    else()
        find_dependency(${__name} _inc _lib _defs _flags ${__was_found})
        if(${__was_found})
            add_library(${__name}_External INTERFACE)
        else()
            is_valid(BUILD_${__name} __is_set)
            if(__is_set AND NOT BUILD_${__name})
                message(FATAL_ERROR "Could not locate ${__name} and user has "
                        "requested we do not build one.")
            endif()
            debug_message("Unable to locate ${__name}.  Building one instead.")
            include(Build${__name})
        endif()
        set(${__was_found} ${${__was_found}} PARENT_SCOPE)
    endif()
endfunction()


