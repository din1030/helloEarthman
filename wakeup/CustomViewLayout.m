//
//  CustomViewLayout.m
//  test
//
//  Created by Toby Hsu on 13/6/2.
//  Copyright (c) 2013年 Toby Hsu. All rights reserved.
//

#import "CustomViewLayout.h"
#import "BadgeHeaderView.h"

#define ITEM_SIZE 80
#define TOP 50

@implementation CustomViewLayout

-(void)prepareLayout
{
    [super prepareLayout];
}

//设置collectionViewContentsize
- (CGSize) collectionViewContentSize{
    return CGSizeMake(self.collectionView.frame.size.width,([self.collectionView numberOfItemsInSection:0]+[self.collectionView numberOfItemsInSection:1])/ 5 * 2 * (ITEM_SIZE+40));
}

//设置UICollectionViewLayoutAttributes
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //算row&column
    if (indexPath.item%5==0)
    {
        row = indexPath.item/5*2;
        column=0;
    }
    else
    {
        if (indexPath.item%5==2)
        {
            column=0;
            row = (indexPath.item-indexPath.item/5)/2;
        }
        else
            column++;
    }
#warning Clean out the code
    int cur_section = indexPath.section;
    int screen_width = self.collectionView.bounds.size.width;
    attributes.size = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
    // 判斷column奇偶數做置中
    if (cur_section==0) {
        if(row%2==1)
            attributes.center = CGPointMake( (screen_width-ITEM_SIZE*3)/2 + ITEM_SIZE/2 + ITEM_SIZE*column + (column-1)*20,TOP+ITEM_SIZE/2 + ITEM_SIZE*row + (row+1)*20);
        else
            attributes.center = CGPointMake( (screen_width-ITEM_SIZE*2)/2 + ITEM_SIZE/2 + ITEM_SIZE*column + (column-1)*20,TOP+ITEM_SIZE/2 + ITEM_SIZE*row + (row+1)*20);
    }
    else if(cur_section==1) {
        if(row%2==1)
            attributes.center = CGPointMake( (screen_width-ITEM_SIZE*3)/2 + ITEM_SIZE/2 + ITEM_SIZE*column + (column-1)*20, TOP+ITEM_SIZE/2 + ITEM_SIZE*row + (row+1)*20+850);
        else
            attributes.center = CGPointMake( (screen_width-ITEM_SIZE*2)/2 + ITEM_SIZE/2 + ITEM_SIZE*column + (column-1)*20,TOP+ITEM_SIZE/2 + ITEM_SIZE*row + (row+1)*20+850);
    }
    
    return attributes;
}

//用来在一开始给出一套UICollectionViewLayoutAttributes
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* attributes = [NSMutableArray array];
    
    for (NSUInteger k =0 ; k < self.collectionView.numberOfSections; k++) {
        for (NSInteger i=0 ; i < [self.collectionView numberOfItemsInSection:k]; i++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:k];
            //这里利用了-layoutAttributesForItemAtIndexPath:来获取attributes
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
            if (i == [self.collectionView numberOfItemsInSection:k] - 1) {
                [attributes addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath]];
            }
            //NSLog(@"%d,%d",k,i);
        }
    }
    return attributes;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) { // 如果是 header
        if (indexPath.section==0) {
            attributes.size = CGSizeMake(self.collectionView.frame.size.width,TOP);
            attributes.center = CGPointMake(self.collectionView.frame.size.width/2,TOP/2);
        }
        else if (indexPath.section==1) {
            attributes.size = CGSizeMake(self.collectionView.frame.size.width,1700+TOP);
            attributes.center = CGPointMake(self.collectionView.frame.size.width/2,1700+TOP/2);
            
        }
        else
            NSLog(@"wrong header at sec %d,item %d",indexPath.section,indexPath.item);
    }
    return attributes;
}
@end
