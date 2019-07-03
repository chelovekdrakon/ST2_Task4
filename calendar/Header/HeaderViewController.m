//
//  CollectionViewController.m
//  calendar
//
//  Created by Фёдор Морев on 6/29/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import "HeaderViewController.h"
#import "HeaderCollectionViewCell.h"
#import <EventKit/EventKit.h>
#import "Colors.h"

static NSString * const cellReuseIdentifier = @"cell";

@interface HeaderViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>
@property(strong, nonatomic) NSCalendar *calendar;
@property(strong, nonatomic) NSArray *weekDates;
@property(strong, nonatomic) NSArray *weekDaysSymbols;

@property(assign, nonatomic) NSInteger dayIndex;
@property(assign, nonatomic) NSInteger selectedDayIndex;
@end


@implementation HeaderViewController

#pragma mark - Lifecycle

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        [self initLocalCalendar];
        
        NSInteger dayIndex = [self getWeekDayIndex];
        self.dayIndex = dayIndex;
        self.selectedDayIndex = dayIndex;
        
        self.weekDates = [self getWeekDates];
        self.weekDaysSymbols = [self getWeekDaySymbols];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [Colors darkBlueColor];
    self.collectionView.pagingEnabled = YES;
    
    [self setSwipeRecognizers];
    
    [self.collectionView registerClass:[HeaderCollectionViewCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (HeaderCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    HeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:eventCellReuseIdentifier forIndexPath:indexPath];
//
//    cell.backgroundColor = [UIColor yellowColor];
//    NSArray *sectionModel = self.dataModel[indexPath.section];
//    [cell setEvent:sectionModel[indexPath.row]];
    
    HeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UIollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer     shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Handlers

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipeRecognizer {
    if (swipeRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Swipe Right!");
    } else if (swipeRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Swipe Left!");
    }
}

#pragma mark - Helpers

- (void)setSwipeRecognizers {
    UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    rightSwipeRecognizer.delegate = self;
    
    UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    leftSwipeRecognizer.delegate = self;
    
    [self.collectionView addGestureRecognizer:rightSwipeRecognizer];
    [self.collectionView addGestureRecognizer:leftSwipeRecognizer];
}

#pragma mark - Utils

- (NSArray *)getWeekDates {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = -self.dayIndex;
    NSDate *weekStart = [self.calendar dateByAddingComponents:components toDate:[NSDate date] options:NSCalendarWrapComponents];
    
    NSMutableArray *dates = [NSMutableArray array];
    
    for (int i = 0; i < 7; i++) {
        components.day = i;
        NSDate *date = [self.calendar dateByAddingComponents:components toDate:weekStart options:NSCalendarWrapComponents];
        NSInteger weekDay = [self.calendar component:NSCalendarUnitDay fromDate:date];
        [dates addObject:@(weekDay)];
    }
    
    return dates;
}

- (void)initLocalCalendar {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSLocale *locale = [[NSLocale alloc]
                        initWithLocaleIdentifier:@"ru"];
    [calendar setLocale:locale];
    [calendar setFirstWeekday:2];
    
    self.calendar = calendar;
}

- (NSInteger)getWeekDayIndex {
    NSDate *now = [NSDate date];
    NSDateComponents *components = [self.calendar components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitWeekday
                                                    fromDate:now];
    
    return (components.weekday == 1)
    ? 6
    : (components.weekday - 2);
}

- (NSArray *)getWeekDaySymbols {
    NSMutableArray *weekDaySymbols = [[self.calendar shortWeekdaySymbols] mutableCopy];
    NSString *sunday = [weekDaySymbols firstObject];
    [weekDaySymbols removeObjectAtIndex:0];
    [weekDaySymbols addObject:sunday];
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSString *day in weekDaySymbols) {
        [result addObject:[day uppercaseString]];
    }
    
    return result;
}

@end
