#
# In a pretty meta turn of events, this file will build this project...
#

find_or_build_dependency(NWX_Catch was_found)

ExternalProject_Add(CMakeBuild_External
    SOURCE_DIR ${NWXBASE_ROOT}/CMakeBuild
    CMAKE_ARGS -DNWXBASE_CMAKE=${NWXBASE_CMAKE}
               ${DEPENDENCY_CMAKE_OPTIONS}
    BUILD_ALWAYS 1
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
)

add_dependencies(CMakeBuild_External NWX_Catch_External)