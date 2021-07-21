ARCHS = arm64 arm64e

TARGET := iphone:clang:14.4
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SMSReceiver

SMSReceiver_FILES = Tweak.x
SMSReceiver_FRAMEWORKS = Foundation UIKit
SMSReceiver_CFLAGS = -fobjc-arc -Wno-deprecated -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += smsreceiverprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
