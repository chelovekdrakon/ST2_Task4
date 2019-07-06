//
//  HeaderCollectionViewCell.h
//  calendar
//
//  Created by Фёдор Морев on 6/30/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderCollectionViewCell : UICollectionViewCell
@property(assign, nonatomic) BOOL isToday;

@property(strong, nonatomic) UIView *viewFlag;
@property(strong, nonatomic) UILabel *labelDay;
@property(strong, nonatomic) UILabel *labelDaySymbol;
@end
