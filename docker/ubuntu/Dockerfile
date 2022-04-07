ARG BASE_IMAGE=ubuntu:20.04
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
        tree \
        python3 \
        python3-pip \
        python3-venv \
        python3-dev && \
    apt-get autoclean -y && \
    python3 -m pip --no-cache-dir install --upgrade pip setuptools wheel && \
    python3 -m pip list

WORKDIR /
# # export LD_LIBRARY_PATH="$(python3 -m site --user-site)/pyxrootd/lib:${LD_LIBRARY_PATH}"
# ENV LD_LIBRARY_PATH="/root/.local/lib/python3.8/site-packages/pyxrootd/lib:${LD_LIBRARY_PATH}"
# # Show --user even though I don't recommend it just to show it works
# RUN python3 -m pip --no-cache-dir install --user --upgrade pip setuptools wheel && \
#     python3 -m pip install --user --verbose 'xrootd==5.4.2' && \
#     python3 -m pip list

# RUN python3 -m pip list && \
#     python3 -m pip show xrootd && \
#     python3 -c 'import XRootD; print(XRootD)' && \
#     python3 -c 'import pyxrootd; print(pyxrootd)' && \
#     python3 -c 'from XRootD import client; print(client.FileSystem("root://someserver:1094"))'

WORKDIR /

# Set PATH to pickup virtualenv by default
ENV PATH=/usr/local/venv/bin:"${PATH}"
# ENV LD_LIBRARY_PATH="/usr/local/venv/lib/python3.8/site-packages/pyxrootd/lib:${LD_LIBRARY_PATH}"
# RUN python3 -m venv /usr/local/venv && \
#     . /usr/local/venv/bin/activate
RUN python3 -m venv /usr/local/venv && \
    . /usr/local/venv/bin/activate && \
    python3 -m pip --no-cache-dir install --upgrade pip setuptools wheel && \
    SETUPTOOLS_USE_DISTUTILS=stdlib python3 -m pip install --verbose 'xrootd==5.4.2' && \
    python3 -m pip list
# ENV LD_LIBRARY_PATH="/usr/local/venv/lib/python3.8/site-packages/pyxrootd/lib:${LD_LIBRARY_PATH}"
# RUN python3 -m venv /usr/local/venv && \
#     . /usr/local/venv/bin/activate && \
#     python -m pip --no-cache-dir install --upgrade pip setuptools wheel && \
#     ORIGIN=/usr/local/venv/lib/python3.8/site-packages/pyxrootd/lib python -m pip install --verbose 'xrootd==5.4.2' && \
#     python -m pip list

WORKDIR /code

# RUN git clone https://github.com/xrootd/xrootd \
#         --branch v5.4.2 \
#         --single-branch && \
#     cd xrootd && \
#     cp packaging/wheel/* . && \
#     ./publish.sh && \
#     cd .. && \
#     python3 -m pip --verbose install xrootd/dist/xrootd-*.tar.gz && \
#     python3 -m pip list

RUN python3 -m pip list && \
    python3 -m pip show xrootd && \
    python3 -c 'import XRootD; print(XRootD)' && \
    python3 -c 'import pyxrootd; print(pyxrootd)' && \
    python3 -c 'from XRootD import client; print(client.FileSystem("root://someserver:1094"))' && \
    ls -lhtra /usr/local/venv/lib/python3.8/site-packages/ && \
    cat /usr/local/venv/lib/python3.8/site-packages/xrootd*/WHEEL

WORKDIR /

CMD ["/bin/bash"]
