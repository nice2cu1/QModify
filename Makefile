TARGET := iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = QQ
THEOS_PACKAGE_SCHEME = rootless
THEOS_DEVICE_IP = 192.168.2.232

include $(THEOS)/makefiles/common.mk

ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
qmodify_LDFLAGS += -install_name @rpath/qmodify.dylib
endif

TWEAK_NAME = qmodify

qmodify_FILES = Tweak.x
qmodify_CFLAGS = -fobjc-arc -Wdeprecated-declarations -Wno-deprecated-declarations -Wno-unused-variable

include $(THEOS_MAKE_PATH)/tweak.mk
