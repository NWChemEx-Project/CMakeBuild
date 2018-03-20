

ExternalProject_Add(TALSH_External
    GIT_REPOSITORY https://github.com/DmitryLyakh/TAL_SH.git
    GIT_TAG cmake
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS}
    -DTALSH_GPU=ON 
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                     ${CORE_CMAKE_STRINGS}
)

