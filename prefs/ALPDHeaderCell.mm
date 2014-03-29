#import "ALPDHeaderCell.h"

@interface UIImage (ALPDPrivateMethods)

+ (instancetype)imageNamed:(NSString *)name inBundle:(NSBundle *)bundle;

@end

static CGFloat const kALPDHeaderCellFontSize = 22.f;

@implementation ALPDHeaderCell //Thanks to https://github.com/hbang/TypeStatus/blob/master/prefs/HBTSHeaderCell.m

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier{
	if((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier])){
		self.backgroundColor = [UIColor clearColor];
		self.backgroundView = [[[UIView alloc] init] autorelease];

		UIView *containerView = [[[UIView alloc] init] autorelease];
		containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		[self.contentView addSubview:containerView];

		UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PowerDownEnhancerPrefs" inBundle:[NSBundle bundleForClass:self.class]]] autorelease];
		[containerView addSubview:imageView];

		UILabel *powerdownLabel = [[[UILabel alloc] init] autorelease];
		powerdownLabel.text = @"PowerDown Enhancer 2.0";
		powerdownLabel.backgroundColor = [UIColor clearColor];
		powerdownLabel.font = [UIFont systemFontOfSize:kALPDHeaderCellFontSize];
		[containerView addSubview:powerdownLabel];

		powerdownLabel.frame = CGRectMake(imageView.image.size.width + 10.f, -1.f, [powerdownLabel.text sizeWithFont:powerdownLabel.font].width, imageView.image.size.height);
		containerView.frame = CGRectMake(0, 0, powerdownLabel.frame.origin.x + powerdownLabel.frame.size.width, imageView.image.size.height);
		containerView.center = CGPointMake(self.contentView.frame.size.width / 2.f, containerView.center.y);
		imageView.center = CGPointMake(imageView.center.x, containerView.frame.size.height / 2.f);
	}

	return self;
}

- (CGFloat)preferredHeightForWidth:(CGFloat)width{
	return [@"" sizeWithFont:[UIFont systemFontOfSize:kALPDHeaderCellFontSize]].height;
}

@end
