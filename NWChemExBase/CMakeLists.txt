cmake_minimum_required(VERSION ${CMAKE_VERSION})
project(NWChemExBase VERSION ${PROJECT_VERSION} LANGUAGES NONE)

# We are going to abuse the include directory variable to find out the path to
# cmake directory
set(NWXBASE_CMAKE ${NWX_INCLUDE_DIR}/cmake)
install(DIRECTORY ${NWXBASE_CMAKE}/ DESTINATION share/cmake/NWChemExBase)

configure_file("${NWXBASE_CMAKE}/NWChemExBaseConfig.cmake.in"
                       NWChemExBaseConfig.cmake @ONLY
)
install(FILES ${CMAKE_BINARY_DIR}/NWChemExBaseConfig.cmake
        DESTINATION share/cmake/NWChemExBase
)
