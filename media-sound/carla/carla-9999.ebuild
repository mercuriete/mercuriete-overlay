# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Original ebuild from audio-overlay: https://github.com/gentoo-audio/audio-overlay

EAPI=8

PYTHON_COMPAT=( python3_{11,12,13,14} )

inherit python-single-r1 xdg-utils
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/falkTX/Carla.git"
else
	SRC_URI="https://github.com/falkTX/Carla/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/Carla-${PV}"
fi

DESCRIPTION="Fully-featured audio plugin host with support for many drivers and formats"
HOMEPAGE="https://kx.studio/Applications:Carla"

LICENSE="GPL-2 LGPL-3"
SLOT="0"
if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64"
fi

IUSE="alsa gtk gtk2 opengl osc pulseaudio rdf sf2 sndfile X"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	virtual/pkgconfig
"

DEPEND="
	${PYTHON_DEPS}
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	media-libs/libsndfile
	alsa? ( media-libs/alsa-lib )
	gtk? (
		gtk2? ( x11-libs/gtk+:2 )
		!gtk2? ( x11-libs/gtk+:3 )
	)
	opengl? ( virtual/opengl )
	osc? ( media-libs/liblo )
	pulseaudio? ( media-libs/libpulse )
	rdf? ( media-libs/lilv )
	sf2? ( media-sound/fluidsynth )
	sndfile? ( media-libs/libsndfile )
	X? ( x11-libs/libX11 )
"

RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		dev-python/pyqt5[${PYTHON_USEDEP}]
	')
"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	default
	# Fix Python shebangs
	python_fix_shebang .
}

src_compile() {
	local myemakeargs=(
		HAVE_ALSA=$(usex alsa true false)
		HAVE_PULSEAUDIO=$(usex pulseaudio true false)
		HAVE_X11=$(usex X true false)
		HAVE_LIBLO=$(usex osc true false)
		HAVE_FLUIDSYNTH=$(usex sf2 true false)
		HAVE_SNDFILE=$(usex sndfile true false)
		HAVE_LILV=$(usex rdf true false)
		PREFIX="${EPREFIX}/usr"
	)

	if use gtk; then
		if use gtk2; then
			myemakeargs+=( HAVE_GTK2=true HAVE_GTK3=false )
		else
			myemakeargs+=( HAVE_GTK2=false HAVE_GTK3=true )
		fi
	else
		myemakeargs+=( HAVE_GTK2=false HAVE_GTK3=false )
	fi

	emake "${myemakeargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
