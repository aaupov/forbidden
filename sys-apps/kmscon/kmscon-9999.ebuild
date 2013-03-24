# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils autotools git-2 systemd

DESCRIPTION="KMS/DRM based virtual Console Emulator"
HOMEPAGE="https://github.com/dvdhrm/kmscon"
EGIT_REPO_URI="git://github.com/dvdhrm/kmscon.git"
EGIT_BRANCH="master"

LICENSE="MIT LGPL-2.1 BSD-2 as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus doc +drm +fbdev truetype +gles2 +pango cairo pixman
static-libs systemd debug multiseat +unicode wayland"

RDEPEND="
	dev-libs/glib:2
	>=virtual/udev-172
	x11-libs/libxkbcommon
	dbus? ( sys-apps/dbus )
	drm? ( x11-libs/libdrm
		>=media-libs/mesa-8.0.3[egl,gbm] )
	truetype? ( media-libs/freetype:2 )
	gles2? ( >=media-libs/mesa-8.0.3[gles2] )
	pango? ( x11-libs/pango )
	systemd? ( sys-apps/systemd )
	cairo? ( x11-libs/cairo )
	pixman? ( x11-libs/pixman )
	wayland? ( dev-libs/wayland )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/xproto
	doc? ( dev-util/gtk-doc )"

REQUIRED_USE="gles2? ( drm )
	multiseat? ( systemd )"

# args - names of renderers to enable
renderers_enable() {
	if [[ "x${RENDER}" == "x" ]]; then
		RENDER="$1"
		shift
	else
		for i in $@; do
			RENDER+=",${i}"
		done
	fi
}

# args - names of font renderer backends to enable
fonts_enable() {
	if [[ "x${FONTS}" == "x" ]]; then
		FONTS="$1"
		shift
	else
		for i in $@; do
			FONTS+=",${i}"
		done
	fi
}

# args - names of video backends to enable
video_enable() {
	if [[ "x${VIDEO}" == "x" ]]; then
		VIDEO="$1"
		shift
	else
		for i in $@; do
			VIDEO+=",${i}"
		done
	fi
}

src_prepare() {
	eautoreconf
}

src_configure() {
	# Video backends

	if use fbdev; then 
		video_enable fbdev
	fi

	if use drm; then
		video_enable drm2d
	fi

	if use gles2; then
		video_enable drm3d
	fi


	# Font rendering backends 

	if use unicode; then
		fonts_enable unifont
	fi

	if use truetype; then
		fonts_enable freetype2
	fi

	if use pango; then 
		fonts_enable pango
	fi


	# Console rendering backends
	
	renderers_enable bbulk

	if use gles2; then
		renderers_enable gltex
	fi

	if use cairo; then
		renderers_enable cairo
	fi

	if use pixman; then
		renderers_enable pixman
	fi

	# xkbcommon not in portage
	econf \
		$(use_enable static-libs static) \
		$(use_enable debug) \
		$(use_enable multiseat multi-seat) \
		$(use_enable wayland wlterm) \
		\
		--htmldir=/usr/share/doc/${PF}/html \
		--with-video=${VIDEO} \
		--with-fonts=${FONTS} \
		--with-renderers=${RENDER} \
		--with-sessions=dummy,terminal \
		--enable-optimizations \
		--enable-kmscon
	
	if use systemd ; then
		systemd_dounit docs/kmscon.service docs/kmsconvt@.service || die
	fi
}
