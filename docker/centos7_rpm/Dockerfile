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

RUN yum update -y && \
    yum install -y \
        xrootd-5.4.1 \
        xrootd-client-5.4.1 \
        python36-xrootd-5.4.1 && \
    yum clean all && \
    xrootd -v && \
    xrdcp --version && \
    python3 -m pip list && \
    python3 -m pip show xrootd  # 5.4.1

# The following would fail with the error:
#
# ERROR: Cannot uninstall 'xrootd'. It is a distutils installed project and thus we
# cannot accurately determine which files belong to it which would lead to only a
# partial uninstall.
#
# as you're asking pip to try to deal with something it didn't install.

# RUN . /opt/rh/devtoolset-7/enable && \
#     python3 -m pip install --upgrade --force-reinstall 'xrootd==5.4.2' && \
#     xrootd -v && \
#     xrdcp --version && \
#     python3 -m pip list && \
#     python3 -m pip show xrootd

# The solution is to uninstall the RPM package and _then_ to install things
# A better solution is to not be installing Python packages globally as pip
# warns us about:
#
# WARNING: Running pip as the 'root' user can result in broken permissions and
# conflicting behaviour with the system package manager. It is recommended to
# use a virtual environment instead: https://pip.pypa.io/warnings/venv
#
# and to instead either use an automatically activated virtual envrionment or to
# use pipx

RUN yum remove python36-xrootd -y && \
    . /opt/rh/devtoolset-7/enable && \
    python3 -m pip --verbose install \
        --upgrade \
        --force-reinstall \
        'xrootd==5.4.2' && \
    xrootd -v && \
    xrdcp --version && \
    python3 -m pip list && \
    python3 -m pip show xrootd && \
    python3 -c 'import XRootD; print(XRootD)' && \
    python3 -c 'import pyxrootd; print(pyxrootd)' && \
    python3 -c 'from XRootD import client; print(client.FileSystem("root://someserver:1094"))'

WORKDIR /

SHELL [ "/usr/bin/scl", "enable", "devtoolset-7", "/bin/bash", "-c"]
