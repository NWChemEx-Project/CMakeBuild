#
# In a pretty meta turn of events, this file will build this project...
#

ExternalProject_Add(CMakeBuild_External
    SOURCE_DIR ${CMSB_ROOT}/CMakeBuild
    CMAKE_ARGS -DCMSB_CMAKE=${CMSB_CMAKE}
               ${DEPENDENCY_CMAKE_OPTIONS}
    BUILD_ALWAYS 1
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    CMAKE_CACHE_ARGS ${DEPENDENCY_PATHS}
)

