export ARCHS=armv7 arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PowerDownEnhancer
PowerDownEnhancer_FILES = $(wildcard *.xm)
PowerDownEnhancer_FRAMEWORKS = UIKit
PowerDownEnhancer_LIBRARIES = hbangprefs

include $(THEOS)/makefiles/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
	rm *.deb

SUBPROJECTS += prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
