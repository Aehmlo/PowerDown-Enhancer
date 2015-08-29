#import <CepheiPrefs/HBAboutListController.h>
#import <Preferences/PSTableCell.h>

@interface PSTableCell ()

@property BOOL _drawsSeparatorAtBottomOfSection;
@property BOOL _drawsSeparatorAtTopOfSection;

@end

@interface ALPDAboutListController: HBAboutListController

@end

@implementation ALPDAboutListController

+ (UIColor *)hb_tintColor{
     return [UIColor colorWithRed:31.f/255.f green:221.f/255.f blue:243.f/255.f alpha:1];
}

+ (NSURL *)hb_websiteURL{
	return [NSURL URLWithString:@"https://aehmlo.me"];
}

+ (NSURL *)hb_donateURL{
	return [NSURL URLWithString:@"https://aehmlo.me/donate"];
}

+ (NSString *)hb_supportEmailAddress{
	return @"Aehmlo Lxaitn <powerdownenhancer@aehmlo.com>";
}

@end