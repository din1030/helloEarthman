//
//  BadgeHeaderView.h
//  wakeup
//
//  Created by din1030 on 13/6/8.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeHeaderView : UICollectionReusableView
@property(atomic,strong) IBOutlet UILabel *title;
@property(atomic,strong) IBOutlet UIImageView *badge_type;
@end
