//
//  HeaderViewFlowLayout.m
//  calendar
//
//  Created by Фёдор Морев on 7/6/19.
//  Copyright © 2019 Фёдор Морев. All rights reserved.
//

#import "HeaderViewFlowLayout.h"

@interface HeaderViewFlowLayout()
@property(strong, nonatomic) NSArray *layoutArr;

@property(assign, nonatomic) CGSize currentContentSize;
@end

@implementation HeaderViewFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.layoutArr = [self generateLayout];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    self.layoutArr = [self generateLayout];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.layoutArr;
}

- (CGSize)collectionViewContentSize {
    return self.currentContentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    for (UICollectionViewLayoutAttributes *attrs in self.layoutArr) {
        if ([attrs.indexPath isEqual:indexPath]) {
            return attrs;
        }
    }
    
    return nil;
}

- (NSArray *)generateLayout {
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSInteger sectionsCount = 1;
    
    if ([self.collectionView.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        sectionsCount = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    }
    
//    float width = self.collectionView.bounds.size.width;
    float xOffset = 0;
    float yOffset = 0;
    
    for (NSInteger section = 0; section < sectionsCount; section++) {
        NSInteger itemsCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemsCount; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attrs.frame = CGRectMake(xOffset, yOffset, self.cellSize.width, self.cellSize.height);
            
            [resultArray addObject:attrs];
            
            xOffset += self.cellSize.width;
        }
        
        yOffset += self.cellSize.height;
    }
    
    self.currentContentSize = CGSizeMake(xOffset, yOffset);
    
    return resultArray;
}

@end
