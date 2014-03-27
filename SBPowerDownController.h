@interface SBPowerDownController : NSObject

+ (instancetype)sharedInstance;

- (void)orderFront;
- (void)orderOutWithCompletion:(id)arg1;

@end
