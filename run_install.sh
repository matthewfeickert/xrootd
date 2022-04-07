#!/bin/bash

rm -f \
    TestCXX14.txt \
    setup.py \
    pyproject.toml \
    publish.sh \
    MANIFEST.in \
    install.sh \
    has_c++14.sh
rm -rf /home/feickert/.pyenv/versions/3.9.6/envs/xrootd-dev/lib/python3.9/site-packages/pyxrootd

cp packaging/wheel/* .
. publish.sh

ls -lhtra dist/

python -m pip install --verbose dist/xrootd-*.tar.gz
