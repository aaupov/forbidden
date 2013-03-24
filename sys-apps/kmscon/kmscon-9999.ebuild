# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils autotools vcs-snapshot git-2

DESCRIPTION="KMS/DRM based virtual Console Emulator"
HOMEPAGE="https://github.com/dvdhrm/kmscon"
EGIT_REPO_URI="git://github.com/dvdhrm/kmscon.git"
EGIT_BRANCH="master"

LICENSE="MIT LGPL-2.1 BSD-2 as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+bblit dbus doc +drm +f8x16 +fbdev freetype2 +gles2 +gltex +pango
static-libs -systemd +udev +xkbcommon +optimizations debug"

RDEPEND="
	dev-libs/glib:2
	dbus? ( sys-apps/dbus )
	drm? ( x11-libs/libdrm
		>=media-libs/mesa-8.0.3[egl,gbm] )
	freetype2? ( media-libs/freetype:2 )
	gles2? ( >=media-libs/mesa-8.0.3[gles2] )
	pango? ( x11-libs/pango )
	systemd? ( sys-apps/systemd )
	udev? ( virtual/udev )
	xkbcommon? ( x11-libs/libxkbcommon )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/xproto
	doc? ( dev-util/gtk-doc )"

REQUIRED_USE="drm? ( gles2 )
	gltex? ( gles2 )"

src_prepare() {
	eautoreconf
}

src_configure() {
	# xkbcommon not in portage
	econf \
		--disable-silent-rules \
		$(use_enable static-libs static) \
		$(use_enable doc gtk-doc) \
		$(use_enable systemd) \
		$(use_enable udev) \
		$(use_enable dbus) \
		$(use_enable fbdev) \
		$(use_enable drm) \
		$(use_enable gles2) \
		$(use_enable xkbcommon) \
		$(use_enable f8x16) \
		$(use_enable freetype2) \
		$(use_enable pango) \
		$(use_enable bblit) \
		$(use_enable debug) \
		$(use_enable optimizations) \
		--with-html-dir=/usr/share/doc/${PF}/html
}
