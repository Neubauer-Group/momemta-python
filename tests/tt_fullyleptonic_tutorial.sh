#!/usr/bin/env bash

download-lhapdf CT10nlo

# Clone and built tutorials
git clone --depth 1 https://github.com/MoMEMta/Tutorials.git \
  --branch v1.0.0 \
  --single-branch
cd Tutorials
mkdir build
cd build
cmake \
  -DCMAKE_CXX_STANDARD=17 \
  ..
cmake --build . -- -j$(($(nproc) - 1))

# Built Matrix Elements
cd ../TTbar_FullyLeptonic/MatrixElement/
mkdir build
cd build
cmake \
  -DCMAKE_CXX_STANDARD=17 \
  ..
cmake --build . -- -j$(($(nproc) - 1))

# Run ttbar fully leptonic example
cd ../../../build/
TTbar_FullyLeptonic/TTbar_FullyLeptonic.exe
