#!/bin/bash

mkdir -p artifacts
if [ -d openwrt ]; then
  find openwrt/bin -type f -name "*.img.gz" -exec sh -c 'dirname "$1"' _ {} \; | sort -u | xargs ls -al

  find openwrt/bin -type f -name "*squashfs-combined-efi.img.gz" -exec cp {} artifacts \;
fi
