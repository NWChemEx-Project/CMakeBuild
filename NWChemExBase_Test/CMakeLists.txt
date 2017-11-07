cmake_minimum_required(VERSION 3.1)
project(NWChemExBase-TEST VERSION 0.0.0 LANGUAGES CXX)
include(CTest)
enable_testing()

foreach(_test_name BuildLibInt) #BuildEigen3 SimpleRepo BuildLibInt)
    add_test(NAME    ${_test_name}
             COMMAND ${CMAKE_BINARY_DIR}/RunNWChemExBaseTest.sh
                     ${_test_name}
                     ${CMAKE_COMMAND}
            )
    file(COPY ${_test_name}_files DESTINATION ${CMAKE_BINARY_DIR})
endforeach()

file(COPY RunNWChemExBaseTest.sh
     DESTINATION ${CMAKE_BINARY_DIR})
