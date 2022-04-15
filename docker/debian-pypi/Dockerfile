ARG BASE_IMAGE=debian:bullseye
FROM ${BASE_IMAGE} as base

SHELL [ "/bin/bash", "-c" ]

ENV PATH=/usr/local/venv/bin:"${PATH}"
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        g++ \
        git \
        cmake \
        uuid-dev \
        dpkg-dev \
        libssl-dev \
        libx11-dev \
        libxml2-dev \
        libkrb5-dev \
        libgsl0-dev \
        pkg-config \
        python3 \
        python3-pip \
        python3-venv \
        python3-dev && \
    apt-get autoclean -y && \
    python3 -m pip --no-cache-dir install --upgrade pip setuptools wheel && \
    python3 -m pip list

WORKDIR /code
COPY . xrootd
WORKDIR /code/xrootd
RUN pushd .. && \
    python3 -m venv venv && \
    . venv/bin/activate && \
    python3 -m pip install --upgrade pip setuptools wheel && \
    popd && \
    cp packaging/wheel/* . && \
    ./publish.sh && \
    cd .. && \
    python3 -m pip --verbose install ./xrootd/dist/xrootd-*.tar.gz && \
    python3 -m pip list

# export LD_LIBRARY_PATH="$(python3 -m site --user-site)/pyxrootd/lib:${LD_LIBRARY_PATH}"
# ENV LD_LIBRARY_PATH="/root/.local/lib/python3.9/site-packages/pyxrootd/lib:${LD_LIBRARY_PATH}"
# Show --user even though I don't recommend it just to show it works
# RUN python3 -m pip --no-cache-dir install --user --upgrade pip setuptools wheel && \
#     python3 -m pip install --user --verbose 'xrootd==5.4.2' && \
#     python3 -m pip list

# RUN python3 -m pip list && \
#     python3 -m pip show xrootd && \
#     python3 -c 'import XRootD; print(XRootD)' && \
#     python3 -c 'import pyxrootd; print(pyxrootd)' && \
#     python3 -c 'from XRootD import client; print(client.FileSystem("root://someserver:1094"))'

WORKDIR /

CMD ["/bin/bash"]
