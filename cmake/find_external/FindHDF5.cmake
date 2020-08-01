# - Try to find HDF5 Library
#
#  To aid find_package in locating HDF5, the user may set the
#  variable HDF5_ROOT_DIR to the root of the HDF5 install
#  directory.
#
#  Once done this will define
#  HDF5_FOUND - System has HDF5
#  HDF5_INCLUDE_DIR - The HDF5 include directories
#  HDF5_LIBRARY - The library needed to use HDF5

set(HDF5_HINTS ${STAGE_DIR}${CMAKE_INSTALL_PREFIX} ${CMAKE_INSTALL_PREFIX})

find_path(HDF5_INCLUDE_DIR hdf5.h
          HINTS ${HDF5_HINTS}
          PATHS ${HDF5_ROOT_DIR}
          PATH_SUFFIXES include
          DOC "HDF5 header"          
          NO_DEFAULT_PATH
          )

find_library(HDF5_LIBRARY
             NAMES libhdf5.a hdf5 libhdf5_debug.a hdf5_debug
             HINTS ${HDF5_HINTS}
             PATHS ${HDF5_ROOT_DIR}
             PATH_SUFFIXES lib lib64 lib32             
             DOC "HDF5 Library"
             NO_DEFAULT_PATH
	  )


include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(HDF5 DEFAULT_MSG
                                  HDF5_LIBRARY
                                  HDF5_INCLUDE_DIR)


set(HDF5_LIBRARIES ${HDF5_LIBRARY})
set(HDF5_INCLUDE_DIRS ${HDF5_INCLUDE_DIR})
