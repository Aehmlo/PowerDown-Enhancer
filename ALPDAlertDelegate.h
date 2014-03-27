#import "SBPowerDownController.h"

@interface ALPDAlertDelegate : NSObject <UIAlertViewDelegate, UITextFieldDelegate> //Not named ALPDAlertViewDelegate because it's the delegate for the text field as well.

+ (instancetype)sharedInstance;

@property (nonatomic, retain, getter = getPrefs) NSDictionary *prefs;
@property (nonatomic, assign) BOOL authenticated;

@end
