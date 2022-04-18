#!/bin/bash

startdir="$(pwd)"
mkdir xrootdbuild
cd xrootdbuild

# build only client
# build python bindings
# set install prefix
# set the respective version of python
# replace the default BINDIR with a custom one that can be easily removed afterwards
#    (for the python bindings we don't want to install the binaries)
CMAKE_ARGS="-DPYPI_BUILD=TRUE -DXRDCL_LIB_ONLY=TRUE -DENABLE_PYTHON=TRUE -DCMAKE_INSTALL_PREFIX=$1/pyxrootd -DXRD_PYTHON_REQ_VERSION=$2 -DCMAKE_INSTALL_BINDIR=$startdir/xrootdbuild/bin"

if [ "$5" = "true" ]; then
  source /opt/rh/devtoolset-7/enable
fi

cmake_path=$4
$cmake_path .. $CMAKE_ARGS

res=$?
if [ "$res" -ne "0" ]; then
    exit 1
fi

make -j8
res=$?
if [ "$res" -ne "0" ]; then
    exit 1
fi

cd src
make install
res=$?
if [ "$res" -ne "0" ]; then
    exit 1
fi

cd ../bindings/python

# Determine if shutil.which is available for a modern Python package install
${6} -c 'import shutil.which' &> /dev/null  # $6 holds the python sys.executable
shutil_which_available=$?
if [ "${shutil_which_available}" -ne "0" ]; then
    ${6} setup.py install ${3}
    res=$?
else
    ${6} -m pip install ${3} .
    res=$?
fi
unset shutil_which_available

if [ "$res" -ne "0" ]; then
    exit 1
fi

cd $startdir
rm -r xrootdbuild

# Convert installed egg distribution to a wheel
# TODO: Revise install.sh to build a wheel using PyPA tools
# N.B.:
# - ${6} is the Python executable
# - ${1} is the CMake install prefix for the build library
${6} -m wheel convert \
    --verbose \
    --dest-dir /tmp \
    "${1}/xrootd-*.egg"
# Need to replace cp3x with 'none' in the wheel name (e.g. xrootd-2022.415-py310-none-linux_x86_64.whl)
mv /tmp/xrootd-*.whl "$(find /tmp -type f -iname "xrootd-*.whl" | sed 's/cp[0-9]*-/none-/g')"
${6} -m pip uninstall --yes --verbose xrootd
# After uninstall of egg distribution there will now be an empty easy-install.path left over from
# the egg build, so if it is empty (not being used by any other package) remove it for tidyness
if [ ! -s "${1}/easy-install.pth" ]; then
    rm "${1}/easy-install.pth"
fi
${6} -m pip install --upgrade /tmp/xrootd-*.whl
