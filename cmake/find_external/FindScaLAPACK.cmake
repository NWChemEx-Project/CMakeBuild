# Find ScaLAPACK
#
#  Once done this will define
#  ScaLAPACK_FOUND - System has ScaLAPACK
#  ScaLAPACK_LIBRARIES - The ScaLAPACK include directories
#

include(UtilityMacros)
include(FindPackageHandleStandardArgs)

is_valid(ScaLAPACK_LIBRARIES FINDSCA_LIBS_SET)
if(NOT FINDSCA_LIBS_SET)
    find_library(ScaLAPACK_LIBRARY
        NAMES scalapack
        HINTS ${PC_ScaLAPACK_LIBDIR} ${PC_ScaLAPACK_LIBRARY_DIRS}
        PATHS ${ScaLAPACK_ROOT_DIR}
        PATH_SUFFIXES lib lib64 lib32
        DOC "ScaLAPACK Libraries"
    )
    find_package_handle_standard_args(ScaLAPACK DEFAULT_MSG
                                      ScaLAPACK_LIBRARY)
    set(ScaLAPACK_FOUND ${ScaLAPACK_FOUND})
    set(ScaLAPACK_LIBRARIES ${ScaLAPACK_LIBRARY})
endif()

find_package_handle_standard_args(ScaLAPACK DEFAULT_MSG
                                    ScaLAPACK_LIBRARIES)