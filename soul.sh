#!/bin/bash

WALLET="49xs4gWaPLWFzkLbmFgBdm9V9ZU2rf7djF7kUVE11seJgyLEt6GekKpTVhugLXD8tq7gHoMtiqBRj7TsVWdKN5m6Kshxpsv"
POOL="sg.minexmr.com:4444"
WORKER="worker"

echo "[+] Starting setup..."

install_dependencies() {
    echo "[+] Installing required packages..."
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install -y git build-essential cmake automake libtool autoconf libhwloc-dev libuv1-dev libssl-dev msr-tools
}

build_xmrig() {
    echo "[+] Cloning XMRig repository..."
    git clone https://github.com/xmrig/xmrig.git
    cd xmrig
    mkdir build && cd build
    echo "[+] Building XMRig, please wait..."
    cmake ..
    make -j$(nproc)
}

start_mining() {
    echo "[+] Waiting for 180 seconds before starting mining (sleep)..."
    sleep 180
    echo "[+] Starting XMRig miner now!"
    ./xmrig -o $POOL -u $WALLET -p $WORKER -k --coin monero
}

if [ -d "xmrig" ]; then
    echo "[+] XMRig directory found. Skipping clone."
    cd xmrig/build
else
    install_dependencies
    build_xmrig
fi

start_mining
