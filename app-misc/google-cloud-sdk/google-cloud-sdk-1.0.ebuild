# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Wrapper for the Google cloud SDK."
HOMEPAGE="https://cloud.google.com/sdk/docs/install"
SLOT="0"
SRC_URI="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-101.0.0-linux-x86_64.tar.gz"

LICENSE="Google-Cloud-Platform"
SLOT="0"
KEYWORDS="~amd64"
S="${WORKDIR}/google-cloud-sdk"

src_unpack() {
	if [ ${A} != "" ]; then
		unpack ${A}
	fi
}

src_install() {
	dodir /usr/share/google-cloud-sdk
	cp -R "${S}/" "${D}/usr/share/" || die "Install failed!"
	dosym bin/gcloud /usr/bin/gcloud
	doman help/man/man1/*.1
}

pkg_postrm() {
	if [ -h /usr/bin/gcloud ]; then
		rm /usr/bin/gcloud
	fi
	if [ -h /usr/share/google-cloud-sdk ]; then
		rm -rf /usr/share/google-cloud-sdk
	fi
}
