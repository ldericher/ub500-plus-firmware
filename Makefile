PKG_NAME := $(shell awk -F': ' '/^Package:/{print $$2; exit}' pkgroot/DEBIAN/control)
PKG_VER  := $(shell awk -F': ' '/^Version:/{print $$2; exit}' pkgroot/DEBIAN/control)
PKG_ARCH := $(shell awk -F': ' '/^Architecture:/{print $$2; exit}' pkgroot/DEBIAN/control)

PKG_DEB  := "$(PKG_NAME)_$(PKG_VER)_$(PKG_ARCH).deb"

.PHONY: all
all: $(PKG_DEB)

$(PKG_DEB):
	@echo $@
	touch $@
