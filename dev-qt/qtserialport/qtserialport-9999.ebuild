# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt4-r2 git-2

DESCRIPTION="The serial port module for the Qt toolkit"
HOMEPAGE="http://qt-project.org/wiki/QtSerialPort"
EGIT_REPO_URI="git://gitorious.org/qt/qtserialport.git"
EGIT_BRANCH="master"

SLOT="4"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-qt/qtcore
	"
RDEPEND="${DEPEND}"

pkg_setup() {
	QCONFIG_ADD="serialport"

	qt4-r2_src_prepare
}

src_configure() {
	eqmake4 
}

src_compile() {
	qt4-r2_src_compile
}

src_install() {
	qt4-r2_src_install
}
