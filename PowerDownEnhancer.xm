#import "SBPowerDownController.h"
#import "SpringBoard.h"

#import <Cephei/HBPreferences.h>

static BOOL enabled;
static NSInteger function;

%hook SBPowerDownController

- (void)powerDown {

	if(!enabled) {
		%orig();
		return;
	}

	switch(function) {
		case 1:
			[(SpringBoard *)[%c(SpringBoard) sharedApplication] _relaunchSpringBoardNow];
			break;
		case 2:
			kill([[NSProcessInfo processInfo] processIdentifier], SIGSEGV);
			break;
		case 4:
			[(SpringBoard *)[%c(SpringBoard) sharedApplication] _rebootNow];
			break;
		case 5:
			[self orderOutWithCompletion:nil];
			break;
		default:
			%orig();
			break;
	}

}

%end

%ctor {

	HBPreferences *prefs = [HBPreferences preferencesForIdentifier:@"com.aehmlo.powerdownenhancer"];

	[prefs registerInteger:&function default:1 forKey:@"Function"];
	[prefs registerBool:&enabled default:YES forKey:@"Enabled"];

}
