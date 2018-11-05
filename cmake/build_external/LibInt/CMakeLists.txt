#
# This file actually builds LibInt 2.5.0
#
cmake_minimum_required(VERSION ${CMAKE_VERSION})
project(LibInt LANGUAGES C CXX)
include(DependencyMacros)
include(ExternalProject)
include(UtilityMacros)

string_concat(CMAKE_CXX_FLAGS_RELEASE "" " " LIBINT_FLAGS)

if(CMAKE_POSITION_INDEPENDENT_CODE)
    set(FPIC_LIST "-fPIC")
    string_concat(FPIC_LIST "" " " LIBINT_FLAGS)
endif()

set(LIBINT_VERSION 2.5.0-beta.2)
set(LIBINT_URL https://github.com/evaleev/libint)
set(LIBINT_TAR ${LIBINT_URL}/releases/download/v${LIBINT_VERSION})
set(LIBINT_TAR ${LIBINT_TAR}/libint-${LIBINT_VERSION})
if(TEST_LIBINT)
    #Grab the small version of libint for testing purposes
    set(LIBINT_TAR ${LIBINT_TAR}-test-mpqc4.tgz)
else()
    set(LIBINT_TAR ${LIBINT_TAR}.tgz)
endif()

set(LIBINT_OPT_FLAGS -march=native)
if(CMAKE_CXX_COMPILER_ID STREQUAL "Intel")
    set(LIBINT_OPT_FLAGS -xHost)
endif()

find_dependency(Eigen3)
makify_dependency(Eigen3 LIBINT_FLAGS Eigen3_LIBRARIES)

ExternalProject_Add(LibInt_External
        URL ${LIBINT_TAR}
        CONFIGURE_COMMAND ./configure --prefix=${CMAKE_INSTALL_PREFIX}
                                      CXX=${CMAKE_CXX_COMPILER}
                                      CC=${CMAKE_C_COMPILER}
                                      CFLAGS=${LIBINT_FLAGS}
                                      CXXFLAGS=${LIBINT_FLAGS}
                                      ${LIBINT_CONFIG_OPTIONS}
                                      --with-cxx-optflags=${LIBINT_OPT_FLAGS}
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
        BUILD_IN_SOURCE 1
)
