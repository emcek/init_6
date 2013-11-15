# Copyright 2011-2014 Andrey Ovcharov <sudormrfhalt@gmail.com>
# Distributed under the terms of the GNU General Public License v3
# $Header: $

# @ECLASS: geek-zfs.eclass
# @MAINTAINER:
# Andrey Ovcharov <sudormrfhalt@gmail.com>
# @AUTHOR:
# Original author: Andrey Ovcharov <sudormrfhalt@gmail.com> (12 Aug 2013)
# @BLURB: Eclass for building kernel with zfs patchset.
# @DESCRIPTION:
# This eclass provides functionality and default ebuild variables for building
# kernel with zfs patches easily.

# The latest version of this software can be obtained here:
# https://github.com/init6/init_6/blob/master/eclass/geek-zfs.eclass
# Bugs: https://github.com/init6/init_6/issues
# Wiki: https://github.com/init6/init_6/wiki/geek-sources

inherit geek-patch geek-utils geek-vars multilib

EXPORT_FUNCTIONS src_unpack src_prepare pkg_postinst

# @FUNCTION: init_variables
# @INTERNAL
# @DESCRIPTION:
# Internal function initializing all variables.
# We define it in function scope so user can define
# all the variables before and after inherit.
geek-zfs_init_variables() {
	debug-print-function ${FUNCNAME} "$@"

	: ${ZFS_VER:=${ZFS_VER:-master}}
	: ${ZFS_SRC:=${ZFS_SRC:-"git://github.com/zfsonlinux/zfs.git"}}
	: ${ZFS_URL:=${ZFS_URL:-"http://zfsonlinux.org"}}
	: ${ZFS_INF:=${ZFS_INF:-"${YELLOW}Integrate Native ZFS on Linux -${GREEN} ${ZFS_URL}${NORMAL}"}}
}

geek-zfs_init_variables

HOMEPAGE="${HOMEPAGE} ${ZFS_URL}"

LICENSE="${LICENSE} GPL-3"

DEPEND="${DEPEND}
	zfs?	( dev-vcs/git
		=sys-fs/zfs-9999[kernel-builtin(+)] )"

# @FUNCTION: src_unpack
# @USAGE:
# @DESCRIPTION: Extract source packages and do any necessary patching or fixes.
geek-zfs_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	local CTD="${T}/zfs"
	local CSD="${GEEK_STORE_DIR}/zfs"
	local CWD="${T}/zfs"
	shift

	if [ -d ${CSD} ]; then
	cd "${CSD}" || die "${RED}cd ${CSD} failed${NORMAL}"
		if [ -e ".git" ]; then # git
			git fetch --all && git pull --all
		fi
	else
		git clone "${ZFS_SRC}" "${CSD}" > /dev/null 2>&1; cd "${CSD}" || die "${RED}cd ${CSD} failed${NORMAL}"; git_get_all_branches
	fi

#	cp -r "${CSD}" "${CWD}" || die "${RED}cp -r ${CSD} ${CWD} failed${NORMAL}"
#	rsync -avhW --no-compress --progress "${CSD}/" "${CTD}" || die "${RED}rsync -avhW --no-compress --progress ${CSD}/ ${CTD} failed${NORMAL}"
	test -d "${CTD}" >/dev/null 2>&1 || mkdir -p "${CTD}"; (cd "${CSD}"; tar cf - .) | (cd "${CTD}"; tar xpf -)
	cd "${CWD}" || die "${RED}cd ${CWD} failed${NORMAL}"

	git_checkout "${ZFS_VER}" > /dev/null 2>&1 git pull > /dev/null 2>&1

	rm -rf "${CWD}"/.git || die "${RED}rm -rf ${CWD}/.git failed${NORMAL}"
}

# @FUNCTION: src_prepare
# @USAGE:
# @DESCRIPTION: Prepare source packages and do any necessary patching or fixes.
geek-zfs_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	local CWD="${T}/zfs"
	shift

	einfo "${ZFS_INF}"
	cd "${CWD}" || die "${RED}cd ${CWD} failed${NORMAL}"
	[ -e autogen.sh ] && ./autogen.sh > /dev/null 2>&1
	./configure \
		--prefix=$(PREFIX)/ \
		--libdir=$(PREFIX)/$(get_libdir) \
		--includedir=/usr/include \
		--datarootdir=/usr/share \
		--enable-linux-builtin=yes \
		--with-blkid \
		--with-linux=${S} \
		--with-linux-obj=${S} \
		--with-spl="${T}/spl" \
		--with-spl-obj="${T}/spl" > /dev/null 2>&1 || die "${RED}zfs ./configure failed${NORMAL}"
	./copy-builtin ${S} > /dev/null 2>&1 || die "${RED}zfs ./copy-builtin ${S} failed${NORMAL}"

	cd "${S}" || die "${RED}cd ${S} failed${NORMAL}"
	make mrproper > /dev/null 2>&1

	rm -rf "${T}/{spl,zfs}" || die "${RED}rm -rf ${T}/{spl,zfs} failed${NORMAL}"
}

# @FUNCTION: pkg_postinst
# @USAGE:
# @DESCRIPTION: Called after image is installed to ${ROOT}
geek-zfs_pkg_postinst() {
	debug-print-function ${FUNCNAME} "$@"

	einfo "${ZFS_INF}"
}
