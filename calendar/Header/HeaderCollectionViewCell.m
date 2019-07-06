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
        
        [self addSubview:self.labelDay];
        [self addSubview:self.viewFlag];
        [self addSubview:self.labelDaySymbol];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

- (UIView *)backgroundView {
    return [[UIView alloc] init];
}

@end
