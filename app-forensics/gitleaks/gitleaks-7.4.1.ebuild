# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Detect and prevent secrets in git repos"
HOMEPAGE="https://github.com/zricethezav/gitleaks"
SRC_URI="https://github.com/zricethezav/gitleaks/releases/download/v${PV}/gitleaks-linux-amd64 -> gitleaks-linux-amd64-${PV}"
S="${WORKDIR}"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	dodir /opt/gitleaks
	cp "${DISTDIR}/gitleaks-linux-amd64-${PV}" "${WORKDIR}/gitleaks" || die "Copy failed!"
	fperms 0755 "gitleaks"
	cp "${WORKDIR}/gitleaks" "${D}/opt/gitleaks/gitleaks" || die "Install failed!"
	dosym ../../opt/gitleaks/gitleaks /usr/bin/gitleaks
}
