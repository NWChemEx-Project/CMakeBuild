

include(ExternalProject)
find_package(AntlrCppRuntime)

if(NOT NWX_PROC_COUNT)
    set(NWX_PROC_COUNT 2)
endif()

if (ANTLR_CPP_RUNTIME_FOUND)
    add_library(antlr_cpp_runtime_nwx INTERFACE)
else()
    set (ANTLR_CPPRUNTIME_PATH ${CMAKE_INSTALL_PREFIX}/AntlrCppRuntime)
    message(STATUS "Building ANTLR4 CPP Runtime library at: ${ANTLR_CPPRUNTIME_PATH}")
    set(ANTLR_CPPRUNTIME_PREFIX ${PROJECT_BINARY_DIR}/external/AntlrCppRuntime)

    # Build the ANTLR Cpp Runtime library.
    include(ExternalProject)
    ExternalProject_Add(antlr_cpp_runtime_nwx
        URL http://www.antlr.org/download/antlr4-cpp-runtime-4.7-source.zip
        SOURCE_DIR ${ANTLR_CPPRUNTIME_PREFIX}
        UPDATE_COMMAND mkdir -p "${ANTLR_CPPRUNTIME_PREFIX}/build"
        BINARY_DIR ${ANTLR_CPPRUNTIME_PREFIX}/build
        # TODO:Provide correct patch file path relative to NWChemExBase directory
        PATCH_COMMAND patch < ${PROJECT_SOURCE_DIR}/../cmake/external/patches/antlr_cmakelists.patch
        CMAKE_ARGS -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
        -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}  -DWITH_DEMO=OFF
        -DCMAKE_INSTALL_PREFIX=${ANTLR_CPPRUNTIME_PATH}
        BUILD_COMMAND ${CMAKE_MAKE_PROGRAM} -j${NWX_PROC_COUNT}
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install
    )
endif()

