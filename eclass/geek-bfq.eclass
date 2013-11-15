# Copyright 2011-2014 Andrey Ovcharov <sudormrfhalt@gmail.com>
# Distributed under the terms of the GNU General Public License v3
# $Header: $

# @ECLASS: geek-bfq.eclass
# @MAINTAINER:
# Andrey Ovcharov <sudormrfhalt@gmail.com>
# @AUTHOR:
# Original author: Andrey Ovcharov <sudormrfhalt@gmail.com> (12 Aug 2013)
# @BLURB: Eclass for building kernel with bfq patchset.
# @DESCRIPTION:
# This eclass provides functionality and default ebuild variables for building
# kernel with bfq patches easily.

# The latest version of this software can be obtained here:
# https://github.com/init6/init_6/blob/master/eclass/geek-bfq.eclass
# Bugs: https://github.com/init6/init_6/issues
# Wiki: https://github.com/init6/init_6/wiki/geek-sources

inherit geek-patch geek-utils geek-vars

EXPORT_FUNCTIONS src_unpack src_prepare pkg_postinst

# @FUNCTION: init_variables
# @INTERNAL
# @DESCRIPTION:
# Internal function initializing all variables.
# We define it in function scope so user can define
# all the variables before and after inherit.
geek-bfq_init_variables() {
	debug-print-function ${FUNCNAME} "$@"

	: ${BFQ_VER:=${BFQ_VER:-$KMV}}
	: ${BFQ_SRC:=${BFQ_SRC:-"http://algo.ing.unimo.it/people/paolo/disk_sched/patches"}}
	: ${BFQ_URL:=${BFQ_URL:-"http://algo.ing.unimo.it/people/paolo/disk_sched/"}}
	: ${BFQ_INF:=${BFQ_INF:-"${YELLOW}Budget Fair Queueing Budget I/O Scheduler -${GREEN} ${BFQ_URL}${NORMAL}"}}
}

geek-bfq_init_variables

HOMEPAGE="${HOMEPAGE} ${BFQ_URL}"

# @FUNCTION: src_unpack
# @USAGE:
# @DESCRIPTION: Extract source packages and do any necessary patching or fixes.
geek-bfq_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	local CWD="${T}/bfq"
	shift
	test -d "${CWD}" >/dev/null 2>&1 && cd "${CWD}" || mkdir -p "${CWD}"; cd "${CWD}"

	get_from_url "${BFQ_SRC}" "${BFQ_VER}" > /dev/null 2>&1

	ls -1 "${CWD}" | grep ".patch" > "${CWD}"/patch_list
}

# @FUNCTION: src_prepare
# @USAGE:
# @DESCRIPTION: Prepare source packages and do any necessary patching or fixes.
geek-bfq_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	ApplyPatch "${T}/bfq/patch_list" "${BFQ_INF}"
	mv "${T}/bfq" "${WORKDIR}/linux-${KV_FULL}-patches/bfq" || die "${RED}mv ${T}/bfq ${WORKDIR}/linux-${KV_FULL}-patches/bfq failed${NORMAL}"
#	rsync -avhW --no-compress --progress "${T}/bfq/" "${WORKDIR}/linux-${KV_FULL}-patches/bfq" || die "${RED}rsync -avhW --no-compress --progress ${T}/bfq/ ${WORKDIR}/linux-${KV_FULL}-patches/bfq failed${NORMAL}"

	local BFQ_FIX_PATCH_DIR="${PATCH_STORE_DIR}/${PN}/${PV}/bfq"
	test -d "${BFQ_FIX_PATCH_DIR}" >/dev/null 2>&1 && ApplyUserPatch "${BFQ_FIX_PATCH_DIR}" "${YELLOW}Applying user fixes for bfq patchset from${NORMAL} ${GREEN} ${BFQ_FIX_PATCH_DIR}${NORMAL}" #|| einfo "${RED}Skipping apply user fixes for bfq patchset from not existing${GREEN} ${BFQ_FIX_PATCH_DIR}!${NORMAL}"
	local BFQ_FIX_PATCH_DIR="${PATCH_STORE_DIR}/${PN}/bfq"
	test -d "${BFQ_FIX_PATCH_DIR}" >/dev/null 2>&1 && ApplyUserPatch "${BFQ_FIX_PATCH_DIR}" "${YELLOW}Applying user fixes for bfq patchset from${NORMAL} ${GREEN} ${BFQ_FIX_PATCH_DIR}${NORMAL}" #|| einfo "${RED}Skipping apply user fixes for bfq patchset from not existing${GREEN} ${BFQ_FIX_PATCH_DIR}!${NORMAL}"
}

# @FUNCTION: pkg_postinst
# @USAGE:
# @DESCRIPTION: Called after image is installed to ${ROOT}
geek-bfq_pkg_postinst() {
	debug-print-function ${FUNCNAME} "$@"

	einfo "${BFQ_INF}"
}
