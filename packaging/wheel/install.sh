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


printf "\n\n\n\n\n#DEBUG\n\n\n\n\n"
ls -lhtra
printf "\n\n\n\n\n#DEBUG\n\n\n\n\n"
echo "INPUT 1: ${1}"
ls -lhtra "${1}"
printf "\n\n\n\n\n#DEBUG\n\n\n\n\n"
ls -lhtra "$(${6} -c 'import XRootD; import pathlib; print(str(pathlib.Path(XRootD.__path__[0]).parent))')"
printf "\n\n\n\n\n#DEBUG\n\n\n\n\n"
ls -lhtra "$(${6} -c 'import XRootD; import pathlib; print(str(pathlib.Path(XRootD.__path__[0]).parent))')/xrootd-*.egg"
printf "\n\n\n\n\n#DEBUG\n\n\n\n\n"

# TODO: Remove all of the below and build a wheel using PyPA tools

# N.B.: ${6} is the Python executable
${6} -m wheel convert \
    --verbose \
    --dest-dir /tmp \
    "$(${6} -c 'import XRootD; import pathlib; print(str(pathlib.Path(XRootD.__path__[0]).parent))')/xrootd-*.egg"
# Need to replace cp3x with 'none' in the wheel name (e.g. xrootd-2022.415-py310-none-linux_x86_64.whl)
mv /tmp/xrootd-*.whl "$(find /tmp -type f -iname "xrootd-*.whl" | sed 's/cp[0-9]*-/none-/g')"
${6} -m pip uninstall --yes --verbose xrootd
# After uninstall there will now be an empty easy-install.path left over from egg build
${6} -m pip install --upgrade /tmp/xrootd-*.whl

# # convert the egg-info into a proper dist-info
# egginfo_path=$(ls $1/xrootd-*.egg-info)
# core="${egginfo_path%.*}"
# core="${egginfo_path#$1/}"
# sufix="${core#xrootd-*.*.*_-}"
# core="${core%_-*}"
# if [[ "$core" == "$sufix" ]]
# then
#     distinfo_path="${egginfo_path%.*}.dist-info"
# else
#     distinfo_path="$1/$core-$sufix"
# fi
# echo $distinfo_path >> /tmp/out.txt
# mkdir $distinfo_path
# mv $egginfo_path $distinfo_path/METADATA
# echo -e "Wheel-Version: 1.0\nGenerator: bdist_wheel (0.35.1)\nRoot-Is-Purelib: true\nTag: py2-none-any\nTag: py3-none-any" > $distinfo_path/WHEEL
# touch $distinfo_path/RECORD
# distinfo_name=${distinfo_path#"$1"}
# find $1/pyxrootd/      -type f -exec sha256sum {} \; | awk '{printf$2 ",sha256=" $1 "," ; system("stat --printf=\"%s\" "$2) ; print '\n'; }' >> $distinfo_path/RECORD
# find $1/$distinfo_name -type f -exec sha256sum {} \; | awk '{printf$2 ",sha256=" $1 "," ; system("stat --printf=\"%s\" "$2) ; print '\n'; }' >> $distinfo_path/RECORD
# find $1/XRootD/        -type f -exec sha256sum {} \; | awk '{printf$2 ",sha256=" $1 "," ; system("stat --printf=\"%s\" "$2) ; print '\n'; }' >> $distinfo_path/RECORD
# find $1/pyxrootd/ -type l | awk '{print$1 ",,"}' >> $distinfo_path/RECORD
