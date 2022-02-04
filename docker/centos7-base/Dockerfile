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

# CMD ["scl", "enable", "devtoolset-7", "/bin/bash"]
# CMD ["/bin/bash"]
# ENTRYPOINT ["scl", "enable", "devtoolset-7", "bash"]
SHELL [ "/usr/bin/scl", "enable", "devtoolset-7", "/bin/bash", "-c"]
