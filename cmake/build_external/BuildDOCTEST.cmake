ExternalProject_Add(DOCTEST_External
    URL https://github.com/onqtam/doctest/archive/refs/tags/2.4.6.tar.gz  
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS} -DDOCTEST_WITH_TESTS=OFF
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    )

