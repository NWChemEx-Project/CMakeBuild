Extending NWChemEx Base
=======================

The purpose of this page is to provide background on how this repository works
and to provide guidance on how to extend it.

Contents
--------
1. [Preliminaries](#preliminaries)
2. [Superbuild Basics](#superbuild-basics)  
   a. [Why a Superbuild?](#why-a-superbuild)  
   b. [Anatomy of a Superbuild](#anatomy-of-a-superbuild)  
3. [Superbuild Technical Details](#superbuild-technical-details)  
   a. [Staging the Build](#staging-the-build)  
   b. [RPATHs](#rpaths)  
   c. [Target Names](#target-names)
4. [NWChemExBase Model](#nwchemexbase-model)  
   a. [Superbuild Settings](#superbuild-settings)  
   b. [Declaring Your Library](#declaring-your-library)  
   c. [Declaring Your Tests](#delcaring-your-tests)  
   d. [Known Limitations](#known-limitations)
5. [Finding Dependencies](#finding-dependencies)  
6. [Enabling Additional Dependencies](#enabling-additional-dependencies)  
   a. [Writing a FindXXX.cmake File](#writing-a-findxxxcmake-file)  
   b. [Supported Dependencies](#supported-dependencies)             

Preliminaries
-------------

You can define and print variables like:
  The rest of this page will get you acquainted with the 
NWChemExBase workflow.


NWChemExBase Model
------------------

Drawing on years of experience writing `CMakeLists.txt` files there is a lot of
boiler-plate to them.  The primary goal of NWChemExBase is to take care of this
boiler-plate for you in a customizable and robust manner.  To that end, it is
far easier to accomplish this mission if we make some basic assumptions.

Given the details in the Superbuild section we have modeled our directory 
layout after the flow of the Superbuild.  Ultimately, we assume your project 
source tree is setup like:

~~~
ProjectRoot/
├──CMakeLists.txt
├──NWChemExBase/
├──ProjectName/
|  └──CMakeLists.txt
└──ProjectName_Test/
    └──CMakeLists.txt
~~~
 
You are free to have additional folders and files, but they are not required for
the purposes of using NWChemExBase.  It should be noted that the folder 
`NWChemExBase` is a clone of the `NWChemExBase` repo (preferably as a git 
subrepo so that it can be updated as the need occurs).  Assuming you are using
git, `ProjectRoot` would be the root directory of your repo and the directory
users of your library clone.  So far as the outside world is concerned it is
your project.  Directly inside this folder are the configuration instructions 
for the superbuild (the top-level `CMakeLists.txt` and much of 
`NWChemExBase/`) as well as the recipes for the dependencies (in 
`NWChemExBase/`).  The folder `ProjectName` is, from the perspective of the 
superbuild, your project (this is why we don't name it `src/`; *i.e.* typically 
the more canonical folders like `include/`, `src/`, `share/`, *etc.* will live
inside this folder).  Realizing that tests can be thought of as a set of 
libraries or executables that depend on you library they are elevated to 
the same rank as your project (so as to also be included via the 
`ExternalProject_Add` mechanism).

:memo: `ProjectName` and `ProjectName_Test` are the default folder names 
derived from the CMake variable `PROJECT_NAME`, which you will set in the 
top-level `CMakeLists.txt`.  If you don't like these names for some reason, 
we have provided the advanced options `NWX_SRC_DIR` and `NWX_TEST_DIR` which
can be respectively set to what you decided to call your "source" and test
directories. 

:memo: CMake is really written for your directory structure to match you 
build structure.  This is largely an artifact of directory boundaries 
defining scopes.  Although it is in theory possible to lay the project out in
a different manner, doing so is an uphill battle and not particularly easy to 
automate.


### Superbuild Settings

The file `ProjectRoot/CMakeLists.txt` is the root `CMakeLists.txt` file and is
used as the entry point for CMake into your project and to tell NWChemExBase the
details of the superbuild.  It should be quite minimal, likely only including:
~~~cmake
#What version of CMake includes all your used features? Try to stick to 3.1
cmake_minimum_required(VERSION 3.1)
  
#Details about your project including:
# ProjectName : the name of your project used throughout the build.  It is case
#               sensitive
# a.b.c       : The major, minor, and patch versions of your project
project(ProjectName VERSION a.b.c LANGUAGES CXX) #Change a.b.c
  
#This line is considered input to NWChemExBase and tells it a list of external
#dependencies that your project depends on.  The name of the variable must be
#the case-sensitive project name supplied above followed by "_DEPENDS" 
#in that exact case.  The ellipses would then be replaced by a list of external
#dependencies that your project needs.  The names of which must be valid
#find_package identifiers (a list is below)
set(ProjectName_DEPENDS ...)
  
# Turn control over to NWChemExBase
add_subdirectory(NWChemExBase)
~~~

#### Declaring Your Library

The actual declaration of your library goes in 
`ProjectRoot/ProjectName/CMakeLists.txt`.  It is here you will specify the
 source files that need compiled, the headers that need installed, and any flags
 required to compile the source files.  Your library will automatically be
 linked to whatever dependencies you requested.

~~~cmake
#Set version off of top-level variable
cmake_minimum_required(VERSION ${CMAKE_VERSION})
  
#Should be same as root `CMakeLists.txt` aside from needing the "-SRC" postfix
project(ProjectName-SRC VERSION 0.0.0 LANGUAGES CXX)
  
#This will allow us to use the nwchemex_add_library command  
include(TargetMacros)

#Strictly speaking the following three variables can have whatever name you want
#as they will be passed to the nwchemex_add_library macro
  
#We create a list of all the source files (paths relative to this file)
set(ProjectName_SRCS ...)
  
#...a list of all header files that are part of the public API (*i.e.* need 
#to be installed with the library)
set(ProjectName_INCLUDES ...)
  
#...and a list of any compile flags/definitions to provide the library
set(ProjectName_DEFINITIONS ...)
  
#Finally we tell NWChemExBase to make a library ProjectName (the end name will
#be postfix-ed properly according to library type) using the specified sources,
#flags, and public API
nwchemex_add_library(ProjectName ProjectName_SRCS 
                                 ProjectName_INCLUDES
                                 ProjectName_DEFINITIONS
                                 )
~~~

### Declaring Your Tests


The file `ProjectRoot/ProjectName_Test/CMakeLists.txt` will control the tests 
for your library.  By default the `Catch` C++ testing library will be visible to
your tests.  Simply include `#include catch/catch.hpp` in your test's source
file to use it.

~~~cmake
#Set version based off top-level variable
cmake_minimum_required(VERSION ${CMAKE_VERSION})
  
#Should be same as root `CMakeLists.txt` aside from needing the "-Test" prefix
project(ProjectName-Test VERSION 0.0.0 LANGUAGES CXX)
  
#This will find your staged library (a ProjectNameConfig.cmake file was
#automatically generated for you during the build)  
find_package(ProjectName REQUIRED)
  
#Pull our testing macros into scope
include(TargetMacros)
  
#Add a test that lives in a file Test1.cpp and depends on the target ProjectName
add_cxx_unit_tests(Test1 ProjectName)
  
#Add additional tests...
~~~

At the moment we currently only have macros for adding C++ unit tests.  Other
languages and test types will be added as needed.

### Known Limitations

As you can imagine distilling a complex thing like a build down to a few
customizable options incurs some limitations.  At the moment these are:

- Can only specify one library.
  - Limitation can be avoided by nesting superbuilds for each library 
- No support for restricting the version of a found library
  - Needs fixed, will happen before a 1.0 release


Finding Dependencies
--------------------

*N.B.* in this section `<Name>` is the name of a package as passed to 
`find_package` and `<NAME>` is the name of that package in all uppercase.  

CMake provides the `find_package` function for finding dependencies.  
Unfortunately, much of how this function works relies on naming conventions.  By
convention `find_package(<Name>)` is supposed to set minimally three variables:

1. `<NAME>_FOUND`        : Set to true if the package `<Name>` was found.
                           Unfortunately CMake does not specify the state of
                           this variable in the event it is not found.
2. `<NAME>_INCLUDE_DIRS` : All paths that a user of `<Name>` will need to 
                           include (`<Name>`'s headers and its dependencies)
3. `<NAME>_LIBRARIES`    : Same as `<NAME>_INCLUDE_DIRS1 except for libraries to 
                           link against                      
Optionally a package may set:

4. `<NAME>_DEFINITIONS`  : List of definitions and flags to use while compiling
5. `<Name>_FOUND`        : `find_package` expects a variable of the same case
                           back.  Setting this is needed for it to properly use
                           the REQUIRED keyword.                                        

Of course, many packages do not adhere to these standards complicating
automation.  Currently our solution is to write `FindNWX_<Name>.cmake` files
for packages not adhering to them and to prefer our projects us the *NWX* 
versions instead of the normal ones.

Enabling Additional Dependencies
--------------------------------

It is likely inevitable that additional dependencies will occur.  When this
happens the primary responsibility of maintainers is to ensure that a dependency
can be found by `find_package`.  This can happen in two ways:

1. If the dependency uses CMake (correctly) already it will generate a 
   `XXXConfig.cmake` file (typically in install/root/share/cmake) which 
   `find_package` can use to pull the dependency in.
2. You will have to write a `FindXXX.cmake` file for it.

The first scenario is ideal and means you don't have to do any work to ensure
CMake can find the dependency (if you want your dependency to be installable in
an automated fashion you'll still have work to do though).  The second scenario
requires work on our end.

### Writing a FindXXX.cmake File

First off let's discuss capitalization as it plays a key role here.  By default
when you call `find_package(aBc)` it will look for a file `FindaBc.cmake` that 
is the case is preserved.  Barring finding that it will look for 
`aBcConfig.cmake` or `abc-config.cmake`; however, we're assuming the config 
files do not exist.  Anyways, after calling `FindaBc.cmake`, `find_package` will
determine if `aBC` was found by considering the results of the variable 
`aBC_FOUND` (note the case always matches the case given to `find_package`). 
Lastly, making matters worse, it is convention to always return variables 
(aside from the `aBc_FOUND` variable) in all uppercase letters (it's a good idea
to return `aBc_FOUND` both in the native case and in all caps).

Case caveats aside, let's say we want to do this in a textbook manner, then the 
resulting `FindaBc.cmake` file should look something like:

~~~cmake
#File FindaBc.cmake
#
# By convention this file will set the following:
#
# aBc_FOUND        to true if all parts of the aBc package are found
# ABC_INCLUDE_DIR  to the path for includes part of aBc's public API
# ABC_LIBRARY      to the libraries included with aBc
# ABC_INCLUDE_DIRS will be the includes of aBc as well as any dependency it
#                  needs
# ABC_LIBRARIES    will be the libraries of aBc and all its dependencies
# ABC_DEFINITIONS  will be any compile-time flags to use in your project
                   
  
#Call find_package for each dependency
find_package(Depend1)
  
#Try to piggy-back of package-config 
find_package(PkgConfig)
pkg_check_modules(PC_ABC <libname_without_suffix>)
  
#For each header file in the public API try to find it
find_path(ABC_INCLUDE_DIR <path/you/put/in/cxx/source/file>
          HINTS ${PC_ABC_INCLUDEDIR} ${PC_ABC_INCLUDE_DIRS}
)
  
#For each library try to find it
find_path(ABC_LIBRARY <library/name/including/the/lib/and/the/extension>)
          HINTS ${PC_ABC_LIBDIR} ${PC_ABC_LIBRARY_DIRS}
)
  
#Let CMake see see if the found values are sufficient
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(aBc DEFAULT_MSG ABC_INCLUDE_DIR ABC_LIBRARY)
  
#In examples you'll see a marked_as_advanced line here a lot, but it's pretty
#useless as barely anyone runs the cmake GUI...
  
#Add dependencies and aBc's includes to ABC_INCLUDE_DIRS
set(ABC_INCLUDE_DIRS ${ABC_INCLUDE_DIR} ...)
  
#Same for libraries to link to
set(ABC_LIBRARIES ${ABC_LIBRARY} ...)
  
#Set the flags needed to compile against aBc
set(ABC_DEFINITIONS ...)
~~~
Once written your file goes in `NWChemBase/cmake/external_find/FindaBc.cmake`

### Enabling NWChemExBase to Build a Dependency

In an effort to make the build process more user-friendly it is common to want
to build dependencies for the user.  That is, if we are unable to locate a
required dependency on the system, we instead build it.  CMake doesn't have a
particular convention for how this done so we have taken the liberty of defining
a process for you.  We assume the following is in 
`NWChemExBase/cmake/external_build/BuildXXX.cmake`.

~~~cmake
#include(ExternalProject) and include(DependancyMacros) are already sourced

ExternalProject_Add(XXX_External #Target name = file name plus _External suffix
  <Rest of settings> 
)

#For each dependency flag it as one
foreach(__depend <list of dependencies>)
    find_or_build_dependency(${__depend})
    #The external target was made for you by find_or_build_dependency
    set_dependencies(XXX_External ${__depend}_External)
endforeach()    
~~~


