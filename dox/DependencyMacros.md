Dependency Macros
-----------------

### find_dependency

This macro attempts to find a dependency with a given name.  If it finds that
dependency it then adds that dependencies information (includes, libraries, 
*etc.*) to the variables provided.

#### Syntax

```cmake
find_dependency(depend_name include_var lib_var defs_var link_flags_var found)
```
Arguments:

- `depend_name` : The name of the dependency as CMake's `find_package` would
  need it *e.g.* MPI not mpi, Eigen3 not eigen3 or EIGEN3.
- `include_var` : The variable to append the dependeny's includes to.  It will
  not be changed if the dependency is not found.
- `lib_var` : The variable to append the dependency's  libraries to.  It will
  not be changed if the dependency is not found.  
- `defs_var` : The variable to append the dependency's  compile time 
  definitions to.  It will not be changed if the dependency is not found.
- `link_flags_var` : The variable to append the dependency's  link line flags 
  to. It willnot be changed if the dependency is not found.
- `found` : This variable will be set to true if we found the dependency and 
  false otherwise.         

#### Example

```cmake
find_dependency(Eigen3 ALL_INCLUDES ALL_LIBRARIES ALL_DEFINITIONS
                       ALL_LINK_FLAGS Eigen3_FOUND)
message(STATUS "Eigen3 found: ${Eigen3_FOUND}")
if(Eigen3_FOUND)
    message(STATUS "Eigen3 includes: ${ALL_INCLUDES}")
    message(STATUS "Eigen3 libraries: ${ALL_LIBRARIES}")
    message(STATUS "Eigen3 definitions: ${ALL_DEFINITONS}")
    message(STATUS "Eigen3 link flags: ${ALL_LINK_FLAGS}")                     
endif()                
```

Output (depends on system):

```
-- Eigen3 includes: /usr/local/include/eigen3
-- Eigen3 libraries:
-- Eigen3 definitions:
-- Eigen3 link flags:
```

### find_or_build_dependency

This macro will attempt to find a dependency, if it can not, it will instead
look for a script in `build_external` with the same name as the dependency and
run it.  The script should make an external project that builds the dependency.
Regardless of whether or not this macro finds the dependency it will create a
dummy target with the same name as the dependency and the suffix `_External`.
All targets that depend on the dependency should use the resulting target 
to specify that dependency.

#### Syntax

```cmake
find_or_build_dependency(name found)
```

Arguments:
- `name` : The name of the dependency to find.  Must be the name `find_package`
           expects.
- `found` : A variable that will be set to true if the dependency was found.   
        
#### Example

```cmake
find_or_build_dependency(Eigen3 Eigen3_FOUND)
if(Eigen3_FOUND)
    if(TARGET Eigen3_External)
        message(STATUS "Found Eigen3!!!")
    endif()    
endif()
```

Output (depends on system):
```
-- "Found Eigen3!!!"
```
