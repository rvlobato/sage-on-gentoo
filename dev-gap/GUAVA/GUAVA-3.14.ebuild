# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

MY_PN="guava"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="GAP package for computing with error-correcting codes"
HOMEPAGE="http://www.gap-system.org/Packages/guava.html https://osj1961.github.io/guava/"
SLOT="4.10.0"
SRC_URI="https://www.gap-system.org/pub/gap/gap-$(ver_cut 1-2 ${SLOT})/tar.bz2/gap-${SLOT}.tar.bz2"

LICENSE="|| ( GPL-2 GPL-3 )"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sci-mathematics/gap:${SLOT}"

RESTRICT=mirror

DOCS=( {CHANGES,HISTORY,README}.${MY_PN} )

PATCHES=(
	"${FILESDIR}"/${MY_PN}-3.14-build.patch
	)

S="${WORKDIR}/gap-${SLOT}/pkg/${MY_P}"

src_prepare() {
	default
	# Remove temporary files in src/leon/.
	rm src/leon/src/stamp-h1 || die

	cd src/leon/ || die
	eautoreconf
}

src_configure() {
	# Not a real autoconf configure script
	econf "${EPREFIX}/usr/share/gap"

	cd src/leon/ || die
	# real autoconf configure script
	econf
}

src_compile() {
	# COMPILE, COMPOPT, LINKOPT are needed to compile the code in src/leon/.
	emake \
		CC="$(tc-getCC)" CFLAGS="${CFLAGS}" \
		COMPILE="$(tc-getCC)" COMPOPT="${CFLAGS} -c" LINKOPT="${LDFLAGS}"
}

src_install() {
	default

	insinto /usr/share/gap/pkg/"${MY_P}"
	doins -r bin doc lib tbl
	doins *.g
}
