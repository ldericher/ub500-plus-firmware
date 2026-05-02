##########
# PARAMS #
##########

HW_VER ?= v1

ifeq ($(HW_VER),v1)
    HW_VER := v1
    HW_CNF := v2
    BT_VER := 5.3 (hci version 12)
else ifeq ($(HW_VER),$(filter $(HW_VER),v2 v2.60))
    HW_VER := v2
    HW_CNF := v1
    BT_VER := 5.4 (hci version 13)
else
    $(error HW_VER must be "v1", "v2" or "v2.60"!)
endif

#############
# CONSTANTS #
#############

PKG_NAME := ub500-plus-$(HW_VER)-firmware
PKG_CNF  := ub500-plus-$(HW_CNF)-firmware
PKG_VER  := 1.0-1
PKG_ARCH := all
FW_PATH  := /lib/firmware/rtl_bt/rtl8761bu_fw.bin.zst

DEB_DIR  := pkgroot-$(HW_VER)
DEB_CONT := \
	DEBIAN/control \
	DEBIAN/postinst \
	DEBIAN/prerm

DEB_FILE := "$(PKG_NAME)_$(PKG_VER)_$(PKG_ARCH).deb"

########
# MAIN #
########

.PHONY: all
all: $(DEB_FILE)

.PHONY: install
install: $(DEB_FILE)
	dpkg --install $<

.PHONY: clean
clean: 
	rm -rf pkgroot-*
	rm -f *.deb

.PRECIOUS: $(DEB_DIR)/DEBIAN
$(DEB_DIR)/DEBIAN:
	mkdir -p $@

$(DEB_DIR)/DEBIAN/%: src/% $(DEB_DIR)/DEBIAN
	sed \
		-e 's/%%PKG_NAME%%/$(PKG_NAME)/ig' \
		-e 's/%%PKG_CNF%%/$(PKG_CNF)/ig' \
		-e 's/%%PKG_VER%%/$(PKG_VER)/ig' \
		-e 's/%%PKG_ARCH%%/$(PKG_ARCH)/ig' \
		-e 's/%%BT_VER%%/$(BT_VER)/ig' \
		-e 's;%%FW_PATH%%;$(FW_PATH);ig' \
		$< > $@
	chmod --reference=$< $@

$(DEB_FILE): $(addprefix $(DEB_DIR)/,$(DEB_CONT))
	dpkg-deb --build $(DEB_DIR) $@
