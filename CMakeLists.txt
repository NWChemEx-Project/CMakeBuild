cmake_minimum_required(VERSION 3.18.0)
project(CMakeBuild VERSION 0.0.0 LANGUAGES C CXX Fortran)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/macros/BuildCMSBModule.cmake)

if(NOT DEFINED BUILD_TESTS)
    set(BUILD_TESTS OFF)
endif()
set(BUILD_METHODS OFF)

build_cmsb_module(${CMAKE_CURRENT_LIST_DIR})
