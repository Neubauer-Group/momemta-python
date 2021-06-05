ARG BUILDER_IMAGE=neubauergroup/centos-root-base:6.24.00
FROM ${BUILDER_IMAGE} as builder

USER root
WORKDIR /usr/local

SHELL [ "/bin/bash", "-c" ]

RUN yum update -y && \
    yum install -y \
      vim \
      zlib \
      zlib-devel \
      bzip2-devel \
      bash-completion \
      wget && \
    yum clean all && \
    yum autoremove -y

# Install BOOST
# c.f. https://www.boost.org/doc/libs/1_76_0/more/getting_started/unix-variants.html
ARG BOOST_VERSION=1.76.0
RUN mkdir -p /code && \
    cd /code && \
    BOOST_VERSION_UNDERSCORE="${BOOST_VERSION//\./_}" && \
    curl --silent --location --remote-name "https://boostorg.jfrog.io/artifactory/main/release/${BOOST_VERSION}/source/boost_${BOOST_VERSION_UNDERSCORE}.tar.gz" && \
    tar -xzf "boost_${BOOST_VERSION_UNDERSCORE}.tar.gz" && \
    cd "boost_${BOOST_VERSION_UNDERSCORE}" && \
    ./bootstrap.sh --help && \
    ./bootstrap.sh --with-python=$(command -v python) && \
    ./b2 install -j$(($(nproc) - 1)) && \
    cd / && \
    rm -rf /code

# Install LHAPDF
ARG LHAPDF_VERSION=6.2.3
# hadolint ignore=SC2155
RUN mkdir -p /code && \
    cd /code && \
    wget --no-check-certificate https://lhapdf.hepforge.org/downloads/?f=LHAPDF-${LHAPDF_VERSION}.tar.gz -O LHAPDF-${LHAPDF_VERSION}.tar.gz && \
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

ARG MOMEMTA_VERSION=v1.0.0
RUN mkdir -p /code && \
    cd /code && \
    git clone --depth 1 https://github.com/MoMEMta/MoMEMta.git \
      --branch "${MOMEMTA_VERSION}" \
      --single-branch && \
    cmake \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DTESTS=OFF \
      -DEXAMPLES=OFF \
      -DCMAKE_CXX_STANDARD=11 \
      -DPYTHON_BINDINGS=ON \
      -DPYTHON_MIN_VERSION=3 \
      -DBoost_PYTHON_VERSION_TAG=3 \
      -S MoMEMta \
      -B build && \
    cmake build -L && \
    cmake --build build -- -j$(($(nproc) - 1)) && \
    cmake --build build --target install && \
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
