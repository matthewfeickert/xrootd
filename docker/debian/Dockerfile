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
        python3 \
        python3-pip \
        python3-venv \
        python3-dev && \
    apt-get autoclean -y && \
    python3 -m pip --no-cache-dir install --upgrade pip setuptools wheel && \
    python3 -m pip list

COPY . /code/xrootd


ENV LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"
# ENV PYTHON_VERSION_MINOR=$(_tmp=$(find /usr/local/lib/ -type d -iname "python*") && echo ${_tmp: -3}; unset _tmp)
ENV PYTHON_VERSION_MINOR=3.9
ENV PYTHONPATH="/usr/local/lib/python${PYTHON_VERSION_MINOR}/site-packages:${PYTHONPATH}"

WORKDIR /code
RUN cmake \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DPYTHON_EXECUTABLE=$(command -v python3) \
        -DENABLE_TESTS=ON \
        -DPIP_OPTIONS="--verbose" \
        -S xrootd \
        -B build && \
    cmake build -LH && \
    cmake \
        --build build \
        --clean-first \
        --parallel $(($(nproc) - 1)) && \
    cmake --build build --target install && \
    python3 -m pip list

# WORKDIR /code/xrootd
# RUN source scl_source enable devtoolset-7 && \
#     cp packaging/wheel/* . && \
#     ./publish.sh && \
#     python3 -m pip --verbose install dist/xrootd-*.tar.gz && \
#     python3 -m pip list
# WORKDIR /

# ENV LD_LIBRARY_PATH="/usr/local/venv/lib:${LD_LIBRARY_PATH}"
# # ENV PYTHON_VERSION_MINOR=$(_tmp=$(find /usr/local/lib/ -type d -iname "python*") && echo ${_tmp: -3}; unset _tmp)
# ENV PYTHON_VERSION_MINOR=3.9
# ENV PYTHONPATH="/usr/local/venv/lib/python${PYTHON_VERSION_MINOR}/dist-packages:/usr/local/venv/lib/python${PYTHON_VERSION_MINOR}/site-packages:${PYTHONPATH}"

# ENV LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"
# # ENV PYTHON_VERSION_MINOR=$(_tmp=$(find /usr/local/lib/ -type d -iname "python*") && echo ${_tmp: -3}; unset _tmp)
# ENV PYTHON_VERSION_MINOR=3.9
# ENV PYTHONPATH="/usr/local/lib/python${PYTHON_VERSION_MINOR}/site-packages:${PYTHONPATH}"

RUN python3 -m pip list && \
    python3 -m pip show xrootd && \
    python3 -c 'import XRootD; print(XRootD)' && \
    python3 -c 'import pyxrootd; print(pyxrootd)' && \
    python3 -c 'from XRootD import client; print(client.FileSystem("root://someserver:1094"))'

WORKDIR /

CMD ["/bin/bash"]
