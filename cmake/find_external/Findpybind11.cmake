#
# Pybind11's CMake config file doesn't adhere to the standards of other files so
# this wrapper file will fix that for us
#

find_package(pybind11 CONFIG)
is_valid_and_true(pybind11_FOUND found_py11)
if(found_py11)
    message("Looking for pybind11")
    get_property(py_lib TARGET pybind11::embed PROPERTY INTERFACE_LINK_LIBRARIES)
    set(PYBIND11_LIBRARIES ${py_lib})
    set(PYBIND11_INCLUDE_DIRS ${pybind11_INCLUDE_DIRS})
endif()
