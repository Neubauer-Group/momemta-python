#!/usr/bin/env bash

# bash "scrict mode"
set -e
set -u
set -o pipefail

# Download required LHAPDF set
lhapdf get CT10nlo

# Get CMAKE_CXX_STANDARD ROOT was built with
ROOT_CONFIG_CXX=$(root-config --cflags | awk '{print $2}')
ROOT_CXX_STANDARD="${ROOT_CONFIG_CXX: -2}"
unset ROOT_CONFIG_CXX

# Clone and build tutorials
git clone --depth 1 https://github.com/MoMEMta/Tutorials.git \
  --branch v1.0.0 \
  --single-branch
cmake \
  -DCMAKE_CXX_STANDARD="${ROOT_CXX_STANDARD}" \
  -S Tutorials \
  -B Tutorials/build
cmake Tutorials/build -L
cmake --build Tutorials/build -- -j$(($(nproc) - 1))

# Build Matrix Elements
cmake \
  -DCMAKE_CXX_STANDARD="${ROOT_CXX_STANDARD}" \
  -S Tutorials/TTbar_FullyLeptonic/MatrixElement \
  -B Tutorials/TTbar_FullyLeptonic/MatrixElement/build
cmake Tutorials/TTbar_FullyLeptonic/MatrixElement/build -L
cmake --build Tutorials/TTbar_FullyLeptonic/MatrixElement/build -- -j$(($(nproc) - 1))

# Run ttbar fully leptonic example
cd Tutorials/build
TTbar_FullyLeptonic/TTbar_FullyLeptonic.exe

unset ROOT_CXX_STANDARD
