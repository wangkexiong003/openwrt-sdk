#!/bin/bash

mkdir -p artifacts
mkdir -p ipks_feed

if [ -d openwrt ]; then
  ## Helloworld requires dnsmasq-full with ipset and nftset support
  find openwrt/bin/packages -type f -name "dnsmasq-full*.ipk" -exec cp -v {} artifacts \;

  FEED_SOURCE=$(awk '{print $2}' ${GITHUB_WORKSPACE}/config/package/feeds.conf | paste -sd ' ' | xargs)
  FEED_REGEXP=$(echo "${FEEDS_SOURCE}" | sed 's/ /\|/g')
  for ipk in $(find openwrt/bin -name *.ipk); do
    src=$(tar -xOf ${ipk} ./control.tar.gz | tar -xzOf - ./control | grep '^Source:' | awk -F: '{print $2}' | xargs)
    feed=$(echo "${src}" | cut -d'/' -f2)
    if echo "${feed}" | grep -Eq "^(${FEED_REGEXP})$"; then
      echo "+++ copy ${ipk} in ${feed}"
      mkdir -p "ipks_feed/${feed}"
      cp "${ipk}" "ipks_feed/${feed}"
      cp "${ipk}" artifacts
    fi
  done
fi

find ipks_feed -type f -name "*.ipk"