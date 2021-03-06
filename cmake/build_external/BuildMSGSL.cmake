
set(MSGSL_GIT_TAG b26f6d5ec7b043f9d459c1dfdd6da4d930d4e9b4)
if(ENABLE_DEV_MODE)
  set(MSGSL_GIT_TAG main)
endif()

ExternalProject_Add(MSGSL_External
    GIT_REPOSITORY https://github.com/Microsoft/GSL.git
    GIT_TAG ${MSGSL_GIT_TAG}
    UPDATE_DISCONNECTED 1
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS} -DGSL_TEST=OFF
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                     ${CORE_CMAKE_STRINGS}
)

