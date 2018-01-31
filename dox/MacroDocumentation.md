NWChemExBase Macro Documentation
================================

Certain tasks are done so often (or are so easy to mess-up) in NWChemExBase that
we have created macros/functions for them (the difference between a macro and a
function in CMake is that functions establish new scope).  Normally such 
documentation would be contained in the comments of the macros and then 
compiled into nice pretty documents by something like Doxygen, but I'm unaware 
of any such tool for CMake scripts (probably because who writes a manual for 
their build system? Answer: this guy (points to self)).  Anyways, I've written
the documentation manually on this page (this is also the reason you don't 
see it in the macro definitions).

Contents
--------

1. [build_nwchemex_module.cmake](#build_nwchemex_module)  
1. [Dependency Macros](#dependency-macros)  
   a. [find_dependency](#find-dependency)  
   b. [find_or_build_dependency](#find_or_build_dependency)  
2. [Utility Macros](#utility-macros)  
   a. [prefix_paths](#prefix_paths)    
   b. [make_full_paths](#make_full_paths)  
   c. [clean_flags](#clean_flags)  
   d. [is_valid](#is_valid)  
   e. [is_valid_and_true](#is_valid_and_true)  
   f. [print_banner](#print_banner)

BuildNWChemExModule
----------------------

### build_nwchemex_module

This is the main entry point into the NWChemExBase CMake infrastructure.

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

Utility Macros
--------------

These are macros/functions which provide quality of life improvements, but are
(at the moment) not related to the other categories of macros/functions.  All
macros in this section can be utilized by including the line 
`include(UtilityMacros)` in your current CMake file.

### prefix_paths

Given a CMake list, whose elements are assumed to be paths to files, this macro
will apply the requested prefix to all of the files.

#### Syntax
 
```cmake
prefix_paths(PREFIX LIST_VARIABLE)
```

Arguments:
- `PREFIX`        : the actual prefix to append to each file
- `LIST_VARIABLE` : a variable containing a list of files

#### Example

```cmake
set(A_LIST_OF_FILES my_file1.h my_file2.h my_file3.h)
prefix_paths(a/prefix A_LIST_OF_FILES)
foreach(file ${A_LIST_OF_FILES})
    message(STATUS "${file}")
endforeach()
```  

Output:

```
-- a/prefix/my_file1.h
-- a/prefix/my_file2.h
-- a/prefix/my_file3.h
```
 
### make_full_paths
 
Given a CMake list, whose elements are assumed to be relative paths to files
(relative to directory from which this function was invoked), this function 
will overwrite the paths in the list with their full paths.
 
#### Syntax

```cmake
make_full_paths(LIST_VARIABLE)
```
 
Arguments:
 
- `LIST_VARIABLE` : a variable whose contents is a CMake list of files.

#### Example

```cmake
set(LIST_OF_FILES file1.h file2.cpp)
make_full_paths(LIST_OF_FILES)
foreach(file ${LIST_OF_FILES})
    message(STATUS "${file}")
endforeach()
```

Theoretical output (full paths obviously depend on file location and the 
filesystem):

```
-- /full/path/to/file1.h
-- /full/path/to/file2.h
```

### clean_flags

In CMake the natural way to accumulate compile/link flags is in a list.  
Unfortunately, when you print a CMake list it prints as a string with the 
elements separated by semi-colons.  In turn, simply trying to set the flags of a
target to the contents of th list messes up the compile/link command (the 
semi-colon will terminate the compile/link command).  At the moment, this 
function will replace the semi-colons in the string with spaces.  This 
command will also remove duplicate flags as well, to make the commands 
easier to read.

At the moment this command will remove all duplicates.  I presume there
are some flags that we don't want to remove if they are duplicates, but I can't
think of them off the top of my head.  Note that `-I/path/to/folder` and 
`-I/path/to/other/folder` are treated as different "flags" despite both being
 invocations of the `-I` flag. 

#### Syntax

```cmake
clean_flags(LIST_VARIABLE STRING_VARIABLE)
``` 

Arguments:
- `LIST_VARIABLE` : A variable containing the list of flags we'd like to clean
- `STRING_VARIABLE` : A variable containing the cleaned list of flags

#### Example

```cmake
set(CMAKE_CXX_FLAGS "-O3")
list(APPEND CMAKE_CXX_FLAGS "-fPIC" "-O3")
message(STATUS "Before: ${CMAKE_CXX_FLAGS}")
clean_flags(CMAKE_CXX_FLAGS CLEAN_FLAGS)
message(STATUS "After: ${CLEAN_FLAGS}")
``` 

Output:

```
-- Before: -O3;-fPIC;-O3
-- After: -O3 -fPIC
```

### is_valid 

Checking if a variable is valid (defined and not empty) in CMake is annoying 
and error-prone.  This function does it for you.

#### Syntax
 
```cmake
is_valid(VARIABLE_TO_CHECK OUTPUT_BOOL)
```

Arguments:
- `VARIABLE_TO_CHECK` : The variable which you would like checked
- `OUTPUT_BOOL` : A variable that after the call will contain `TRUE` if 
                  `VARIABLE_TO_CHECK` is valid and `FALSE` otherwise
                  
#### Example

```cmake
#Example check on a variable that is not defined
is_valid(SOME_MADE_UP_VARIABLE CHECK1)
message(STATUS "Check1: ${CHECK1}")

#Example check on a set but empty variable
set(A_SET_VARIABLE)
is_valid(A_SET_VARIABLE CHECK2)
message(STATUS "Check2: ${CHECK2}")

#Example check on a set and defined variable
set(IS_FALSE FALSE)
is_valid(IS_FALSE CHECK3)
message(STATUS "Check3: ${CHECK3}")
```

Output:

```
-- Check1: FALSE
-- Check2: FALSE
-- Check3: TRUE
```

### is_valid_and_true 

Related to `is_valid`, this variable will check if a variable is set and that
the value of that variable is true.  CMake defines a variable as true if it is
set to: 
- Any integer greater than or equal to 1
- `ON`
- `YES`
- `TRUE`
- `Y`

#### Syntax
 
```cmake
is_valid_and_true(VARIABLE_TO_CHECK OUTPUT_BOOL)
```

Arguments:
- `VARIABLE_TO_CHECK` : The variable which you would like checked
- `OUTPUT_BOOL` : A variable that after the call will contain `TRUE` if 
                  `VARIABLE_TO_CHECK` is valid and evaluates to one of 
                  CMake's recognized true values and `FALSE` otherwise
                  
#### Example

```cmake
#Example check on a variable that is not defined
is_valid_and_true(SOME_MADE_UP_VARIABLE CHECK1)
message(STATUS "Check1: ${CHECK1}")

#Example check on a set but empty variable
set(A_SET_VARIABLE)
is_valid_and_true(A_SET_VARIABLE CHECK2)
message(STATUS "Check2: ${CHECK2}")

#Example check on a set and defined false variable
set(IS_FALSE FALSE)
is_valid_and_true(IS_FALSE CHECK3)
message(STATUS "Check3: ${CHECK3}")

#Example check on a set and defined true variable
set(IS_TRUE TRUE)
is_valid_and_true(IS_TRUE CHECK4)
message(STATUS "Check4: ${CHECK4}")
```

Output:

```
-- Check1: FALSE
-- Check2: FALSE
-- Check3: FALSE
-- Check4: TRUE
```

### print_banner

This is a macro to print a pretty 80 column wide banner in the CMake log.

#### Syntax

```cmake
print_banner(MESSAGE)
```

Arguments:
- `MESSAGE` the message to print in the banner.  Must be 78 characters or less.

#### Example

```cmake
print_banner("Test Banner")
```

Output:
```
********************************************************************************
*                                 Test Banner                                  *
********************************************************************************
```
