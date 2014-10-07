# Copyright 2009-2014 Andrey Ovcharov <sudormrfhalt@gmail.com>
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Virtual for Linux kernel sources"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE="hardened"

DEPEND=""
RDEPEND="|| (
		hardened? ( sys-kernel/hardened-sources )
		sys-kernel/sysrescue-std-sources
		sys-kernel/debian-sources
		sys-kernel/openvz-rhel5-stable
		sys-kernel/openvz-rhel6-stable
		sys-kernel/openvz-rhel6-test
		sys-kernel/gentoo-sources
		sys-kernel/vanilla-sources
		sys-kernel/cell-sources
		sys-kernel/ck-sources
		sys-kernel/git-sources
		sys-kernel/hardened-sources
		sys-kernel/mips-sources
		sys-kernel/mm-sources
		sys-kernel/openvz-sources
		sys-kernel/pf-sources
		sys-kernel/rsbac-sources
		sys-kernel/rt-sources
		sys-kernel/tuxonice-sources
		sys-kernel/usermode-sources
		sys-kernel/vserver-sources
		sys-kernel/xbox-sources
		sys-kernel/xen-sources
		sys-kernel/zen-sources
		sys-kernel/rh-sources
		sys-kernel/geek-sources
	)"
