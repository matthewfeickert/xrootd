ARG BASE_IMAGE=fedora:35
FROM ${BASE_IMAGE} as base

SHELL [ "/bin/bash", "-c" ]

RUN dnf update -y && \
    dnf install -y \
        findutils \
        gcc \
        g++ \
        cmake3 \
        make \
        krb5-devel \
        libuuid-devel \
        libxml2-devel \
        openssl-devel \
        systemd-devel \
        zlib-devel \
        python3-devel \
        python3-setuptools \
        git \
        cppunit-devel && \
    dnf clean all && \
    python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel

WORKDIR /code
COPY . xrootd
WORKDIR /code/xrootd

# Set PATH to pickup virtualenv by default
ENV PATH=/usr/local/venv/bin:"${PATH}"
RUN python3 -m venv /usr/local/venv && \
    . /usr/local/venv/bin/activate && \
    python3 -m pip install --upgrade pip setuptools wheel && \
    cp packaging/wheel/* . && \
    ./publish.sh && \
    python3 -m pip --verbose install ./dist/xrootd-*.tar.gz && \
    python3 -m pip list

RUN python -m pip list && \
    python -m pip show xrootd && \
    python -c 'import XRootD; print(XRootD)' && \
    python -c 'import pyxrootd; print(pyxrootd)' && \
    python -c 'from XRootD import client; print(client.FileSystem("root://someserver:1094"))'

WORKDIR /
