#!/bin/bash

BUILD_VERSION="$1"
mkdir -p artifacts

if [ -d openwrt ]; then
  #find openwrt/bin -type f -name "*.img.gz" -exec sh -c 'dirname "$1"' _ {} \; | sort -u | xargs ls -al

  ## for x86_64
  find openwrt/bin -type f -name "*squashfs-combined-efi.img.gz" 2>/dev/null -exec bash -c '
    cp -v "$1" artifacts/${BUILD_VERSION}-$(basename "$1")
  ' _ {} \;
fi
