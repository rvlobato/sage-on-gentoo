# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit distutils latex-package

MY_P="sagetex-${PV}.p0"

DESCRIPTION="SageTeX package allows to embed code from the Sage mathematics
software suite into LaTeX documents"
HOMEPAGE="http://www.sagemath.org"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

# TODO: Check dependencies

DEPEND=">=dev-tex/tkz-berge-2.8"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/src"

src_prepare() {
	# LaTeX file are installed by eclass functions
	epatch "${FILESDIR}"/${P}-install-python-files-only.patch

	# set the right location of latex documents
	sed -i "s:share/texmf/tex/generic/sagetex:share/texmf/tex/latex/${PN}:g" \
		setup.py || die "sed failed"

	distutils_src_prepare
}

# TODO: fix documentation: install precompiled pdf file manually

src_compile() {
	latex-package_src_compile
	distutils_src_compile
}

src_install() {
	latex-package_src_install
	distutils_src_install
}
