# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Calculate infrastructure costs"
HOMEPAGE="https://www.infracost.io/"
SLOT="0"
SRC_URI="https://github.com/infracost/infracost/releases/download/v${PV}/infracost-linux-amd64.tar.gz -> infracost-linux-amd64-${PV}.tar.gz"
LICENSE="Apache-2.0"
KEYWORDS="~amd64"
S="${WORKDIR}"

src_unpack() {
	if [ ${A} != "" ]; then
		unpack ${A}
	fi
}

src_install() {
	dodir /opt/infracost
	cp "${S}/infracost-linux-amd64" "${D}/opt/infracost/infracost" || die "Install failed!"
	dosym ../../opt/infracost/infracost /usr/bin/infracost
}
