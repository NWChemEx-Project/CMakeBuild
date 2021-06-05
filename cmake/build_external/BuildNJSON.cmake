set(NJSON_GIT_TAG e10a3fac8a255433146e3f06a703dc110fc3c3da)
if(ENABLE_DEV_MODE)
  set(NJSON_GIT_TAG develop)
endif()

ExternalProject_Add(NJSON_External
    GIT_REPOSITORY https://github.com/nlohmann/json.git
    GIT_TAG ${NJSON_GIT_TAG}
    UPDATE_DISCONNECTED 1    
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS} -DJSON_BuildTests=OFF
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    )

