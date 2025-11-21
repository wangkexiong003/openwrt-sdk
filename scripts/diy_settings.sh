#!/bin/bash

## br-lan ip from default 192.168.1.1 to 192.168.56.2
sed -i 's/192.168.1.1/192.168.56.2/g' package/base-files/files/bin/config_generate
