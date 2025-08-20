# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Original source: https://github.com/bombo82/bombo82-overlay

EAPI=8

inherit desktop wrapper

DESCRIPTION="The Leading Java and Kotlin IDE"
HOMEPAGE="https://www.jetbrains.com/idea/"

MY_PV="$(ver_cut 1-2)"
BUILD_NUMBER="242.21829.162"

if [[ ${PV} == *9999* ]]; then
	# For live version, use latest available
	MY_PV="2025.2"
	BUILD_NUMBER="242.21829.162"
	SRC_URI="https://download.jetbrains.com/idea/ideaIU-${MY_PV}.tar.gz -> idea-ultimate-live-${MY_PV}.tar.gz"
else
	SRC_URI="https://download.jetbrains.com/idea/ideaIU-${MY_PV}.tar.gz -> ${P}.tar.gz"
fi

S="${WORKDIR}/idea-IU-${BUILD_NUMBER}"

LICENSE="|| ( IDEA IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+experimental"

RDEPEND="
	>=dev-java/openjdk-17:*
	dev-java/jansi-native
	dev-libs/libdbusmenu
	llvm-core/lldb
	media-fonts/dejavu
	>=app-accessibility/at-spi2-core-2.46.0:2
	|| (
		x11-libs/libX11
		x11-libs/libxcb
	)
	|| (
		x11-libs/libXtst
		x11-libs/libxcb
	)
	experimental? (
		dev-libs/wayland
	)
"

DEPEND="${RDEPEND}"
BDEPEND="dev-util/patchelf"

RESTRICT="bindist mirror splitdebug"
QA_PREBUILT="opt/${PN}/*"

src_prepare() {
	default

	local remove_me=(
		help/ReferenceCardForMac.pdf
		lib/async-profiler-linux-arm64.jar
		lib/async-profiler-linux-x64.jar
		lib/pty4j-native/linux/aarch64/libpty.so
		lib/pty4j-native/linux/arm/libpty.so
		lib/pty4j-native/linux/mips64el/libpty.so
		lib/pty4j-native/linux/ppc64le/libpty.so
		lib/pty4j-native/linux/x86/libpty.so
		lib/pty4j-native/linux/x86_64/libpty.so
		plugins/maven/lib/maven3/lib/jansi-native/freebsd32/libjansi.so
		plugins/maven/lib/maven3/lib/jansi-native/freebsd64/libjansi.so
		plugins/maven/lib/maven3/lib/jansi-native/linux32/libjansi.so
		plugins/maven/lib/maven3/lib/jansi-native/linux64/libjansi.so
		plugins/maven/lib/maven3/lib/jansi-native/osx/libjansi.jnilib
		plugins/maven/lib/maven3/lib/jansi-native/windows32/jansi.dll
		plugins/maven/lib/maven3/lib/jansi-native/windows64/jansi.dll
	)

	use amd64 || remove_me+=(
		lib/async-profiler-linux-x64.jar
		lib/pty4j-native/linux/x86_64/libpty.so
		plugins/maven/lib/maven3/lib/jansi-native/linux64/libjansi.so
	)
	use arm64 || remove_me+=(
		lib/async-profiler-linux-arm64.jar
		lib/pty4j-native/linux/aarch64/libpty.so
	)

	rm -rv "${remove_me[@]}" || die

	# Patch binaries to use system libraries
	local elf_bins=(
		bin/fsnotifier
		bin/idea.sh
		bin/inspect.sh
		bin/jetbrains_client.sh
		bin/ltedit.sh
		bin/remote-dev-server.sh
		bin/repair
		bin/restarter
		jbr/bin/java
		jbr/bin/javac
		jbr/bin/javadoc
		jbr/bin/jcmd
		jbr/bin/jdb
		jbr/bin/jdeprscan
		jbr/bin/jdeps
		jbr/bin/jfr
		jbr/bin/jhsdb
		jbr/bin/jimage
		jbr/bin/jinfo
		jbr/bin/jlink
		jbr/bin/jmap
		jbr/bin/jmod
		jbr/bin/jpackage
		jbr/bin/jps
		jbr/bin/jrunscript
		jbr/bin/jshell
		jbr/bin/jstack
		jbr/bin/jstat
		jbr/bin/jstatd
		jbr/bin/keytool
		jbr/bin/rmiregistry
		jbr/bin/serialver
	)

	for elf in "${elf_bins[@]}"; do
		[[ -f "${elf}" ]] || continue
		patchelf --set-rpath '$ORIGIN:$ORIGIN/../lib:$ORIGIN/../lib/server' "${elf}" || die "patchelf failed on ${elf}"
	done
}

src_install() {
	local dest="/opt/${PN}"

	insinto "${dest}"
	doins -r *
	fperms 755 "${dest}"/bin/idea.sh
	fperms 755 "${dest}"/bin/inspect.sh
	fperms 755 "${dest}"/bin/jetbrains_client.sh
	fperms 755 "${dest}"/bin/ltedit.sh
	fperms 755 "${dest}"/bin/remote-dev-server.sh
	fperms 755 "${dest}"/bin/fsnotifier
	fperms 755 "${dest}"/bin/repair
	fperms 755 "${dest}"/bin/restarter

	# JBR permissions
	if [[ -d jbr ]]; then
		fperms 755 "${dest}"/jbr/bin/*
	fi

	make_wrapper "${PN}" "${dest}/bin/idea.sh"
	newicon "bin/idea.svg" "${PN}.svg"
	make_desktop_entry "${PN}" "IntelliJ IDEA Ultimate Edition" "${PN}" "Development;IDE;" \
		"StartupWMClass=jetbrains-idea"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	insinto /usr/lib/sysctl.d
	newins - 30-idea-inotify.conf <<< "fs.inotify.max_user_watches = 524288"
}

pkg_postinst() {
	elog "It is recommended to increase the inotify watch limit."
	elog "Add the following line to /etc/sysctl.conf:"
	elog "fs.inotify.max_user_watches = 524288"
	elog
	elog "Or run:"
	elog "sysctl -w fs.inotify.max_user_watches=524288"
	elog
	elog "For more info see:"
	elog "https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit"
}
