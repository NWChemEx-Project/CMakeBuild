cmake_minimum_required(VERSION 3.18.0)
project(CMakeBuild VERSION 0.0.0 LANGUAGES C CXX Fortran)

include( FetchContent )
set(LAM_GIT_TAG f6629057033a9dd31416b259f83233340106fa78)
if(ENABLE_DEV_MODE)
  set(LAM_GIT_TAG main)
endif()

FetchContent_Declare(linalg-cmake-modules
  GIT_REPOSITORY https://github.com/ajaypanyala/linalg-cmake-modules.git
  GIT_TAG ${LAM_GIT_TAG}
)

FetchContent_MakeAvailable( linalg-cmake-modules )
set(CMSB_LAM_PATH ${linalg-cmake-modules_SOURCE_DIR})

include(${CMAKE_CURRENT_LIST_DIR}/cmake/macros/BuildCMSBModule.cmake)

if(NOT DEFINED BUILD_TESTS)
    set(BUILD_TESTS OFF)
endif()
set(BUILD_METHODS OFF)

build_cmsb_module(${CMAKE_CURRENT_LIST_DIR})
