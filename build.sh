#!/bin/bash

ARCH=$(uname -m)
branch="4.12.00.00"

if [ -f .builddir ] ; then
	if [ -d ./src ] ; then
		rm -rf ./src || true
	fi

	git clone -b ${branch} git://git.ti.com/ipc/ludev.git ./src --depth=1

	x86_dir="/opt/github/bb.org/ti-4.4/normal"
	x86_compiler="gcc-linaro-4.9-2016.02-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-"

	if [ "x${ARCH}" = "xarmv7l" ] ; then
		make_options="TOOLCHAIN_PREFIX= KERNEL_INSTALL_DIR=/build/buildd/linux-src release"
	else
		make_options="TOOLCHAIN_PREFIX=/home/voodoo/dl/gcc/${x86_compiler} KERNEL_INSTALL_DIR=${x86_dir}/KERNEL release"
	fi

	cd ./src/src/cmem/module/

	make ARCH=arm ${make_options} clean
	echo "make ARCH=arm ${make_options}"
	make ARCH=arm ${make_options}
fi
#
