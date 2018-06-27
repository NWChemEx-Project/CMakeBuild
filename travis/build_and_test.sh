#!/bin/bash
mkdir build
cd build
cmake -DCMAKE_CXX_COMPILER=mpicxx ..
make
make test
