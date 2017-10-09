
include(ExternalProject)
find_package(Libint)

if(NOT NWX_PROC_COUNT)
    set(NWX_PROC_COUNT 2)
endif()

if (LIBINT2_FOUND)
    add_library(libint_nwx INTERFACE)
else()
    set (LIBINT_INSTALL_PATH ${CMAKE_INSTALL_PREFIX}/libint2)
    message(STATUS "Building Libint at: ${LIBINT_INSTALL_PATH}")
    set(LIBINT_PREFIX ${PROJECT_BINARY_DIR}/external/libint)
    set(LIBINT_FLAGS ${CMAKE_CXX_FLAGS} -fPIC)
    
    ExternalProject_Add(libint_nwx
        URL https://github.com/evaleev/libint/releases/download/v2.3.1/libint-2.3.1.tgz
        SOURCE_DIR ${LIBINT_PREFIX}
        CONFIGURE_COMMAND ./configure
                --prefix=${LIBINT_INSTALL_PATH}
        CXX=${CMAKE_CXX_COMPILER}
                CC=${CMAKE_C_COMPILER}
                CXXFLAGS=${LIBINT_FLAGS}
        BUILD_COMMAND ${CMAKE_MAKE_PROGRAM} -j${NWX_PROC_COUNT}
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install
        BUILD_IN_SOURCE 1
        #LOG_CONFIGURE 1
        #LOG_BUILD 1
    )
endif()


