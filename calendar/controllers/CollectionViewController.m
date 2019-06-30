//
//  CollectionViewController.m
//  calendar
//
//  Created by Фёдор Морев on 6/29/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import <EventKit/EventKit.h>

static NSString * const reuseIdentifier = @"Cell";

@interface CollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property(assign, nonatomic) NSInteger dayIndex;

@property(strong, nonatomic) EKEventStore *eventStore;
@property(strong, nonatomic) NSMutableArray <NSArray *> *dataModel;
@end


@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dayIndex = 0;
    self.dataModel = [[NSMutableArray alloc] init];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.eventStore = [[EKEventStore alloc] init];

    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        for (int i = 0; i < 7; i++) {
            NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSinceNow:(60 * 60 * 24 * i)];
            NSDate *endDate = [[NSDate alloc] initWithTimeIntervalSinceNow:(60 * 60 * 24 * (i + 1))];
            NSPredicate *pred = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
            NSArray *events = [self.eventStore eventsMatchingPredicate:pred];
            [self.dataModel addObject:events];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.dataModel count] > self.dayIndex) {
        return [self.dataModel[self.dayIndex] count];
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor blackColor];
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
