//
//  MainViewController.m
//  calendar
//
//  Created by Фёдор Морев on 6/30/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import <EventKit/EventKit.h>

#import "Colors.h"
#import "MainViewController.h"
#import "HeaderViewController.h"
#import "ContentViewController.h"

CGFloat const paddings = 16;


@interface MainViewController ()
@property(strong, nonatomic) HeaderViewController *headerController;
@property(strong, nonatomic) ContentViewController *contentController;

@property(strong, nonatomic) NSMutableArray <NSArray *> *dataModel;
@property(strong, nonatomic) EKEventStore *eventStore;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Boo!";
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    
    bar.barTintColor = [Colors darkBlueColor];
    bar.titleTextAttributes = @{NSForegroundColorAttributeName: [Colors whiteColor]};
    
    [self layoutCollectionViews];
    
    self.eventStore = [[EKEventStore alloc] init];
    
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        [self fetchWeekEvents];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.headerController updateDataModel:self.dataModel];
        });
    }];
}

#pragma mark - UI Generators

- (void)layoutCollectionViews {
    UINavigationBar *bar = [self.navigationController navigationBar];
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    
    NSInteger navBarHeight = bar.frame.size.height + statusBarFrame.size.height;
    
    UICollectionViewFlowLayout* headerFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [headerFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionViewFlowLayout* contentFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [contentFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.headerController = [[HeaderViewController alloc] initWithCollectionViewLayout:headerFlowLayout];
    self.contentController = [[ContentViewController alloc] initWithCollectionViewLayout:contentFlowLayout];
    
    self.headerController.collectionView.pagingEnabled = YES;
    self.headerController.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.headerController.collectionView];
    [self.view addSubview:self.contentController.collectionView];
    
    self.headerController.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentController.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
      [self.headerController.collectionView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:paddings],
      [self.headerController.collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:navBarHeight],
      [self.headerController.collectionView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-paddings],
      [self.headerController.collectionView.bottomAnchor constraintEqualToAnchor:self.view.topAnchor constant:navBarHeight + 100],
    ]];
    
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGFloat bottomPadding = window.safeAreaInsets.bottom;
    
    self.contentController.collectionView.contentInset = UIEdgeInsetsMake(0, paddings, bottomPadding, paddings);

    [NSLayoutConstraint activateConstraints:@[
      [self.contentController.collectionView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
      [self.contentController.collectionView.topAnchor constraintEqualToAnchor:self.headerController.collectionView.bottomAnchor],
      [self.contentController.collectionView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor],
      [self.contentController.collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-bottomPadding],
    ]];
}

#pragma mark - Helpers

- (void)fetchWeekEvents {
    for (int i = 0; i < 7; i++) {
        NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSinceNow:(60 * 60 * 24 * i)];
        NSDate *endDate = [[NSDate alloc] initWithTimeIntervalSinceNow:(60 * 60 * 24 * (i + 1))];
        NSPredicate *pred = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
        NSArray *events = [self.eventStore eventsMatchingPredicate:pred];
        [self.dataModel addObject:events];
    }
}

@end
