//
//  CollectionViewCell.h
//  calendar
//
//  Created by Фёдор Морев on 6/29/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>


@interface CollectionViewCell : UICollectionViewCell

-(void)setEvent:(EKEvent *)event;

@end
