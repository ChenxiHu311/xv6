#!/bin/bash
set -e

echo "Updating system..."
sudo apt update -y
sudo apt upgrade -y

echo "Installing required packages..."
sudo apt install -y \
    build-essential \
    gcc \
    g++ \
    gdb-multiarch \
    make \
    python3 \
    python3-pip \
    git \
    curl \
    wget \
    unzip \
    libglib2.0-dev \
    libfdt-dev \
    libpixman-1-dev \
    zlib1g-dev \
    ninja-build \
    pkg-config \
    autoconf \
    automake \
    libtool

echo "Installing RISC-V GNU Toolchain (prebuilt)..."

sudo apt install -y gcc-riscv64-unknown-elf binutils-riscv64-unknown-elf || {
    echo "Ubuntu repo does not have riscv64-unknown-elf toolchain; installing from SiFive prebuilt package..."
    
    wget -q https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-2021.07.07-x86_64-linux-ubuntu14.tar.gz
    tar -xzf riscv64-unknown-elf-gcc-2021.07.07-x86_64-linux-ubuntu14.tar.gz
    sudo mv riscv64-unknown-elf-gcc-2021.07.07-x86_64-linux-ubuntu14 /opt/riscv
    echo 'export PATH=/opt/riscv/bin:$PATH' >> ~/.bashrc
    export PATH=/opt/riscv/bin:$PATH
}

echo "Installing QEMU (with RISC-V support)..."
sudo apt install -y qemu-system-misc || {

    echo "Fallback: building QEMU from source"
    git clone https://github.com/qemu/qemu.git
    cd qemu
    ./configure --target-list=riscv64-softmmu
    make -j$(nproc)
    sudo make install
    cd ..
}

echo "Checking installs..."

command -v riscv64-unknown-elf-gcc >/dev/null || echo "❌ RISC-V GCC missing"
command -v qemu-system-riscv64 >/dev/null || echo "❌ QEMU riscv64 missing"

echo ""
echo "=============================="
echo "🎉 All tools installed for xv6!"
echo "=============================="
echo "Try: cd xv6-riscv && make"