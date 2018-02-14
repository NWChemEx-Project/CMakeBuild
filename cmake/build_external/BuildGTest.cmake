ExternalProject_Add(GTest${TARGET_SUFFIX}
    URL https://github.com/google/googletest/archive/release-1.8.0.tar.gz
    CMAKE_ARGS ${CORE_CMAKE_OPTIONS}
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
)

