#!/bin/bash 
#cd $TRAVIS_BUILD_DIR
git clone -b release-0.2.21 https://github.com/xianyi/OpenBLAS.git
cd OpenBLAS
make PREFIX=$TRAVIS_BUILD_DIR INTERFACE64=1 USE_THREAD=0 NO_CBLAS=1 NO_LAPACKE=1 DEBUG=1 NUM_THREADS=1 all 
# > make.log
# tail make.log
make PREFIX=$TRAVIS_BUILD_DIR install
# > make_install.log
#tail make_install.log
