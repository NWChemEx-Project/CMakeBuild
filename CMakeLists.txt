cmake_minimum_required(VERSION 3.18.0)
project(CMakeBuild VERSION 0.0.0 LANGUAGES C CXX Fortran)

include( FetchContent )
FetchContent_Declare(linalg-cmake-modules
  GIT_REPOSITORY https://github.com/ajaypanyala/linalg-cmake-modules.git
  GIT_TAG 206ae02ea5e9e53065f76231fd2a758079433dba
)

FetchContent_MakeAvailable( linalg-cmake-modules )
set(CMSB_LAM_PATH ${linalg-cmake-modules_SOURCE_DIR})

include(${CMAKE_CURRENT_LIST_DIR}/cmake/macros/BuildCMSBModule.cmake)

if(NOT DEFINED BUILD_TESTS)
    set(BUILD_TESTS OFF)
endif()
set(BUILD_METHODS OFF)

build_cmsb_module(${CMAKE_CURRENT_LIST_DIR})
