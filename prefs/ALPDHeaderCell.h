#import <Preferences/PSSpecifier.h>

@interface PSTableCell : UITableViewCell

@property (nonatomic, retain) UIView *backgroundView;

@property (nonatomic, assign, setter = _setDrawsSeparatorAtTopOfSection:) BOOL _drawsSeparatorAtTopOfSection;
@property (nonatomic, assign, setter = _setDrawsSeparatorAtBottomOfSection:) BOOL _drawsSeparatorAtBottomOfSection;

- (instancetype)initWithStyle:(UITableViewCellStyle)arg1 reuseIdentifier:(id)arg2 specifier:(PSSpecifier *)arg3;

@end

@interface ALPDHeaderCell : PSTableCell

@end
