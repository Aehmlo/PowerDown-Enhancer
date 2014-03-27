%config(generator=internal)

#import "SpringBoard.h"
#import "SBPowerDownController.h"

#import "ALPDAlertDelegate.h"

@interface UIAlertView (ALPDiOS6)

- (void)addTextFieldWithValue:(NSString *)value label:(NSString *)label;

@end

#include <substrate.h>

static void reloadPrefs(void);

extern "C" {
	CFStringRef CFBundleCopyLocalizedString(CFBundleRef bundle, CFStringRef key, CFStringRef value, CFStringRef tableName);
}
static NSDictionary *prefs;

static CFStringRef (*orig_CFBundleCopyLocalizedString)(CFBundleRef bundle, CFStringRef key, CFStringRef value, CFStringRef tableName);

static CFStringRef ALPD_newCFBundleCopyLocalizedString(CFBundleRef bundle, CFStringRef key, CFStringRef value, CFStringRef tableName){
	CFStringRef ret;
	if(CFStringCompare(key, CFSTR("POWER_DOWN_LOCK_LABEL"), 0) == 0){
		if((!prefs[@"Enable"] || [prefs[@"Enable"] boolValue]) && (!prefs[@"ChangeText"] || [prefs[@"ChangeText"] boolValue])){
			if([prefs[@"CustomText"] boolValue]){
				return CFStringCreateWithCString(NULL, [(NSString *)prefs[@"Text"] UTF8String], kCFStringEncodingUTF8); //Long live Unicode! Well, sorta.
			}
			switch([prefs[@"Function"] intValue]){
				case 1:
					ret = CFSTR("slide to respring");
					break;
				case 2:
					ret = CFSTR("slide to crash");
					break;
				case 4:
					ret = CFSTR("slide to reboot");
					break;
				default:
					ret = CFSTR("slide to power down");
					break;
			}
		}else{
			ret = orig_CFBundleCopyLocalizedString(bundle, key, value, tableName);
		}
		return ret;
	}else{
		return orig_CFBundleCopyLocalizedString(bundle, key, value, tableName);
	}
}

%hook SBPowerDownController

- (void)powerDown{
	switch([prefs[@"Function"] intValue]){
		case 1:
			[(SpringBoard *)[%c(SpringBoard) sharedApplication] _relaunchSpringBoardNow];
			break;
		case 2:
			system("killall -SEGV SpringBoard"); //I know, I know.
			break;
		case 4:
			[(SpringBoard *)[%c(SpringBoard) sharedApplication] _rebootNow];
			break;
		case 5:
			break;
		default:
			%orig();
			break;
	}
}

- (void)orderOutWithCompletion:(id)arg1{
	%orig(arg1);
	[ALPDAlertDelegate sharedInstance].authenticated = NO;
}

- (void)orderOut{
	%orig();
	[ALPDAlertDelegate sharedInstance].authenticated = NO;
}

- (void)cancel{
	%orig();
	[ALPDAlertDelegate sharedInstance].authenticated = NO;
}

- (void)orderFront{
	reloadPrefs();
	if(![ALPDAlertDelegate sharedInstance].authenticated && [prefs[@"EnablePasscode"] boolValue] && ![prefs[@"Passcode"] isEqualToString:@""]){
		UIAlertView *passwordAlert = [[UIAlertView alloc] initWithTitle:@"Enter Password" message:nil delegate:[ALPDAlertDelegate sharedInstance] cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
		if([UIAlertView instancesRespondToSelector:@selector(setAlertViewStyle:)]) passwordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
		else [passwordAlert addTextFieldWithValue:@"" label:@"Password"];
		UITextField *passwordField = [passwordAlert textFieldAtIndex:0];
		passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
		NSString *pass = prefs[@"Passcode"];
		NSCharacterSet *unwantedCharacters = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
		if([pass rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound){
			passwordField.keyboardType = UIKeyboardTypeNumberPad;
		}else{
			passwordField.keyboardType = UIKeyboardTypeDefault;
		}
		passwordField.placeholder = @"Password";
		passwordField.keyboardAppearance = UIKeyboardAppearanceAlert;
		passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
		passwordField.delegate = [ALPDAlertDelegate sharedInstance];
		passwordAlert.tag = 6901;
		[passwordAlert show];
		[passwordAlert release];
	}else if([prefs[@"Function"] intValue] != 5){
		%orig();
	}
}

%end

static void reloadPrefs(void){
	prefs = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/com.aehmlo.powerdownenhancer.plist"]];
}

%ctor{
	reloadPrefs();
	MSHookFunction(CFBundleCopyLocalizedString, ALPD_newCFBundleCopyLocalizedString, &orig_CFBundleCopyLocalizedString);
}
