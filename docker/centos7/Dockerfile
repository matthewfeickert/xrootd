ARG BASE_IMAGE=gitlab-registry.cern.ch/linuxsupport/cc7-base:latest
FROM ${BASE_IMAGE} as base

SHELL [ "/bin/bash", "-c" ]

RUN yum update -y && \
    yum install --nogpg -y \
        cmake3 \
        make \
        krb5-devel \
        libuuid-devel \
        libxml2-devel \
        openssl-devel \
        systemd-devel \
        zlib-devel \
        devtoolset-7-gcc-c++ \
        which \
        python3-devel \
        python3-setuptools \
        git \
        cppunit-devel && \
    yum clean all

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

# WORKDIR /code/xrootd
# RUN source scl_source enable devtoolset-7 && \
#     cp packaging/wheel/* . && \
#     ./publish.sh && \
#     python3 -m pip --verbose install dist/xrootd-*.tar.gz && \
#     python3 -m pip list
# WORKDIR /

RUN python3 -m pip list && \
    python3 -m pip show xrootd && \
    python3 -c 'import XRootD; print(XRootD)' && \
    python3 -c 'import pyxrootd; print(pyxrootd)' && \
    python3 -c 'from XRootD import client; print(client.FileSystem("root://someserver:1094"))'

WORKDIR /

CMD ["scl", "enable", "devtoolset-7", "/bin/bash"]
