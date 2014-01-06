# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Squashed portage tree"
HOMEPAGE="https://github.com/init6/squashed-portage"
SRC_URI="https://github.com/init6/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE="systemd"
RESTRICT="mirror"

DEPEND="app-shells/bash
	sys-apps/portage
	sys-libs/core-functions
	sys-fs/squashfs-tools"

src_install(){
	insinto /etc/
	newins squashed-portage.conf squashed-portage.conf
	dosbin squashed-portage
	if use systemd; then
		systemd_dounit portage.service
	fi
}

pkg_postinst() {
	elog "For further information and migration steps make sure to read"
	elog "https://github.com/init6/init_6/wiki/squashed-portage-tree"
}
