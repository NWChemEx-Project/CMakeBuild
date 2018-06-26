#!/bin/bash
sudo add-apt-repository universe && sudo apt update
#sudo apt-get remove g++
sudo apt-get -y install g++-7 gcc-7 python3.6-dev cmake openmpi-bin libopenmpi-dev make
