ARG BUILDER_IMAGE=scailfin/madgraph5-amc-nlo-centos:mg5_amc3.1.1
FROM neubauergroup/centos-root-base:6.24.00 as root_cern_image
FROM ${BUILDER_IMAGE} as builder

USER root
WORKDIR /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY --from=root_cern_image /usr/local/root-cern /usr/local/root-cern
COPY --from=root_cern_image /tmp/packages.txt /tmp/packages.txt
COPY --from=root_cern_image /tmp/requirements.txt /tmp/requirements.txt
ENV PYTHONPATH=/usr/local/root-cern/lib:$PYTHONPATH
ENV LD_LIBRARY_PATH=/usr/local/root-cern/lib:$LD_LIBRARY_PATH
ENV ROOTSYS=/usr/local/root-cern
ENV PATH="${PATH}:${ROOTSYS}/bin"

# hadolint ignore=SC2046
RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y $(cat /tmp/packages.txt) && \
    yum install -y \
      vim \
      zlib \
      zlib-devel \
      bzip2-devel \
      bash-completion \
      wget && \
    yum clean all && \
    yum autoremove -y && \
    python -m pip --no-cache-dir install --upgrade pip setuptools wheel && \
    python -m pip --no-cache-dir install --requirement /tmp/requirements.txt && \
    python -m pip list

# MOMEMTA CXX_STANDARD must match ROOT's
# Currently using C++14
ARG MOMEMTA_VERSION=v1.0.1
# hadolint ignore=SC1091
# hadolint ignore=SC2046
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
    rm -rf /code && \
    cd $(python -c 'import madgraph; print(madgraph.MG5DIR)')/PLUGIN/ && \
    git clone --depth 1 https://github.com/matthewfeickert/MoMEMta-MaGMEE.git \
      --branch feat/apply-pyupgrade \
      --single-branch

ENV HOME /home/docker
WORKDIR ${HOME}/data
RUN chown -R --from=root docker /usr/local/root-cern && \
    chown -R --from=root docker /home/docker && \
    chown -R --from=root docker /home/docker/.mg5

ENV USER=docker
USER docker
# Need to place MoMEMta-MaGMEE plugin on PYTHONPATH
ENV PYTHONPATH="/usr/local/venv/MG5_aMC/PLUGIN/MoMEMta-MaGMEE:${PYTHONPATH}"
ENV LD_LIBRARY_PATH=/usr/local/venv/lib:$LD_LIBRARY_PATH
ENV PATH ${HOME}/.local/bin:$PATH

ENTRYPOINT ["/bin/bash", "-l", "-c"]
CMD ["/bin/bash"]
