#!/usr/bin/env bash
set -e

EDK2_TARGET=edk2-stable202202
EDK2_URL=https://github.com/tianocore/edk2.git

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

pushd $DIR/build

if [ ! -d edk2 ]; then
  mkdir edk2
  pushd edk2
  git init
  git remote add origin $EDK2_URL
  git fetch --depth 1 origin $EDK2_TARGET
  git checkout FETCH_HEAD
  git submodule update --init
  popd
fi

pushd edk2
make -C BaseTools
source ./edksetup.sh
build -p ShellPkg/ShellPkg.dsc -b RELEASE -a X64 -t GCC5
cp ./Build/Shell/RELEASE_GCC5/X64/ShellPkg/Application/Shell/Shell/OUTPUT/Shell.efi ../
popd

popd

