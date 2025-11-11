#!/bin/bash

## Update golang and rust to latest version for openwrt building
rm -rf temp_resp

git clone -b master --single-branch https://github.com/openwrt/packages.git temp_resp
rm -rf feeds/packages/lang/golang
cp -r temp_resp/lang/golang feeds/packages/lang
rm -rf feeds/packages/lang/rust
cp -r temp_resp/lang/rust feeds/packages/lang

rm -rf temp_resp

if [ -f feeds/packages/lang/rust/Makefile ]; then
  ## https://github.com/openwrt/packages/pull/27487
  # The scripts/patch-kernel.sh script will simply remove all files suffixed with .orig,
  # and it breaks rust's integrity check as these files actually come with upstream tarball.
  if ! grep -q '^define Host/Patch' feeds/packages/lang/rust/Makefile; then
    patch feeds/packages/lang/rust/Makefile ${GITHUB_WORKSPACE}/patch/fix4rust-PR27487.patch
  fi

  ## GITHUB action environment has CI like variable set to true.
  # the pre-compiled llvm is forbidden to use by rust build system in CI environment.
  sed -i 's/\(--set=llvm.download-ci-llvm=\)true/\1false/' feeds/packages/lang/rust/Makefile
fi
