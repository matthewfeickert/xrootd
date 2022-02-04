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

COPY . /code/xrootd

WORKDIR /code
RUN source scl_source enable devtoolset-7 && \
    cmake3 \
        -DCMAKE_INSTALL_PREFIX=/usr/local/ \
        -DPYTHON_EXECUTABLE=$(command -v python3) \
        -DENABLE_TESTS=ON \
        -S xrootd \
        -B build && \
    cmake3 build -LH && \
    cmake3 \
        --build build \
        --clean-first \
        --parallel $(($(nproc) - 1)) && \
    cmake3 --build build --target install && \
    cd / && \
    python3 -m pip list

WORKDIR /

SHELL [ "/usr/bin/scl", "enable", "devtoolset-7", "/bin/bash", "-c"]
