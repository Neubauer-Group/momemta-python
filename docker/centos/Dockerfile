ARG BUILDER_IMAGE=neubauergroup/centos-root-base:6.24.00
FROM ${BUILDER_IMAGE} as builder

USER root
WORKDIR /usr/local

SHELL [ "/bin/bash", "-c" ]

RUN yum update -y && \
    yum install -y \
      boost-devel \
      vim \
      zlib \
      zlib-devel \
      bzip2-devel \
      bash-completion \
      wget && \
    yum clean all && \
    yum autoremove -y

# Install LHAPDF
ARG LHAPDF_VERSION=6.2.3
# hadolint ignore=SC2155
RUN mkdir -p /code && \
    cd /code && \
    wget https://lhapdf.hepforge.org/downloads/?f=LHAPDF-${LHAPDF_VERSION}.tar.gz -O LHAPDF-${LHAPDF_VERSION}.tar.gz && \
    tar xvfz LHAPDF-${LHAPDF_VERSION}.tar.gz && \
    cd LHAPDF-${LHAPDF_VERSION} && \
    ./configure --help && \
    export CXX=$(command -v g++) && \
    export PYTHON=$(command -v python) && \
    ./configure \
      --prefix=/usr/local && \
    make -j$(($(nproc) - 1)) && \
    make install && \
    rm -rf /code

# Install MoMEMta
ARG MOMEMTA_VERSION=v1.0.0
RUN mkdir -p /code && \
    cd /code && \
    git clone --depth 1 https://github.com/MoMEMta/MoMEMta.git \
      --branch "${MOMEMTA_VERSION}" \
      --single-branch && \
    cd MoMEMta/ && \
    mkdir build && \
    cd build && \
    cmake \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DTESTS=OFF \
      -DEXAMPLES=OFF \
      -DCMAKE_CXX_STANDARD=11 \
      -DPYTHON_BINDINGS=ON \
      -DPYTHON_MIN_VERSION=3 \
      -DBoost_PYTHON_VERSION_TAG=3 \
      .. && \
    cmake --build . -- -j$(($(nproc) - 1)) && \
    cmake --build . --target install && \
    rm -rf /code

# Create user "docker"
RUN useradd --shell /bin/bash -m docker && \
   cp /root/.bashrc /home/docker/ && \
   mkdir /home/docker/data && \
   chown -R --from=root docker /home/docker && \
   chown -R --from=root docker /usr && \
   chown -R --from=root docker /usr/local

ENV HOME /home/docker
WORKDIR ${HOME}/data
# hadolint ignore=SC2016
RUN cp /root/.profile ${HOME}/.profile && \
    cp /root/.bashrc ${HOME}/.bashrc && \
    echo "" >> ${HOME}/.bashrc && \
    echo 'export PATH=${HOME}/.local/bin:$PATH' >> ${HOME}/.bashrc

ENV USER docker
USER docker
ENV PYTHONPATH=/usr/local/lib:$PYTHONPATH
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
ENV PATH ${HOME}/.local/bin:$PATH

ENTRYPOINT ["/bin/bash", "-l", "-c"]
CMD ["/bin/bash"]
