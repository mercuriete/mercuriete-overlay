# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A tool for building, changing, and combining infrastructure safely"
HOMEPAGE="https://www.terraform.io/"
SLOT="0"
SRC_URI="https://releases.hashicorp.com/terraform/${PV}/terraform_${PV}_linux_amd64.zip"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
S="${WORKDIR}"

DEPEND="app-arch/unzip"

src_unpack() {
	if [ ${A} != "" ]; then
		unpack ${A}
	fi
}

src_install() {
	dodir /opt/terraform
	cp "${S}/terraform" "${D}/opt/terraform/" || die "Install failed!"
	dosym ../../opt/terraform/terraform /usr/bin/terraform
}

pkg_postinst() {
	elog "If you would like to install shell completions please run:"
	elog "    terraform -install-autocomplete"
}
