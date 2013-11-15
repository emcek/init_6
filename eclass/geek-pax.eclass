# Copyright 2011-2014 Andrey Ovcharov <sudormrfhalt@gmail.com>
# Distributed under the terms of the GNU General Public License v3
# $Header: $

# @ECLASS: geek-pax.eclass
# @MAINTAINER:
# Andrey Ovcharov <sudormrfhalt@gmail.com>
# @AUTHOR:
# Original author: Andrey Ovcharov <sudormrfhalt@gmail.com> (12 Aug 2013)
# @BLURB: Eclass for building kernel with pax patchset.
# @DESCRIPTION:
# This eclass provides functionality and default ebuild variables for building
# kernel with pax patches easily.

# The latest version of this software can be obtained here:
# https://github.com/init6/init_6/blob/master/eclass/geek-pax.eclass
# Bugs: https://github.com/init6/init_6/issues
# Wiki: https://github.com/init6/init_6/wiki/geek-sources

inherit geek-patch geek-utils geek-vars

EXPORT_FUNCTIONS src_prepare pkg_postinst

# @FUNCTION: init_variables
# @INTERNAL
# @DESCRIPTION:
# Internal function initializing all variables.
# We define it in function scope so user can define
# all the variables before and after inherit.
geek-pax_init_variables() {
	debug-print-function ${FUNCNAME} "$@"

	: ${PAX_VER:=${PAX_VER:-$KMV}}
	: ${PAX_SRC:=${PAX_SRC:-"http://grsecurity.net/test/pax-linux-${PAX_VER/KMV/$KMV}.patch"}}
	: ${PAX_URL:=${PAX_URL:-"http://pax.grsecurity.net"}}
	: ${PAX_INF=${PAX_INF:-"${YELLOW}PAX patches -${GREEN} ${PAX_URL}${NORMAL}"}}
}

geek-pax_init_variables

HOMEPAGE="${HOMEPAGE} ${PAX_URL}"

SRC_URI="${SRC_URI}
	pax?	( ${PAX_SRC} )"

# @FUNCTION: src_prepare
# @USAGE:
# @DESCRIPTION: Prepare source packages and do any necessary patching or fixes.
geek-pax_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	ApplyPatch "${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/pax-linux-${PAX_VER/KMV/$KMV}.patch" "${PAX_INF}"

	local PAX_FIX_PATCH_DIR="${PATCH_STORE_DIR}/${PN}/${PV}/pax"
	test -d "${PAX_FIX_PATCH_DIR}" >/dev/null 2>&1 && ApplyUserPatch "${PAX_FIX_PATCH_DIR}" "${YELLOW}Applying user fixes for pax patchset from${NORMAL} ${GREEN} ${PAX_FIX_PATCH_DIR}${NORMAL}" #|| einfo "${RED}Skipping apply user fixes for pax patchset from not existing${GREEN} ${PAX_FIX_PATCH_DIR}!${NORMAL}"
	local PAX_FIX_PATCH_DIR="${PATCH_STORE_DIR}/${PN}/pax"
	test -d "${PAX_FIX_PATCH_DIR}" >/dev/null 2>&1 && ApplyUserPatch "${PAX_FIX_PATCH_DIR}" "${YELLOW}Applying user fixes for pax patchset from${NORMAL} ${GREEN} ${PAX_FIX_PATCH_DIR}${NORMAL}" #|| einfo "${RED}Skipping apply user fixes for pax patchset from not existing${GREEN} ${PAX_FIX_PATCH_DIR}!${NORMAL}"
}

# @FUNCTION: pkg_postinst
# @USAGE:
# @DESCRIPTION: Called after image is installed to ${ROOT}
geek-pax_pkg_postinst() {
	debug-print-function ${FUNCNAME} "$@"

	einfo "${PAX_INF}"
}
