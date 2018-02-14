ExternalProject_Add(Eigen3_External
    URL http://bitbucket.org/eigen/eigen/get/3.3.4.tar.gz
    CMAKE_ARGS ${CORE_CMAKE_OPTIONS} 
        INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${STAGE_DIR}
    )

