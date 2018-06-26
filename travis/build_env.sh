#!/bin/bash
sudo add-apt-repository universe && sudo apt update
sudo apt-get -y install gcc-7 python3 pybind11 cmake openmpi-bin libopenmpi-dev make
