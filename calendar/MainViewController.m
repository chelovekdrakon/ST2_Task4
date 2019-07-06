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


@interface MainViewController () <HeaderViewControllerDelegate, ContentViewControllerDelegate>
@property(strong, nonatomic) HeaderViewController *headerController;
@property(strong, nonatomic) ContentViewController *contentController;

@property(strong, nonatomic) EKEventStore *eventStore;
@property(strong, nonatomic) NSDateFormatter *titleFormatter;
@property(strong, nonatomic) NSMutableArray <NSArray *> *dataModel;
@end

@implementation MainViewController

#pragma mark - Lifecycle

- (id)init {
    self = [super init];
    if (self) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru"];
        dateFormatter.dateFormat = @"dd MMMM YYYY";
        self.titleFormatter = dateFormatter;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self styleNavBar];
    [self setTitleFromDate:[NSDate date]];
    [self layoutHeaderCollectionView];
    [self layoutContentCollectionView];
    
    self.eventStore = [[EKEventStore alloc] init];
    
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        [self fetchWeekEvents];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentController updateDataModel:self.dataModel];
        });
    }];
}


#pragma mark - UI Generators

- (void)layoutHeaderCollectionView {
    UICollectionViewFlowLayout* headerFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [headerFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    self.headerController = [[HeaderViewController alloc] initWithCollectionViewLayout:headerFlowLayout];
    
    self.headerController.controllerDelegate = self;
    self.headerController.collectionView.pagingEnabled = YES;
    self.headerController.collectionView.showsHorizontalScrollIndicator = NO;
    self.headerController.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:self.headerController.collectionView];
    
    [NSLayoutConstraint activateConstraints:@[
      [self.headerController.collectionView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
      [self.headerController.collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
      [self.headerController.collectionView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor],
      [self.headerController.collectionView.bottomAnchor constraintEqualToAnchor:self.view.topAnchor constant:100],
    ]];
}

- (void)layoutContentCollectionView {
    UICollectionViewFlowLayout* contentFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [contentFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.contentController = [[ContentViewController alloc] initWithCollectionViewLayout:contentFlowLayout];
    
    self.contentController.controllerDelegate = self;
    self.contentController.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleHorizontalSwipe:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.contentController.collectionView addGestureRecognizer:swipeRecognizer];
    
    [self.view addSubview:self.contentController.collectionView];
    
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

#pragma mark - Handlers

- (void)handleHorizontalSwipe:(UISwipeGestureRecognizer *)swipeRecognizer {
    NSLog(@"Swipe left! Move header right!");
}

#pragma mark - <HeaderViewControllerDelegate>

- (void)didSelectDate:(NSDate *)date {
    [self setTitleFromDate:date];
}

#pragma mark - Helpers

- (void)setTitleFromDate:(NSDate *)date {
    NSString *title = [self.titleFormatter stringFromDate:date];
    self.navigationItem.title = title;
}

- (void)styleNavBar {
    UINavigationBar *bar = [self.navigationController navigationBar];
    
    bar.translucent = NO;
    bar.barTintColor = [Colors darkBlueColor];
    bar.titleTextAttributes = @{NSForegroundColorAttributeName: [Colors whiteColor]};
}

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
