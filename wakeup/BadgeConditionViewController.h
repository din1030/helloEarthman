//
//  BadgeConditionViewController.h
//  wakeup
//
//  Created by Toby Hsu on 13/6/6.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeConditionViewController : UIViewController
@property (strong) NSString *b_id; // 接收徽章 id
@property (strong) NSString *b_type; // 接收徽章 type
@property (retain, nonatomic) IBOutlet UIImageView *badge_image;
@property (retain, nonatomic) IBOutlet UILabel *badge_description;
@property (retain, nonatomic) IBOutlet UILabel *badge_condition;
@end
