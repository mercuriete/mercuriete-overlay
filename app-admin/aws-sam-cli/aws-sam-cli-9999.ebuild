# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="CLI tool to manage Serverless applications using AWS SAM"
HOMEPAGE="https://github.com/aws/aws-sam-cli"

if [[ ${PV} == 9999 ]]; then
	SRC_URI="https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip -> aws-sam-cli-linux-x86_64-${PV}.zip"
else
	SRC_URI="https://github.com/aws/aws-sam-cli/releases/download/v${PV}/aws-sam-cli-linux-x86_64.zip -> aws-sam-cli-linux-x86_64-${PV}.zip"
fi

S="${WORKDIR}"
LICENSE="Apache-2.0"
SLOT="0/9999"
KEYWORDS="~amd64"
DEPEND="app-arch/unzip"

src_unpack() {
	if [ ${A} != "" ]; then
		unpack ${A}
	fi
}

src_install() {
	./install --install-dir "${D}/opt/aws-sam-cli" --bin-dir "${D}/usr/local/bin"
}
