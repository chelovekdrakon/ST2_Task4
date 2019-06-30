//
//  ContentViewController.h
//  calendar
//
//  Created by Фёдор Морев on 6/30/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContentViewControllerDelegate <NSObject>
@end

@interface ContentViewController : UICollectionViewController
@property(weak, nonatomic) UIViewController <ContentViewControllerDelegate> *controllerDelegate;
- (void)updateDataModel:(NSArray *)nextDataModel;
@end
