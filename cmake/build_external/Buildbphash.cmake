ExternalProject_Add(bphash_External
    GIT_REPOSITORY https://github.com/bennybp/BPHash
    GIT_TAG 0a22d5e7ddac23beeb868dbb5e8def3ac6226338
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS}
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
)

