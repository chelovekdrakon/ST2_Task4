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
@property(strong, nonatomic) NSDate *currentDate;
@property(strong, nonatomic) NSCalendar *calendar;

@property(strong, nonatomic) NSArray <NSDate *> *weekDates;
@property(strong, nonatomic) NSArray <NSNumber *> *weekDays;
@property(strong, nonatomic) NSArray <NSString *> *weekDaysSymbols;

@property(assign, nonatomic) NSInteger currentDayIndex;
@property(assign, nonatomic) NSInteger selectedDayIndex;
@end


@implementation HeaderViewController

#pragma mark - Lifecycle

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.currentDate = [NSDate date];
        [self initLocalCalendar];
        
        NSInteger dayIndex = [self getWeekDayIndex];
        self.currentDayIndex = dayIndex;
        self.selectedDayIndex = dayIndex;
        
        self.weekDates = [self getWeekDatesForDate:self.currentDate];
        self.weekDays = [self getWeekDaysFromDates:self.weekDates];
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
    HeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    cell.labelDay.text = [NSString stringWithFormat:@"%@", self.weekDays[indexPath.row]];
    [cell.labelDay sizeToFit];
    
    cell.labelDaySymbol.text = [NSString stringWithFormat:@"%@", self.weekDaysSymbols[indexPath.row]];
    cell.labelDaySymbol.frame = CGRectMake(0, CGRectGetHeight(cell.labelDay.bounds), 0, 0);
    [cell.labelDaySymbol sizeToFit];
    
    if ([self.calendar isDateInToday:self.weekDates[indexPath.row]]) {
        cell.isToday = YES;
        cell.viewFlag.frame = CGRectMake(0, CGRectGetMaxY(cell.labelDaySymbol.frame), 3, 3);
        cell.viewFlag.layer.backgroundColor = [UIColor whiteColor].CGColor;
        cell.viewFlag.layer.cornerRadius = 2.f;
    }
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedDayIndex = indexPath.row;
    
    if ([self.controllerDelegate conformsToProtocol:@protocol(HeaderViewControllerDelegate)]) {
        [self.controllerDelegate didSelectDate:self.weekDates[indexPath.row]];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(40, 40);
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer     shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Handlers

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipeRecognizer {
    if (swipeRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Swipe Right!");
        [self changeWeekDatesTo:-1];
    } else if (swipeRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Swipe Left!");
        [self changeWeekDatesTo:1];
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

- (void)changeWeekDatesTo:(NSInteger )index {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.weekOfYear = index;
    
    NSDate *dateNextWeek = [self.calendar dateByAddingComponents:components toDate:self.currentDate options:NSCalendarWrapComponents];
    self.currentDate = dateNextWeek;
    NSArray <NSDate *> *weekDates = [self getWeekDatesForDate:dateNextWeek];
    NSArray <NSNumber *> *weekDays = [self getWeekDaysFromDates:weekDates];
    
    self.weekDays = weekDays;
    self.weekDates = weekDates;
    [self.collectionView reloadData];
}

- (NSArray *)getWeekDatesForDate:(NSDate *)date {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = -self.currentDayIndex;
    NSDate *weekStart = [self.calendar dateByAddingComponents:components toDate:date options:NSCalendarWrapComponents];
    
    NSMutableArray *weekDates = [NSMutableArray array];
    
    for (int i = 0; i < 7; i++) {
        components.day = i;
        NSDate *date = [self.calendar dateByAddingComponents:components toDate:weekStart options:NSCalendarWrapComponents];

        [weekDates addObject:date];
    }
    
    return weekDates;
}

- (NSArray <NSNumber *> *)getWeekDaysFromDates:(NSArray <NSDate *> *)dates {
    NSMutableArray *weekDays = [NSMutableArray array];
    
    for (NSDate *date in dates) {
        NSInteger weekDayDate = [self.calendar component:NSCalendarUnitDay fromDate:date];
        [weekDays addObject:@(weekDayDate)];
    }
    
    return weekDays;
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
    NSDateComponents *components = [self.calendar components:NSCalendarUnitWeekday
                                                    fromDate:self.currentDate];
    
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
