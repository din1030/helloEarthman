//
//  BadgeCollectionCell.h
//  wakeup
//
//  Created by Toby Hsu on 13/6/6.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeCollectionCell : UICollectionViewCell
@property (retain, nonatomic) IBOutlet UIImageView *badge_thumbnail;
@property (strong,nonatomic)  NSString *cell_id;
@property (strong,nonatomic)  NSString *cell_type;
@end
