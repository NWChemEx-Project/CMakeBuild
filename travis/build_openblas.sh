#!/bin/bash 
#cd $TRAVIS_BUILD_DIR
git clone -b release-0.2.21 https://github.com/xianyi/OpenBLAS.git
cd OpenBLAS
make PREFIX=$TRAVIS_BUILD_DIR INTERFACE64=0 USE_THREAD=0 NO_CBLAS=0 NO_LAPACKE=0 DEBUG=1 NUM_THREADS=1 all
make PREFIX=$TRAVIS_BUILD_DIR install
