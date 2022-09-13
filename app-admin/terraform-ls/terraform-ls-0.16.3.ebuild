# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Experimental version of Terraform language server"
HOMEPAGE="https://github.com/hashicorp/terraform-ls"
SLOT="0"
SRC_URI="https://releases.hashicorp.com/terraform-ls/${PV}/terraform-ls_${PV}_linux_amd64.zip"

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
	dodir /opt/terraform-ls
	cp "${S}/terraform-ls" "${D}/opt/terraform-ls/" || die "Install failed!"
	dosym ../../opt/terraform-ls/terraform-ls /usr/bin/terraform-ls
}
