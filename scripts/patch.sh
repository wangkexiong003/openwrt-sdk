#!/usr/bin/env bash

OPENWRT_SDK="$1"

## remove identation checking for openappfilter
#
OAF_MAKEFILE="${OPENWRT_SDK}/feeds/openappfilter/oaf/Makefile"
if [ -f "${OAF_MAKEFILE}" ]; then
  echo "+++++ patch file: ${OAF_MAKEFILE}"
  sed -i '/^EXTRA_CFLAGS:=/ s|$| -Wno-misleading-indentation|' "${OAF_MAKEFILE}"
fi
