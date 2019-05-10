

ExternalProject_Add(CXXBLACS_External
    GIT_REPOSITORY https://github.com/wavefunction91/CXXBLACS.git
    UPDATE_DISCONNECTED 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND  ${CMAKE_COMMAND} -E copy
    <SOURCE_DIR>/cxxblacs.hpp ${STAGE_DIR}/${CMAKE_INSTALL_PREFIX}/include/cxxblacs.hpp
    INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory
                    <SOURCE_DIR>/cxxblacs ${STAGE_DIR}/${CMAKE_INSTALL_PREFIX}/include/cxxblacs

    # INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    # CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
    #                  ${CORE_CMAKE_STRINGS}
)

