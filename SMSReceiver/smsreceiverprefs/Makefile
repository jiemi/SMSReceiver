TARGET := iphone:clang:14.5

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = smsreceiverprefs

smsreceiverprefs_FILES = SMSRootListController.m
smsreceiverprefs_INSTALL_PATH = /Library/PreferenceBundles
smsreceiverprefs_FRAMEWORKS = UIKit
smsreceiverprefs_PRIVATE_FRAMEWORKS = Preferences
smsreceiverprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p "$(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences"$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist "$(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/smsreceiverprefs.plist"$(ECHO_END)
