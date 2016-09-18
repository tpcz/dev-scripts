#!/bin/bash


AVAILABLE_PLATFORMS="ANDROID, ROUTER, RPI RPI2"

if [ $# -gt 0 ]; then
	TARGET=$1
else
	echo "Setting up for default platform - Android"
	TARGET=ANDROID
fi;


case "$TARGET" in

"ANDROID")
	export KERNELDIR=/home/tomaspop/workspaces/cyanogenmod-12/obj/KERNEL_OBJ/
	export ARCH=arm
	export CROSS_COMPILE=/opt/toolchains/arm-eabi-4.8/bin/arm-eabi-
;;

"ROUTER")
	export STAGING_DIR=/home/pop/workspaces/openWRT/openwrt/staging_dir
	export KERNELDIR=/home/pop/workspaces/openWRT/openwrt/build_dir/target-mips_34kc_uClibc-0.9.33.2/linux-ar71xx_generic/linux-3.10.49
	export CROSS_COMPILE=/home/pop/workspaces/openWRT/openwrt/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/bin/mips-openwrt-linux-uclibc-
	export ARCH=mips
 echo "Setting up for TP-link openWRT router (" $TARGET ")"
;;

"RPI")
 echo "Setting up for RPI (" $TARGET ")"
	export KERNELDIR=/home/`whoami`/workspaces/rpi1/linux
	export ARCH=arm
	export CROSS_COMPILE=/home/`whoami`/workspaces/rpi1/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf-
;;

"RPI2")
 echo "Setting up for RPI2 (" $TARGET ")"
	export KERNELDIR=/home/`whoami`/workspaces/rpi2/linux
	export ARCH=arm
	export CROSS_COMPILE=/home/`whoami`/workspaces/rpi2/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf-
;;


*)
 echo "Unknown platform. Available are: " $AVAILABLE_PLATFORMS
;;
esac
