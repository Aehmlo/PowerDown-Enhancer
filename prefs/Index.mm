#import <CepheiPrefs/HBRootListController.h>
#import <Preferences/PSSpecifier.h>

#define PrettyLog(fmt, ...) NSLog(@"\e[1;31m%@\e]m ", [NSString stringWithFormat:fmt, ## __VA_ARGS__])

@interface HBRootListController ()

- (void)willBecomeActive;

-(void)removeSpecifierID:(NSString *)id animated:(BOOL)animated;
-(void)insertSpecifier:(PSSpecifier *)specifier afterSpecifierID:(NSString *)id animated:(BOOL)animated;

@end

@interface UITextField (ALPDPrefs)

- (id)cell;

@end

@interface ALPDRootListController : HBRootListController

@property (nonatomic, retain) NSMutableDictionary *removedSpecifiers;

@end

@implementation ALPDRootListController

- (void)hideRelevantSpecifiers{
	if(![[self ALGetValueForSpecifierID:@"PasscodeSwitch"] boolValue]){
		[self ALHideSpecifier:@"PasscodeField" animated:NO];
	}
	if(![[self ALGetValueForSpecifierID:@"CustomText"] boolValue]){
		[self ALHideSpecifier:@"Text" animated:NO];
	}
	if(![[self ALGetValueForSpecifierID:@"ChangeText"] boolValue]){
		[self ALHideSpecifier:@"Text" animated:NO];
		[self ALHideSpecifier:@"CustomText" animated:NO];
	}
	if(![[self ALGetValueForSpecifierID:@"EnableSwitch"] boolValue]){
		[self ALHideSpecifier:@"PasscodeField" animated:NO];
		[self ALHideSpecifier:@"PasscodeSwitch" animated:NO];
		[self ALHideSpecifier:@"Passcode" animated:NO];
		[self ALHideSpecifier:@"Text" animated:NO];
		[self ALHideSpecifier:@"CustomText" animated:NO];
		[self ALHideSpecifier:@"ChangeText" animated:NO];
		[self ALHideSpecifier:@"Appearance" animated:NO];
		[self ALHideSpecifier:@"DisableLockButton" animated:NO];
		[self ALHideSpecifier:@"NotRecommended" animated:NO];
		[self ALHideSpecifier:@"FunctionList" animated:NO];
	}
}

- (void)loadSpecifiers{
	if(_specifiers) return;
	_specifiers = [[self loadSpecifiersFromPlistName:@"Index" target:self] retain];
}

- (instancetype)init{
	if((self = [super init])) {
		[self loadSpecifiers];
		self.removedSpecifiers = [[NSMutableDictionary alloc] initWithCapacity:1];
	}
	return self;
}


- (id)specifiers{
	[self loadSpecifiers];
	[self hideRelevantSpecifiers];
	return _specifiers;
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self hideRelevantSpecifiers];
}

- (void)willBecomeActive{
	[super willBecomeActive];
	[self hideRelevantSpecifiers];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	if([textField respondsToSelector:@selector(cell)] && [[textField cell] respondsToSelector:@selector(resignFirstResponder)]){
		[[textField cell] resignFirstResponder];
	}
	return NO;
}

- (void)ALHideSpecifier:(NSString *)specifier animated:(BOOL)animated{
	if(self.removedSpecifiers[specifier] || ![self specifierForID:specifier]) return;
	self.removedSpecifiers[specifier] = [self specifierForID:specifier];
	[self removeSpecifierID:specifier animated:animated];
}

- (void)ALShowSpecifier:(NSString *)specifier afterSpecifier:(NSString *)afterSpecifier animated:(BOOL)animated{
	if(!self.removedSpecifiers[specifier] || ![self specifierForID:afterSpecifier]) return;
	[self insertSpecifier:self.removedSpecifiers[specifier] afterSpecifierID:afterSpecifier animated:animated];
	[self.removedSpecifiers removeObjectForKey:specifier];
}

- (id)ALGetValueForSpecifierID:(NSString *)specifier{
	return [self readPreferenceValue:[self specifierForID:specifier] ?: self.removedSpecifiers[specifier]];
}

