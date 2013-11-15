# Copyright 2011-2014 Andrey Ovcharov <sudormrfhalt@gmail.com>
# Distributed under the terms of the GNU General Public License v3
# $Header: $

# @ECLASS: geek-vars.eclass
# @MAINTAINER:
# Andrey Ovcharov <sudormrfhalt@gmail.com>
# @AUTHOR:
# Original author: Andrey Ovcharov <sudormrfhalt@gmail.com> (14 Nov 2013)
# @BLURB: The geek-vars eclass defines some default variables.
# @DESCRIPTION:
# The geek-vars eclass defines some default variables.

# The latest version of this software can be obtained here:
# https://github.com/init6/init_6/blob/master/eclass/geek-vars.eclass
# Bugs: https://github.com/init6/init_6/issues
# Wiki: https://github.com/init6/init_6/wiki/geek-sources

EXPORT_FUNCTIONS init_variables

set_color() {
	: ${BR:=${BR:-"\x1b[0;01m"}}
	#: ${BLUEDARK:=${BLUEDARK:-"\x1b[34;0m"}}
	: ${BLUE:=${BLUE:-"\x1b[34;01m"}}
	#: ${CYANDARK:=${CYANDARK:-"\x1b[36;0m"}}
	: ${CYAN:=${CYAN:-"\x1b[36;01m"}}
	#: ${GRAYDARK:=${GRAYDARK:-"\x1b[30;0m"}}
	#: ${GRAY:=${GRAY:-"\x1b[30;01m"}}
	#: ${GREENDARK:=${GREENDARK:-"\x1b[32;0m"}}
	: ${GREEN:=${GREEN:-"\x1b[32;01m"}}
	#: ${LIGHT:=${LIGHT:-"\x1b[37;01m"}}
	#: ${MAGENTADARK:=${MAGENTADARK:-"\x1b[35;0m"}}
	#: ${MAGENTA:=${MAGENTA:-"\x1b[35;01m"}}
	: ${NORMAL:=${NORMAL:-"\x1b[0;0m"}}
	#: ${REDDARK:=${REDDARK:-"\x1b[31;0m"}}
	: ${RED:=${RED:-"\x1b[31;01m"}}
	: ${YELLOW:=${YELLOW:-"\x1b[33;01m"}}
}

# @FUNCTION: init_variables
# @INTERNAL
# @DESCRIPTION:
# Internal function initializing all variables.
# We define it in function scope so user can define
# all the variables before and after inherit.
geek-vars_init_variables() {
	debug-print-function ${FUNCNAME} "$@"

	OLDIFS="$IFS"
	VER="${PV}"
	IFS='.'
	set -- ${VER}
	IFS="${OLDIFS}"

	# the kernel version (e.g 3 for 3.4.2)
	VERSION="${1}"
	# the kernel patchlevel (e.g 4 for 3.4.2)
	PATCHLEVEL="${2}"
	# the kernel sublevel (e.g 2 for 3.4.2)
	SUBLEVEL="${3}"
	# the kernel major version (e.g 3.4 for 3.4.2)
	KMV="${1}.${2}"

	: ${cfg_file:="/etc/portage/kernel.conf"}

	: ${GEEK_STORE_DIR:=${GEEK_STORE_DIR:-"${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}/geek"}}
	addwrite "${GEEK_STORE_DIR}" # Disable the sandbox for this dir

	: ${PATCH_STORE_DIR:=${PATCH_STORE_DIR:-"/etc/portage/patches/sys-kernel"}}
	: ${PATCH_USER_DIR:=${PATCH_USER_DIR:-"${PATCH_STORE_DIR}/${PN}/${PV}"}}

	# Color
	local use_colors_cfg=$(source $cfg_file 2>/dev/null; echo ${use_colors})
	: ${use_colors:=${use_colors_cfg:-yes}} # use_colors=yes/no
	check_for_color
}

check_for_color() {
	if [[ ! ${use_colors} == no ]]; then
		set_color
	fi
}

geek-vars_init_variables
