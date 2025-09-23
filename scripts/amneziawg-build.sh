#!/bin/bash
set -e

# Configuration
OPENWRT_VERSION="24.10.2"
TARGET="rockchip/armv8"
ARCH="aarch64_generic"

# Clone OpenWrt if not exists
if [ ! -d "openwrt" ]; then
    git clone https://git.openwrt.org/openwrt/openwrt.git
    cd openwrt
    git checkout v$OPENWRT_VERSION
else
    cd openwrt
    git fetch
    git checkout v$OPENWRT_VERSION
fi

# Add AmneziAWG package
if [ ! -d "package/amneziawg" ]; then
    git clone https://github.com/amnezia-vpn/amneziawg-openwrt.git package/amneziawg
fi

# Update feeds
./scripts/feeds update -a
./scripts/feeds install -a

# Configure build
cat > .config <<EOF
CONFIG_TARGET_rockchip=y
CONFIG_TARGET_rockchip_armv8=y
CONFIG_TARGET_MULTI_PROFILE=y
CONFIG_TARGET_ALL_PROFILES=y
CONFIG_PACKAGE_amneziawg=y
EOF

make defconfig

# Build
make package/amneziawg/compile -j$(nproc) V=s

# Copy artifacts
mkdir -p ../artifacts
cp bin/packages/$ARCH/base/amneziawg_*.ipk ../artifacts/
cp logs/package/amneziawg ../artifacts/build.log

echo "Build completed. Packages available in artifacts directory."
