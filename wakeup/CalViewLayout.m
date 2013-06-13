//
//  CalViewLayout.m
//  wakeup
//
//  Created by din1030 on 13/6/6.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import "CalViewLayout.h"
#import "CalendarViewCell.h"

#define ITEM_SIZE 53

@implementation CalViewLayout

-(void)prepareLayout
{
    [super prepareLayout];
}

//设置collectionViewContentsize
- (CGSize) collectionViewContentSize{
    return CGSizeMake(self.collectionView.frame.size.width,self.collectionView.frame.size.height);
}

//设置UICollectionViewLayoutAttributes
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // 計算位置
    row = indexPath.item / 5;
    column = indexPath.item % 5;
    
    attributes.size = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
    attributes.center = CGPointMake(43+column*(ITEM_SIZE+3), 112+row*(ITEM_SIZE+2));
    
    return attributes;
}

//用来在一开始给出一套UICollectionViewLayoutAttributes
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* attributes = [NSMutableArray array];
    
//    for (NSUInteger k =0 ; k < self.collectionView.numberOfSections; k++) { 只有一個 section 暫時不用
        for (NSInteger i=0 ; i < [self.collectionView numberOfItemsInSection:0]; i++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            //这里利用了-layoutAttributesForItemAtIndexPath:来获取attributes
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
            if (i == [self.collectionView numberOfItemsInSection:0] - 1) {
                [attributes addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath]];
            }
            //NSLog(@"%d,%d",k,i);
        }
//    }
    return attributes;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) { // 如果是 header
            attributes.size = CGSizeMake(self.collectionView.frame.size.width,57);
            attributes.center = CGPointMake(self.collectionView.frame.size.width/2,28);
    }
    return attributes;
}
@end
