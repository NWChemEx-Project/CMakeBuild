cmake_minimum_required(VERSION ${CMAKE_VERSION})
project(CMakeBuild VERSION ${PROJECT_VERSION} LANGUAGES NONE)

# We are going to abuse the include directory variable to find out the path to
# cmake directory
set(CMSB_CMAKE ${CMSB_INCLUDE_DIR}/cmake)
set(CMSB_MACROS ${CMSB_CMAKE}/macros)
set(MACRO_INSTALL share/cmake/CMakeBuild/macros)

file(GLOB __MACRO_FILES "${CMSB_MACROS}/*.cmake")
install(FILES ${__MACRO_FILES}  DESTINATION ${MACRO_INSTALL})

install(DIRECTORY ${CMSB_CMAKE}/build_external/
        DESTINATION share/cmake/CMakeBuild/build_external)

install(DIRECTORY ${CMSB_CMAKE}/find_external/
        DESTINATION share/cmake/CMakeBuild/find_external)

configure_file("${CMSB_CMAKE}/CMakeBuildConfig.cmake.in"
               CMakeBuildConfig.cmake @ONLY
)
install(FILES ${CMAKE_BINARY_DIR}/CMakeBuildConfig.cmake
        DESTINATION share/cmake/CMakeBuild
)

configure_file(
        "${CMSB_CMAKE}/cmake_uninstall.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
        IMMEDIATE @ONLY)

install(FILES ${CMSB_CMAKE}/CMSBTargetConfig.cmake.in
        ${CMSB_CMAKE}/cmake_uninstall.cmake.in
        DESTINATION share/cmake/CMakeBuild)

add_custom_target(uninstall
        COMMAND ${CMAKE_COMMAND} -P
        ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)

