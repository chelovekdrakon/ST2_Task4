//
//  CollectionViewController.h
//  calendar
//
//  Created by Фёдор Морев on 6/29/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeaderViewControllerDelegate <NSObject>
@end

@interface HeaderViewController : UICollectionViewController
@property(weak, nonatomic) UIViewController <HeaderViewControllerDelegate> *controllerDelegate;
@end
