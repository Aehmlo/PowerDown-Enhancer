#import <hbangprefs/HBListController.h>

@interface ALPDCreditsListController: HBListController

@end

@implementation ALPDCreditsListController

- (instancetype)init{
     if((self = [super init]))
          _specifiers = [[self loadSpecifiersFromPlistName:@"Contributors" target:self] retain];
     return self;
}

+ (UIColor *)hb_tintColor{
     return [UIColor colorWithRed:31.f/255.f green:221.f/255.f blue:243.f/255.f alpha:1];
}

@end

// vim:ft=objc
