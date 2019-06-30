//
//  ContentViewController.m
//  calendar
//
//  Created by Фёдор Морев on 6/30/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import "ContentViewController.h"
#import "ContentCollectionViewCell.h"
#import <EventKit/EventKit.h>
#import "Colors.h"

static NSString * const eventCellReuseIdentifier = @"EventCell";
static NSString * const gridCellReuseIdentifier = @"GridCell";

@interface ContentViewController ()
@property(assign, nonatomic) NSInteger dayIndex;
@property(strong, nonatomic) NSArray <NSArray *> *dataModel;
@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dayIndex = 0;
    self.dataModel = [[NSArray alloc] init];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[ContentCollectionViewCell class] forCellWithReuseIdentifier:gridCellReuseIdentifier];
}

#pragma mark - Seters

- (void)updateDataModel:(NSArray *)nextDataModel {
    self.dataModel = nextDataModel;
    [self.collectionView reloadData];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 24;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    if ([self.dataModel count] > self.dayIndex) {
    //        return [self.dataModel[self.dayIndex] count];
    //    } else {
    //        return 0;
    //    }
    return 4;
}

- (ContentCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //    ContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:eventCellReuseIdentifier forIndexPath:indexPath];
    //
    //    cell.backgroundColor = [UIColor yellowColor];
    //    NSArray *sectionModel = self.dataModel[indexPath.section];
    //    [cell setEvent:sectionModel[indexPath.row]];
    
    ContentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:gridCellReuseIdentifier forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor greenColor];
    
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
