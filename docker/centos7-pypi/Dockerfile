ARG BASE_IMAGE=gitlab-registry.cern.ch/linuxsupport/cc7-base:latest
FROM ${BASE_IMAGE} as base

SHELL [ "/bin/bash", "-c" ]

RUN yum update -y && \
    yum install -y \
        cmake3 \
        make \
        krb5-devel \
        libuuid-devel \
        libxml2-devel \
        openssl-devel \
        systemd-devel \
        zlib-devel \
        devtoolset-7-gcc-c++ \
        python3-devel \
        python3-setuptools \
        git \
        cppunit-devel && \
    yum clean all && \
    python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel

WORKDIR /

# Set PATH to pickup virtualenv by default
ENV PATH=/usr/local/venv/bin:"${PATH}"
RUN source scl_source enable devtoolset-7 && \
    python3 -m venv /usr/local/venv && \
    . /usr/local/venv/bin/activate && \
    python -m pip --no-cache-dir install --upgrade pip setuptools wheel && \
    python -m pip install --verbose 'xrootd==5.4.2' && \
    python -m pip list

RUN python -m pip list && \
    python -m pip show xrootd && \
    python -c 'import XRootD; print(XRootD)' && \
    python -c 'import pyxrootd; print(pyxrootd)' && \
    python -c 'from XRootD import client; print(client.FileSystem("root://someserver:1094"))'

SHELL [ "/usr/bin/scl", "enable", "devtoolset-7", "/bin/bash", "-c"]
