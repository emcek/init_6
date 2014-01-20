# Copyright 2009-2014 Andrey Ovcharov <sudormrfhalt@gmail.com>
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-base subversion

S=${WORKDIR}/gnustep-back-${PV}

DESCRIPTION="libart_lgpl back-end component for the GNUstep GUI Library"
HOMEPAGE="http://www.gnustep.org"
SRC_URI=""

ESVN_REPO_URI="http://svn.gna.org/svn/gnustep/libs/back/trunk/"
ESVN_PROJECT="gnustep-back"

KEYWORDS="~alpha amd64 ppc ~sparc x86"
SLOT="0"
LICENSE="LGPL-2.1"

IUSE="opengl xim"

DEPEND="${GNUSTEP_CORE_DEPEND}
	~gnustep-base/gnustep-gui-${PV}
	opengl? ( virtual/opengl virtual/glu )
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXft
	x11-libs/libXrender
	dev-libs/expat
	media-libs/fontconfig
	>=media-libs/freetype-2.1.9
	>=media-libs/libart_lgpl-2.3
	>=gnustep-base/mknfonts-0.5-r1
	media-fonts/dejavu
	!gnustep-base/gnustep-back-cairo
	!gnustep-base/gnustep-back-xlib"
RDEPEND="${DEPEND}"

src_compile() {
	egnustep_env

	use opengl && myconf="--enable-glx"
	myconf="$myconf `use_enable xim`"
	myconf="$myconf --enable-server=x11"
	myconf="$myconf --enable-graphics=art"
	econf $myconf || die "configure failed"

	egnustep_make

	# Create font lists for DejaVu
	einfo "Generating nfonts support files"
	cd Fonts
	${GNUSTEP_SYSTEM_TOOLS}/mknfonts \
		$(fc-list : file|grep -v '\.gz'|cut -d: -f1) \
		|| die "nfonts support files creation failed"
	# Trim whitepsaces
	for fdir in *\ */; do
		mv "$fdir" `echo $fdir | tr -d [:space:]`
	done
}

src_install() {
	egnustep_env

	gnustep-base_src_install

	mkdir -p "${D}/${GNUSTEP_SYSTEM_LIBRARY}/Fonts"
	cp -pPR Fonts/*.nfont "${D}/${GNUSTEP_SYSTEM_LIBRARY}/Fonts"
}

gnustep_config_script() {
	echo "echo ' * setting normal font to DejaVuSans'"
	echo "defaults write NSGlobalDomain NSFont DejaVuSans"
	echo "echo ' * setting bold font to DejaVuSans-Bold'"
	echo "defaults write NSGlobalDomain NSBoldFont DejaVuSans-Bold"
	echo "echo ' * setting fixed font to DejaVuSansMono'"
	echo "defaults write NSGlobalDomain NSUserFixedPitchFont DejaVuSansMono"
}