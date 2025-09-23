#!/bin/bash

# Set variables
OPENWRT_VERSION="24.10.2"
TARGET_ARCH="aarch64_generic"
KERNEL_VERSION="6.6.93"

# Update system and install dependencies
sudo apt-get update
sudo apt-get install -y \
    build-essential \
    clang \
    flex \
    bison \
    g++ \
    gawk \
    gcc-multilib \
    g++-multilib \
    gettext \
    git \
    libncurses5-dev \
    libssl-dev \
    python3-distutils \
    rsync \
    unzip \
    zlib1g-dev \
    file \
    wget

# Clone OpenWrt
if [ ! -d "openwrt" ]; then
    git clone https://git.openwrt.org/openwrt/openwrt.git
    cd openwrt
    git checkout v${OPENWRT_VERSION}
else
    echo "OpenWrt directory already exists"
fi

# Clone AmenziaWG
if [ ! -d "openwrt/package/amneziawg" ]; then
    git clone https://github.com/amnezia-vpn/amneziawg-openwrt.git openwrt/package/amneziawg
else
    echo "AmenziaWG package already exists"
fi

# Update feeds
cd openwrt
./scripts/feeds update -a
./scripts/feeds install -a

echo "Build environment prepared successfully"
