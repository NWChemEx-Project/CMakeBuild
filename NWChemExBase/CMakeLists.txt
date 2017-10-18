cmake_minimum_required(VERSION 3.1)
project(NWChemExBase VERSION 0.0.0 LANGUAGES NONE)

file(GLOB __MACRO_FILES "${PLB_PREFIX}/cmake/macros/*.cmake")
install(FILES ${__MACRO_FILES}
        DESTINATION share/cmake/NWChemExBase/macros)
file(GLOB __BUILD_FILES "${PLB_PREFIX}/cmake/external/find_external/*.cmake")
install(FILES ${__BUILD_FILES}
        DESTINATION share/cmake/NWChemExBase/external/find_external)

configure_file("${PLB_PREFIX}/cmake/NWChemExBaseConfig.cmake.in"
               NWChemExBaseConfig.cmake @ONLY
)
install(FILES ${CMAKE_BINARY_DIR}/NWChemExBaseConfig.cmake
        DESTINATION share/cmake/NWChemExBase
)


