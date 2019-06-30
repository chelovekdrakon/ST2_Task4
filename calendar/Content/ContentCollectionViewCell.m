#import "ContentCollectionViewCell.h"

@interface ContentCollectionViewCell()
@property(strong, nonatomic) EKEvent *event;
@property(strong, nonatomic) UILabel *label;
@end

@implementation ContentCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] init];
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)setEvent:(EKEvent *)event {
    NSString *str = [NSString stringWithFormat:@"%@", event.startDate];
    self.label.text = str;
    self.label.textColor = [UIColor blackColor];
    [self.label sizeToFit];
    [self.contentView sizeToFit];
}

@end
