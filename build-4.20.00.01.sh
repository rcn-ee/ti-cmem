#!/bin/bash

ARCH=$(uname -m)
branch="4.20.00.01"

if [ -f .builddir ] ; then
	if [ -d ./src ] ; then
		rm -rf ./src || true
	fi

	#http://git.ti.com/gitweb/?p=ipc/ludev.git;a=summary
	git clone -b ${branch} https://github.com/rcn-ee/ipc-ludev ./src --depth=1
	cd ./src/
	patch -p1 < ../../0001-debian-fno-PIE.patch
	cd ../

	if [ "x${ARCH}" = "xx86_64" ] ; then
		x86_dir="`pwd`/../../normal"
		if [ -f `pwd`/../../normal/.CC ] ; then
			. `pwd`/../../normal/.CC
			make_options="TOOLCHAIN_PREFIX=${CC} KERNEL_INSTALL_DIR=${x86_dir}/KERNEL release"
		fi
	else
		make_options="TOOLCHAIN_PREFIX= KERNEL_INSTALL_DIR=/build/buildd/linux-src release"
	fi

	cd ./src/src/cmem/module/

	make ARCH=arm ${make_options} clean
	echo "make ARCH=arm ${make_options}"
	make ARCH=arm ${make_options}
fi
#
