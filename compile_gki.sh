#!/bin/bash
#
# Copyright (C) 2023 sirNewbies
#

# init
WORK_DIR=$(pwd)
ANYKERNEL=$WORK_DIR/anykernel
ANYKERNEL_REPO="https://github.com/sirnewbies/Anykernel3.git" 
ANYKERNEL_BRANCH="topaz"
KERNEL_DIR="topaz"

# VERSIONING
REL="v1.6"
KERNEL="QuantumCharge-topaz-tapas-$REL"
ZIPNAME=$KERNEL.zip
KERN_IMG=$WORK_DIR/out/android13-5.15/dist/Image

# setup telegram
CHATIDQ="-1001930168269"
CHATID="-1001930168269" # Group/channel chatid (use rose/userbot to get it)
TELEGRAM_TOKEN="5136791856:AAGY5TeaVoeJbd6a2BAlxAjOc-MFWOJzZds" # Get from botfather

# setup color
red='\033[0;31m'
green='\e[0;32m'
white='\033[0m'
yellow='\033[0;33m'

function clean() {
    echo -e "$red << cleaning up... >> \n$white"
    rm -rf $ANYKERNEL out
}

function update_ksu() {
    echo -e "$yellow << updateing kernelsu.. >> \n$white"
    cd $KERNEL_DIR || exit
    ./update_ksu.sh
}

function pack_kernel() {
    echo -e "$yellow << packing kernel... >> \n$white"

    TELEGRAM_FOLDER="${HOME}"/workspaces/telegram
    if ! [ -d "${TELEGRAM_FOLDER}" ]; then
        git clone https://github.com/sirnewbies/telegram.sh/ "${TELEGRAM_FOLDER}"
    fi

    TELEGRAM="${TELEGRAM_FOLDER}"/telegram

    git clone "$ANYKERNEL_REPO" -b "$ANYKERNEL_BRANCH" "$ANYKERNEL"

    cp $KERN_IMG $ANYKERNEL/Image
    cd $ANYKERNEL || exit
    zip -r9 $ZIPNAME ./*

    $TELEGRAM -f $ZIPNAME -t $TELEGRAM_TOKEN -c $CHATIDQ

    echo -e "$green << kernel uploaded to telegram >>"
}

function build_kernel() {
    echo -e "$yrllow << building kernel... >> \n$white"
    cd $WORK_DIR
    LTO=thin BUILD_CONFIG=$KERNEL_DIR/build.config.gki.aarch64 build/build.sh

    if [ -e "$KERN_IMG" ]; then
        echo -e "$green << compile kernel success! >> \n$white"
        pack_kernel
    else
        echo -e "$red << compile kernel failed! >> \n$white"
    fi
}

# exe
clean
update_ksu
build_kernel
