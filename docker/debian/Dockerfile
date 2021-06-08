ARG BUILDER_IMAGE=atlasamglab/stats-base:root6.24.00
FROM ${BUILDER_IMAGE} as builder

USER root
WORKDIR /usr/local

SHELL [ "/bin/bash", "-c" ]

RUN apt-get -qq -y update && \
    apt-get -qq -y --no-install-recommends install \
      gcc \
      g++ \
      gfortran \
      make \
      cmake \
      libboost-all-dev \
      vim \
      zlibc \
      zlib1g-dev \
      libbz2-dev \
      rsync \
      git \
      bash-completion \
      wget && \
    apt-get -y autoclean && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt-get/lists/*

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
      --prefix=/usr/local/venv && \
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
    cmake \
      -DCMAKE_INSTALL_PREFIX=/usr/local/venv \
      -DTESTS=OFF \
      -DEXAMPLES=OFF \
      -DCMAKE_CXX_STANDARD=17 \
      -DPYTHON_BINDINGS=ON \
      -DPYTHON_MIN_VERSION=3 \
      -DBoost_PYTHON_VERSION_TAG=3 \
      -S MoMEMta \
      -B build && \
    cmake --build build -- -j$(($(nproc) - 1)) && \
    cmake --build build --target install && \
    rm -rf /code

# Enable tab completion by uncommenting it from /etc/bash.bashrc
# The relevant lines are those below the phrase "enable bash completion in interactive shells"
RUN export SED_RANGE="$(($(sed -n '\|enable bash completion in interactive shells|=' /etc/bash.bashrc)+1)),$(($(sed -n '\|enable bash completion in interactive shells|=' /etc/bash.bashrc)+7))" && \
    sed -i -e "${SED_RANGE}"' s/^#//' /etc/bash.bashrc && \
    unset SED_RANGE

# Create user "docker"
RUN useradd --shell /bin/bash -m docker && \
   cp /root/.bashrc /home/docker/ && \
   mkdir /home/docker/data && \
   chown -R --from=root docker /home/docker && \
   chown -R --from=root docker /usr && \
   chown -R --from=root docker /usr/local

# Use C.UTF-8 locale to avoid issues with ASCII encoding
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

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
