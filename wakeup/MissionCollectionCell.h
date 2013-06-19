//
//  MissionCollectionCell.h
//  wakeup
//
//  Created by din1030 on 13/5/28.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MissionCollectionCell : UICollectionViewCell
//@property (strong,nonatomic) IBOutlet UIButton *mission_button;
//@property (weak, nonatomic) IBOutlet UIImageView *mission_icon;
@property (strong,nonatomic)  NSString *cell_id;
@property (retain, nonatomic) IBOutlet UIImageView *thumbnail;
@property (retain, nonatomic) IBOutlet UIImageView *lock;


@end
