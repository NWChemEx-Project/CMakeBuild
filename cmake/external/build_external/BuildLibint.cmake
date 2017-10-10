
include(ExternalProject)
find_package(Libint)

if (LIBINT_FOUND)
    add_library(libint_nwx INTERFACE)
else()
    set (LIBINT_ROOT_DIR ${CMAKE_INSTALL_PREFIX}/libint)
    message(STATUS "Building Libint at: ${LIBINT_ROOT_DIR}")
    set(LIBINT_FLAGS ${CMAKE_CXX_FLAGS} -fPIC)
    
    ExternalProject_Add(libint_nwx
        URL https://github.com/evaleev/libint/releases/download/v2.3.1/libint-2.3.1.tgz
        CONFIGURE_COMMAND ./configure
                --prefix=${LIBINT_ROOT_DIR}
        CXX=${CMAKE_CXX_COMPILER}
                CC=${CMAKE_C_COMPILER}
                CXXFLAGS=${LIBINT_FLAGS}
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install
        BUILD_IN_SOURCE 1
        #LOG_CONFIGURE 1
        #LOG_BUILD 1
    )
endif()


