Using CMakeBuild in a New Project
===================================
 Set-up Directory Structure
-----------------------------------

With CMakeBuild installed we're ready to start setting up your source tree.
Let's call the root of your tree `root`.  Owing to how CMake super builds 
work it's easiest if you have two subdirectories: one for your source and header
files, which we'll call `srcs` one for your tests, which we'll call `tests`.  
You will need a file with the name `CMakeLists.txt` in `root`, `srcs`, and 
`tests`.  Respectively these files will provide the CMake settings for your 
overall project, the building of the sources, and the testing.

Step 1 : Configure Top-Level `CMakeLists.txt`
--------------------------------------------

The top-level `CMakeLists.txt` should look something like:

```cmake
cmake_minimum_required(VERSION 3.18.0)
project(<ProjectName> VERSION 0.0.0 LANGUAGES CXX)
find_package(CMakeBuild)
if( NOT ${CMakeBuild_FOUND} )

  FetchContent_Declare(
    CMakeBuild
    GIT_REPOSITORY <CMAKEBUILD_REPO_URL>
    GIT_TAG master
  )

  FetchContent_MakeAvailable( CMakeBuild )
  set(CMSB_MACROS ${CMakeBuild_SOURCE_DIR}/cmake/macros)
endif()

set(CMSB_PROJECTS ${PROJECT_NAME})
set(${PROJECT_NAME}_DEPENDENCIES <list_of_dependencies>)
set(${PROJECT_NAME}_SRC_DIR <srcs>)
set(${PROJECT_NAME}_TEST_DIR <tests>)
build_cmsb_module(${CMAKE_CURRENT_LIST_DIR})
```

where you will need to replace:
 
-`<ProjectName>` with the name of your project 
  - `${PROJECT_NAME}` will evaluate to that value and need not be changed 
- `<list_of_dependencies>` with a list of the libraries your code requires  
  - Supported dependencies are [here](SupportedDependencies.md)),  
- `<srcs>` with the path to `srcs` relative to `root`, and
- `<tests>` with the path to `tests` relative to `root`.

Step 2: Configure `srcs/CMakeLists.txt`
---------------------------------------- 

This file should look something like:

```cmake
cmake_minimum_required(VERSION ${CMAKE_VERSION})
project(<ProjectName>-srcs VERSION ${PROJECT_VERSION} LANGUAGES CXX)
include(TargetMacros)
set(${PROJECT_NAME}_SRCS file1.cpp)
set(${PROJECT_NAME}_INCLUDES file1.hpp)
set(${PROJECT_NAME}_DEFINITIONS "-DASymbol2Define")
set(${PROJECT_NAME}_LINK_FLAGS )
cmsb_add_library(<ProjectName> ${PROJECT_NAME}_SRCS
                                 ${PROJECT_NAME}_INCLUDES
                                 ${PROJECT_NAME}_DEFINITIONS
                                 ${PROJECT_NAME}_LINK_FLAGS)
```

Strictly speaking the names of the variables are arbitrary so long as they 
match what is passed to `cmsb_add_library`.  Similarly whatever is put as
the name of the project on the second line is also arbitrary; however, whatever
replaces `<ProjectName>` in the call `cmsb_add_library` will determine the
name of the library.  Otherwise the remainder of the file should be self 
explanatory.

Step 4: Configure: `tests/CMakeLists.txt`
-----------------------------------------

This file should be something like:

```cmake
cmake_minimum_required(VERSION ${CMAKE_VERSION})
project(<ProjectName>-Test VERSION ${PROJECT_VERSION} LANGUAGES CXX)
include(TargetMacros)

add_cxx_unit_test(Test1)
add_cxx_unit_test(Test2)
```

Again the name used in the second line is arbitrary.  The important part of this
file is adding the tests.  For now we assume that the the names of the tests are
the same as the `.cpp` file they are in.  So for this example you'll need source
files: `Test1.cpp` and `Test2.cpp`, which contain the code to form executables.
