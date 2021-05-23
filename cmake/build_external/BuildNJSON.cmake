ExternalProject_Add(NJSON_External
    GIT_REPOSITORY https://github.com/nlohmann/json.git
    GIT_TAG develop
    UPDATE_DISCONNECTED 1    
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS} -DJSON_BuildTests=OFF
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    )

