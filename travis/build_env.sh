#!/bin/bash
sudo add-apt-repository universe && sudo apt update
sudo apt-get -y install g++-7 gcc-7 gfortran-7 python3.6-dev cmake openmpi-bin libopenmpi-dev make
sudo update-alternatives --install /usr/bin/g++      g++      /usr/bin/g++-7 90
sudo update-alternatives --install /usr/bin/gcc      gcc      /usr/bin/gcc-7 90
sudo update-alternatives --install /usr/bin/gfortran gfortran /usr/bin/gfortran-7 90
