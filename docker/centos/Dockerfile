ARG BUILDER_IMAGE=scailfin/madgraph5-amc-nlo-centos:mg5_amc3.1.1
FROM ${BUILDER_IMAGE} as builder

USER root
WORKDIR /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# COPY ROOT out of neubauergroup/centos-root-base:6.24.00
ARG ROOT_IMAGE=neubauergroup/centos-root-base:6.24.00
COPY --from="${ROOT_IMAGE}" /usr/local/root-cern /usr/local/root-cern
COPY --from="${ROOT_IMAGE}" /tmp/packages.txt /tmp/packages.txt
COPY --from="${ROOT_IMAGE}" /tmp/requirements.txt /tmp/requirements.txt
ENV PYTHONPATH=/usr/local/root-cern/lib:$PYTHONPATH
ENV LD_LIBRARY_PATH=/usr/local/root-cern/lib:$LD_LIBRARY_PATH
ENV ROOTSYS=/usr/local/root-cern
ENV PATH="${PATH}:${ROOTSYS}/bin"

RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y $(cat /tmp/packages.txt) && \
    yum install -y \
      centos-release-scl \
      vim \
      zlib \
      zlib-devel \
      bzip2-devel \
      bash-completion \
      wget && \
    yum install -y devtoolset-8 && \
    yum clean all && \
    yum autoremove -y && \
    python -m pip --no-cache-dir install --upgrade pip setuptools wheel && \
    python -m pip --no-cache-dir install --requirement /tmp/requirements.txt && \
    python -m pip list

# Install BOOST
# c.f. https://www.boost.org/doc/libs/1_76_0/more/getting_started/unix-variants.html
ARG BOOST_VERSION=1.76.0
# hadolint ignore=SC2046
RUN mkdir -p /code && \
    cd /code && \
    BOOST_VERSION_UNDERSCORE="${BOOST_VERSION//\./_}" && \
    curl --silent --location --remote-name "https://boostorg.jfrog.io/artifactory/main/release/${BOOST_VERSION}/source/boost_${BOOST_VERSION_UNDERSCORE}.tar.gz" && \
    tar -xzf "boost_${BOOST_VERSION_UNDERSCORE}.tar.gz" && \
    cd "boost_${BOOST_VERSION_UNDERSCORE}" && \
    source scl_source enable devtoolset-8 && \
    ./bootstrap.sh --help && \
    ./bootstrap.sh \
      --prefix=/usr/local/venv \
      --with-python=$(command -v python3) && \
    ./b2 install -j$(($(nproc) - 1)) && \
    cd / && \
    rm -rf /code

# MOMEMTA CXX_STANDARD must match ROOT's
# Currently using C++14
ARG MOMEMTA_VERSION=v1.0.1
# hadolint ignore=SC1091
RUN mkdir -p /code && \
    cd /code && \
    git clone --depth 1 https://github.com/MoMEMta/MoMEMta.git \
      --branch "${MOMEMTA_VERSION}" \
      --single-branch && \
    source scl_source enable devtoolset-8 && \
    ROOT_CXX_STANDARD=$(root-config --cflags | sed --regexp-extended 's/.*-std=c\+\+([0-9]+).*/\1/g') && \
    cmake \
      -DCMAKE_INSTALL_PREFIX=/usr/local/venv \
      -DTESTS=OFF \
      -DEXAMPLES=OFF \
      -DCMAKE_CXX_STANDARD="${ROOT_CXX_STANDARD}" \
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
# hadolint ignore=SC2016,SC1091
RUN cp /root/.bash_profile ${HOME}/.bash_profile && \
    cp /root/.bashrc ${HOME}/.bashrc && \
    echo "" >> ${HOME}/.bashrc && \
    echo 'export PATH=${HOME}/.local/bin:$PATH' >> ${HOME}/.bashrc

ENV USER docker
USER docker
ENV PYTHONPATH=/usr/local/venv/lib:$PYTHONPATH
ENV LD_LIBRARY_PATH=/usr/local/venv/lib:$LD_LIBRARY_PATH
ENV PATH ${HOME}/.local/bin:$PATH

ENTRYPOINT ["/bin/bash", "-l", "-c"]
CMD ["/bin/bash"]
