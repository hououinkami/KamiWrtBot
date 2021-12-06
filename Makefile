include $(TOPDIR)/rules.mk

PKG_NAME:=KamiWrtBot

PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=utils
  CATEGORY:=Utils
  TITLE:=KamiWrtBot
  URL:=https://github.com/alexwbaule/telegramopenwrt
  PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
  Telegram for use in openwrt. Its a BOT
  that executes selected commands in your router.
  Version: $(PKG_VERSION)-$(PKG_RELEASE)
  Info   : https://github.com/alexwbaule/telegramopenwrt
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/telegram_bot
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./etc/init.d/telegram_bot \
		$(1)/etc/init.d

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./etc/config/telegram_bot \
		$(1)/etc/config/telegram_bot
	
	$(INSTALL_DIR) $(1)/usr/lib/telegram_bot/plugins/functions
	$(INSTALL_BIN) ./usr/lib/telegram_bot/plugins/functions/get_mac.sh \
				./usr/lib/telegram_bot/plugins/functions/ping.sh \
		$(1)/usr/lib/telegram_bot/plugins/functions

	$(INSTALL_DIR) $(1)/usr/lib/telegram_bot/plugins
	$(INSTALL_BIN) ./usr/lib/telegram_bot/plugins/r.sh \
				./usr/lib/telegram_bot/plugins/docker.sh \
				./usr/lib/telegram_bot/plugins/xuexi.sh \
				./usr/lib/telegram_bot/plugins/bdstart.sh \
				./usr/lib/telegram_bot/plugins/bdstop.sh \
		$(1)/usr/lib/telegram_bot/plugins
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	/etc/init.d/telegram_bot enabled
	/etc/init.d/telegram_bot start
fi
exit 0
endef

define Package/$(PKG_NAME)/prerm
#!/bin/sh
if [ -n "$${IPKG_INSTROOT}" ]; then
	/etc/init.d/telegram_bot stop
	/etc/init.d/telegram_bot disable
fi
exit 0
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
