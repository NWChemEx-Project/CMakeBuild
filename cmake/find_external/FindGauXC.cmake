# - Try to find GauXC Library
#
#  To aid find_package in locating the GauXC the user may set the
#  variable GAUXC_ROOT to the root of the GauXC install
#  directory.
#
#  Once done this will define
#  GAUXC_FOUND - System has GauXC
#  GAUXC_INCLUDE_DIR - The GauXC include directories
#  GAUXC_LIBRARY - The library needed to use GauXC

set(GAUXC_HINTS ${STAGE_DIR}${CMAKE_INSTALL_PREFIX} ${CMAKE_INSTALL_PREFIX})
set(LIBGAUXC_HINTS ${SUPER_PROJECT_BINARY_DIR}/GauXC_External-prefix/src/GauXC_External-build)

message("-------------LIBGAUXC_HINTS=${LIBGAUXC_HINTS}----------")

find_path(GAUXC_INCLUDE_DIR xc.h
          HINTS ${GAUXC_HINTS}
          PATHS ${GAUXC_ROOT}
          PATH_SUFFIXES include
          NO_DEFAULT_PATH
          )

find_library(GAUXC_LIBRARY1
             NAMES libgauxc.a gauxc
             HINTS ${LIBGAUXC_HINTS}
             PATHS ${LIBGAUXC_ROOT}
             PATH_SUFFIXES src
             NO_DEFAULT_PATH
             )

find_library(GAUXC_LIBRARY2
            NAMES libexchcxx.a exchcxx
            HINTS ${GAUXC_HINTS}
            PATHS ${GAUXC_ROOT}
            PATH_SUFFIXES lib lib64 lib32
            NO_DEFAULT_PATH
)             

find_library(GAUXC_LIBRARY3
            NAMES libxc.a xc
            HINTS ${GAUXC_HINTS}
            PATHS ${GAUXC_ROOT}
            PATH_SUFFIXES lib lib64 lib32
            NO_DEFAULT_PATH
)

find_library(GAUXC_LIBRARY4
            NAMES libgg.a gg
            HINTS ${GAUXC_HINTS}
            PATHS ${GAUXC_ROOT}
            PATH_SUFFIXES lib lib64 lib32
            NO_DEFAULT_PATH
)



include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GAUXC DEFAULT_MSG
                                  GAUXC_LIBRARY1 GAUXC_LIBRARY2 
                                  GAUXC_LIBRARY3 GAUXC_LIBRARY4
                                  GAUXC_INCLUDE_DIR)

set(GAUXC_LIBRARIES ${GAUXC_LIBRARY1} ${GAUXC_LIBRARY2} ${GAUXC_LIBRARY3} ${GAUXC_LIBRARY4})
set(GAUXC_INCLUDE_DIRS ${GAUXC_INCLUDE_DIR} 
        ${SUPER_PROJECT_BINARY_DIR}/GauXC_External-prefix/src/GauXC_External/include
        ${LIBGAUXC_HINTS}/include)
