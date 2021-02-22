ExternalProject_Add(cereal_External
    GIT_REPOSITORY https://github.com/USCiLab/cereal
    GIT_TAG 64f50dbd5cecdaba785217e2b0aeea3a4f1cdfab
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS}
               -DSKIP_PORTABILITY_TEST=TRUE
               -DJUST_INSTALL_CEREAL=TRUE
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
)

