#!/bin/bash
# Copyright cc 2022 anothermi

# init
function init() {
    echo "==========================="
    echo "= START COMPILING KERNEL  ="
    echo "==========================="
}
# Main 
function compile() {
    export PATH="/home/romiyusnandar/toolchains/proton-clang/bin:$PATH"
    make -j$(nproc --all) O=out ARCH=arm64 <DEVICE>_defconfig
    make -j$(nproc --all) ARCH=arm64 O=out \
                          CC=clang \
                          CROSS_COMPILE=aarch64-linux-gnu- \
                          CROSS_COMPILE_ARM32=arm-linux-gnueabi-
}
#end
function ended(){
    echo "==========================="
    echo "   COPILE KERNEL COMPLETE  "
    echo "==========================="
}

# execute
init
compile
ended
