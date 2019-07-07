//
//  HeaderCollectionViewCell.m
//  calendar
//
//  Created by Фёдор Морев on 6/30/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import "HeaderCollectionViewCell.h"

@interface HeaderCollectionViewCell()

@end

@implementation HeaderCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.labelDay = [[UILabel alloc] initWithFrame:CGRectZero];
        self.viewFlag = [[UIView alloc] initWithFrame:CGRectZero];
        self.labelDaySymbol = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:self.labelDay];
        [self.contentView addSubview:self.viewFlag];
        [self.contentView addSubview:self.labelDaySymbol];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

- (UIView *)backgroundView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    bgView.backgroundColor = [UIColor yellowColor];
    return bgView;
}

- (UIView *)selectedBackgroundView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    bgView.backgroundColor = [UIColor redColor];
    return bgView;
}

- (void)prepareForReuse {
    self.isToday = NO;
    self.viewFlag.frame = CGRectMake(0, 0, 0, 0);
    self.viewFlag.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.viewFlag.layer.cornerRadius = 0.f;
}

@end
