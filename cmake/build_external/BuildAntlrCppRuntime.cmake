
ExternalProject_Add(AntlrCppRuntime_External
        URL ${PROJECT_SOURCE_DIR}/cmake/external/Antlr4CppRT.tar.gz
        CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS}
                   -DWITH_DEMO=OFF -DWITH_LIBCXX=OFF
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
)

