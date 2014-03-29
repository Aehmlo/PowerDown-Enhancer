#import <hbangprefs/HBAboutListController.h>
#import "ALPDHeaderCell.h"

@interface ALPDAboutListController: HBAboutListController

@end

@implementation ALPDAboutListController

+ (UIColor *)hb_tintColor{
     return [UIColor colorWithRed:31.f/255.f green:221.f/255.f blue:243.f/255.f alpha:1];
}

+ (NSURL *)hb_websiteURL{
	return [NSURL URLWithString:@"http://aehmlo.com"];
}

+ (NSURL *)hb_donateURL{
	return [NSURL URLWithString:@"http://aehmlo.com/donate"];
}

+ (NSString *)hb_supportEmailAddress{
	return @"bFlat Design Studios <bflatstudios+powerdownenhancer@gmail.com>";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(PSTableCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0 && indexPath.row == 0 && [cell respondsToSelector:@selector(_setDrawsSeparatorAtTopOfSection:)]) {
		cell._drawsSeparatorAtTopOfSection = NO;
		cell._drawsSeparatorAtBottomOfSection = NO;
	}
}

@end

// vim:ft=objc
