#!/bin/bash

cat <<'EOF' >> .config
CONFIG_PACKAGE_boost=y
CONFIG_PACKAGE_boost-filesystem=y
CONFIG_PACKAGE_boost-program_options=y
EOF

make defconfig
