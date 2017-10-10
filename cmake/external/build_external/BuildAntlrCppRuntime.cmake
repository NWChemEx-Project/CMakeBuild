

include(ExternalProject)
find_package(AntlrCppRuntime)

if (ANTLRCPPRUNTIME_FOUND)
    add_library(antlr_cpp_runtime_nwx INTERFACE)
else()
    set(ANTLRCPPRUNTIME_ROOT_DIR ${CMAKE_INSTALL_PREFIX}/AntlrCppRuntime)
    message(STATUS "Building ANTLR4 CPP Runtime library at: ${ANTLRCPPRUNTIME_ROOT_DIR}")

    # Build the ANTLR Cpp Runtime library.
    include(ExternalProject)
    ExternalProject_Add(antlr_cpp_runtime_nwx
        URL http://www.antlr.org/download/antlr4-cpp-runtime-4.7-source.zip
        # TODO:Provide correct patch file path relative to NWChemExBase directory
        PATCH_COMMAND patch < ${PROJECT_SOURCE_DIR}/../cmake/external/patches/antlr_cmakelists.patch
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
        -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}  -DWITH_DEMO=OFF
        -DCMAKE_INSTALL_PREFIX=${ANTLRCPPRUNTIME_ROOT_DIR}
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install
    )
endif()

