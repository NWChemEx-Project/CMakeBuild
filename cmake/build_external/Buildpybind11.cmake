bundle_cmake_args(PYBIND11_PYTHON PYTHON_INCLUDE_DIRS PYTHON_LIBRARIES)

set(PYBIND_GIT_TAG e25b1505dbca042289c4076141092cff49b0b96b)
if(ENABLE_DEV_MODE)
  set(PYBIND_GIT_TAG master)
endif()

ExternalProject_Add(pybind11_External
    GIT_REPOSITORY https://github.com/pybind/pybind11
    GIT_TAG ${PYBIND_GIT_TAG}
    CMAKE_ARGS ${DEPENDENCY_CMAKE_OPTIONS}
               ${PYBIND11_PYTHON}
               -DPYBIND11_TEST=FALSE
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
)

