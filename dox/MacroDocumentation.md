CMakeBuild Macro Documentation
================================

Certain tasks are done so often (or are so easy to mess-up) in CMakeBuild that
we have created macros/functions for them (the difference between a macro and a
function in CMake is that functions establish new scope and should be 
preferred to avoid contaminating the global scope).

Below you will find a list of the major categories of macros, along with a 
list of the functions contained within that category.  Richer documentation for 
each macro including:
- a detailed description 
- the syntax of the macro 
  - descriptions of the arguments
  - list of CMake cache variables (*i.e.* variables read from CMake's cache) 
- an example usage
can be found by following the links

1. [BuildCMSBModule](BuildCMSBModule.md)  
   a. `build_cmsb_module` main call to CMakeBuild  
1. [Dependency Macros](DependencyMacros.md)    
   a. `cmsb_find_dependency` wraps CMake's `find_package` to use our environment
   b. `find_or_build_dependency` wraps `cmsb_find_dependency` to build dependency if
      it's not found   
2. [TargetMacros](TargetMacros.md)  
   a. `cmsb_setup_target` ensures a target's paths and dependencies are set
      up right.  
   b. `cmsb_add_executable` wraps `cmsb_setup_target` so that it makes
      an executable
   c. `cmsb_add_library` wraps `cmsb_setup_target` so that it builds a
      library 
   d. `cmsb_add_test` guts for adding a test to the build
   e. `add_cxx_unit_test` wraps `cmsb_add_test` to build an 
   executable that is used for unit testing.
   f. `add_cmake_macro_test` used internally for testing macros
   g. `add_cmsb_test` used internally to test results of building with
       CMakeBuild
2. [Utility Macros](UtiltityMacros.md)    
   a. `prefix_paths` applies a prefix to a group of paths   
   b. `make_full_paths` wraps `prefix_paths` so prefix is path to root
   c. `clean_flags` removes duplicate compile flags, ... from a list of flags
   d. `is_valid` checks if a variable is valid (defined and set)
   e. `is_valid_and_true` wraps `is_valid` and also checks variable for true
   f. `print_banner` writes a message to the log inside a pretty banner
   g. `string_concat` takes a list of things and makes them into one long string
   h. `makify_includes` puts "-I" in front of a list of folders


`

