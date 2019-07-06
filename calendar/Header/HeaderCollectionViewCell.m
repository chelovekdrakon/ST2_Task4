//
//  HeaderCollectionViewCell.m
//  calendar
//
//  Created by Фёдор Морев on 6/30/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import "HeaderCollectionViewCell.h"

@implementation HeaderCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:self.label];
    }
    return self;
}

- (void)didMoveToSuperview {
    NSLog(@"f");
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

@end