- (BOOL)canBeShownFromSuspendedState{
	return NO; //Temporary, odd bugs. Couldn't get the specifiers to hide when the Settings app was launched after exiting.
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier{
	[super setPreferenceValue:value specifier:specifier];
	if([[specifier identifier] isEqualToString:@"PasscodeSwitch"]){
		if([value boolValue]){
			[self ALShowSpecifier:@"PasscodeField" afterSpecifier:@"PasscodeSwitch" animated:YES];
		}else{
			[self ALHideSpecifier:@"PasscodeField" animated:YES];
		}
	}else if([[specifier identifier] isEqualToString:@"ChangeText"]){
		if([value boolValue]){
			[self ALShowSpecifier:@"CustomText" afterSpecifier:@"ChangeText" animated:YES];
			if([[self ALGetValueForSpecifierID:@"CustomText"] boolValue]){
				[self ALShowSpecifier:@"Text" afterSpecifier:@"CustomText" animated:YES];
			}
		}else{
			[self ALHideSpecifier:@"Text" animated:YES];
			[self ALHideSpecifier:@"CustomText" animated:YES];
		}
	}else if([[specifier identifier] isEqualToString:@"CustomText"]){
		if([value boolValue]){
			[self ALShowSpecifier:@"Text" afterSpecifier:@"CustomText" animated:YES];
		}else{
			[self ALHideSpecifier:@"Text" animated:YES];
		}
	}else if([[specifier identifier] isEqualToString:@"EnableSwitch"]){
		if([value boolValue]){
			[self ALShowSpecifier:@"FunctionList" afterSpecifier:@"EnableSwitch" animated:YES];
			[self ALShowSpecifier:@"Appearance" afterSpecifier:@"FunctionList" animated:YES];
			[self ALShowSpecifier:@"ChangeText" afterSpecifier:@"Appearance" animated:YES];
			if([[self ALGetValueForSpecifierID:@"ChangeText"] boolValue]){
				[self ALShowSpecifier:@"CustomText" afterSpecifier:@"ChangeText" animated:YES];
				if([[self ALGetValueForSpecifierID:@"CustomText"] boolValue]){
					[self ALShowSpecifier:@"Text" afterSpecifier:@"CustomText" animated:YES];
					[self ALShowSpecifier:@"Passcode" afterSpecifier:@"Text" animated:YES];
				}else{
					[self ALShowSpecifier:@"Passcode" afterSpecifier:@"CustomText" animated:YES];
				}
			}else{
				[self ALShowSpecifier:@"Passcode" afterSpecifier:@"ChangeText" animated:YES];
			}
			[self ALShowSpecifier:@"PasscodeSwitch" afterSpecifier:@"Passcode" animated:YES];
			if([[self ALGetValueForSpecifierID:@"PasscodeSwitch"] boolValue]){
				[self ALShowSpecifier:@"PasscodeField" afterSpecifier:@"PasscodeSwitch" animated:YES];
				[self ALShowSpecifier:@"NotRecommended" afterSpecifier:@"PasscodeField" animated:YES];
			}else{
				[self ALShowSpecifier:@"NotRecommended" afterSpecifier:@"PasscodeSwitch" animated:YES];
			}
			[self ALShowSpecifier:@"DisableLockButton" afterSpecifier:@"NotRecommended" animated:YES];
		}else{
			[self ALHideSpecifier:@"PasscodeField" animated:YES];
			[self ALHideSpecifier:@"PasscodeSwitch" animated:YES];
			[self ALHideSpecifier:@"Passcode" animated:YES];
			[self ALHideSpecifier:@"Text" animated:YES];
			[self ALHideSpecifier:@"CustomText" animated:YES];
			[self ALHideSpecifier:@"ChangeText" animated:YES];
			[self ALHideSpecifier:@"Appearance" animated:YES];
			[self ALHideSpecifier:@"DisableLockButton" animated:YES];
			[self ALHideSpecifier:@"NotRecommended" animated:YES];
			[self ALHideSpecifier:@"FunctionList" animated:YES];
		}
	}
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
	return YES;
}

+ (UIColor *)hb_tintColor{
	return [UIColor colorWithRed:31.f/255.f green:221.f/255.f blue:243.f/255.f alpha:1];
}

+ (NSString *)hb_shareText{
	return @"I'm using PowerDown Enhancer by @Aehmlo to take control of my \"slide to power off\" screen!";
}

+ (NSURL *)hb_shareURL{
	return [NSURL URLWithString:@"http://cydia.saurik.com/package/com.aehmlo.powerdownenhancer"];
}

@end
