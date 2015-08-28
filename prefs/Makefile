include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PowerDownEnhancerPrefs
PowerDownEnhancerPrefs_FILES = $(wildcard *.mm)
PowerDownEnhancerPrefs_INSTALL_PATH = /Library/PreferenceBundles
PowerDownEnhancerPrefs_FRAMEWORKS = UIKit
PowerDownEnhancerPrefs_PRIVATE_FRAMEWORKS = Preferences
PowerDownEnhancerPrefs_LIBRARIES = cepheiprefs

include $(THEOS)/makefiles/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PowerDownEnhancerPrefs.plist$(ECHO_END)
