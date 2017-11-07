set(LIBINT_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
set(LIBINT_TAR https://github.com/evaleev/libint/releases/download/)
set(LIBINT_TAR ${LIBINT_TAR}v2.4.0-beta.4/libint-2.4.0-beta.4.tgz)

find_or_build_dependency(Eigen3)
ExternalProject_Add(LibInt_External
    URL ${LIBINT_TAR}
    CONFIGURE_COMMAND ./configure --prefix=${CMAKE_INSTALL_PREFIX}
        CXX=${CMAKE_CXX_COMPILER}
        CC=${CMAKE_C_COMPILER}
        CXXFLAGS=${LIBINT_FLAGS}
        ${LIBINT_CONFIG_OPTIONS}
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    BUILD_IN_SOURCE 1
)
add_dependencies(LibInt_External Eigen3_External)
