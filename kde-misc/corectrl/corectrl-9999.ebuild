# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit ecm linux-info optfeature xdg-utils

DESCRIPTION="Core control application"
HOMEPAGE="https://gitlab.com/corectrl/corectrl"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/corectrl/corectrl.git"
else
	SRC_URI="https://gitlab.com/corectrl/corectrl/-/archive/v${PV}/corectrl-v${PV}.tar.bz2"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-v${PV}"
fi

LICENSE="GPL-3"
SLOT="0"

IUSE="test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/botan:=
	dev-libs/pugixml
	dev-libs/spdlog:=
	>=dev-libs/quazip-1.3:=[qt6]
	dev-qt/qtbase:6[dbus,gui,network,widgets]
	dev-qt/qtcharts:6[qml]
	dev-qt/qtdeclarative:6
	sys-auth/polkit[introspection]
"
DEPEND="${COMMON_DEPEND}
	dev-qt/qttools:6[linguist]
	dev-qt/qtsvg:6
	x11-libs/libdrm[video_cards_amdgpu]
	test? (
		>=dev-cpp/catch-3.5.2
	)
"

RDEPEND="${COMMON_DEPEND}
	dev-libs/glib
	dev-libs/libfmt:=
	dev-qt/qtdeclarative:6[widgets]
	sys-apps/hwdata
"

BDEPEND="
	virtual/pkgconfig
"

CONFIG_CHECK="~KALLSYMS"

pkg_pretend() {
	check_extra_config

	if use test; then
		local kernel_version=$(uname -r)
		if [[ ${kernel_version} == *microsoft* ]]; then
			elog "Tests are known to fail on WSL. Disabling tests is recommended."
		fi
	fi
}

pkg_postinst() {
	optfeature "per-application profiles" x11-apps/mesa-progs
	optfeature "per-application profiles" app-misc/vulkan-tools
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
