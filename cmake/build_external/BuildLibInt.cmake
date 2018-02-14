#
# This file will build LibInt using a mock super-build incase Eigen3 needs to be
# built as well
#
find_or_build_dependency(Eigen3 _was_Found)

set(TEST_LIBINT FALSE)
if(${PROJECT_NAME} STREQUAL "TestBuildLibInt")
    set(TEST_LIBINT TRUE)
endif()
ExternalProject_Add(LibInt_External
        SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/LibInt
        CMAKE_ARGS ${CORE_CMAKE_OPTIONS}
                   -DSTAGE_DIR=${STAGE_DIR}
                   -DTEST_LIBINT=${TEST_LIBINT}
        BUILD_ALWAYS 1
        INSTALL_COMMAND $(MAKE) DESTDIR=${STAGE_DIR}
        CMAKE_CACHE_ARGS ${CORE_CMAKE_LISTS}
                         ${CORE_CMAKE_STRINGS}
        )
add_dependencies(LibInt_External Eigen3_External)
