#
# This file actually builds LibInt 3.8.0
#
cmake_minimum_required(VERSION ${CMAKE_VERSION})
project(LibInt VERSION 2.4.2 LANGUAGES C CXX)
include(DependencyMacros)
include(ExternalProject)
include(UtilityMacros)

string_concat(CMAKE_CXX_FLAGS "" " " LIBINT_FLAGS)

if(CMAKE_POSITION_INDEPENDENT_CODE)
    set(FPIC_LIST "-fPIC")
    string_concat(FPIC_LIST "" " " LIBINT_FLAGS)
endif()

set(LIBINT_URL https://github.com/evaleev/libint)
set(LIBINT_TAR ${LIBINT_URL}/releases/download/v${PROJECT_VERSION}/)
set(LIBINT_TAR ${LIBINT_TAR}/libint-${PROJECT_VERSION})
if(TEST_LIBINT)
    #Grab the small version of libint for testing purposes
    set(LIBINT_TAR ${LIBINT_TAR}-test-mpqc4.tgz)
else()
    set(LIBINT_TAR ${LIBINT_TAR}.tgz)
endif()

find_dependency(Eigen3 _EIGEN3_INCLUDE_DIRS
                       _EIGEN3_LIBRARIES
                       _EIGEN3_DEFINITIONS
                       _EIGEN3_LINK_FLAGS
                       _EIGEN3_FOUND)
find_or_build_dependency(Eigen3 was_found)

makify_includes(_EIGEN3_INCLUDE_DIRS LIBINT_FLAGS)
ExternalProject_Add(LibInt_External
        URL ${LIBINT_TAR}
        CONFIGURE_COMMAND ./configure --prefix=${CMAKE_INSTALL_PREFIX}
                                      CXX=${CMAKE_CXX_COMPILER}
                                      CC=${CMAKE_C_COMPILER}
                                      CFLAGS=${LIBINT_FLAGS}
                                      CXXFLAGS=${LIBINT_FLAGS}
                                      ${LIBINT_CONFIG_OPTIONS}
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
        BUILD_IN_SOURCE 1
)
