#!/bin/bash

./genversion.sh
version=$(./genversion.sh --print-only)
version=${version#v}
echo $version > bindings/python/VERSION
rm -r dist

# Determine if wheel.bdist_wheel is available for wheel.bdist_wheel in setup.py
python3 -c 'import wheel' &> /dev/null
wheel_available=$?
if [ "${wheel_available}" -ne "0" ]; then
    python3 -m pip install wheel
    res=$?
fi
unset wheel_available

if [ "$res" -ne "0" ]; then
    echo "ERROR: Unable to find wheel and unable to install wheel with '$(command -v python3) -m pip install wheel'."
    echo "       Please ensure wheel is available to $(command -v python3) and try again."
    exit 1
fi

python3 setup.py sdist
