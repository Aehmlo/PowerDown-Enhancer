#import "ALPDAlertDelegate.h"

@implementation ALPDAlertDelegate

+ (instancetype)sharedInstance{
     static dispatch_once_t token = 0;
     static id sharedInstance;
     dispatch_once(&token, ^{
          sharedInstance = [[self alloc] init];
     });
     return sharedInstance;
}

- (NSDictionary *)getPrefs{
     _prefs = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/com.aehmlo.powerdownenhancer.plist"]];
     return _prefs;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
     if(buttonIndex == 1){
          if([[alertView textFieldAtIndex:0].text isEqualToString:self.prefs[@"Passcode"]]){
               self.authenticated = YES;
               [[%c(SBPowerDownController) sharedInstance] orderFront];
          }else{
               UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Authentication Failed" message:@"Incorrect Password." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
               [errorAlertView show];
               [errorAlertView release];
               self.authenticated = NO; //Should already be NO, but set it here anyways.
          }
     }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView{
     return (alertView.tag == 6901 && [[alertView textFieldAtIndex:0].text length] > 0) ? YES : NO; //Ternary operator not necessary, but nice on the eyes.
}

/*- (BOOL)textFieldShouldReturn:(UITextField *)textField{
     [textField resignFirstResponder];
     [self alertView:alertView didDismissWithButtonIndex:1];
     return YES;
}*/

@end
