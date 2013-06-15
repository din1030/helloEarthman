//
//  MIssionConditionViewController.h
//  wakeup
//
//  Created by din1030 on 13/5/28.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MIssionConditionViewController : UIViewController
@property (strong) NSString *m_id; // 接收任務 id
@property (retain, nonatomic) IBOutlet UIImageView *mission_image;
@property (retain, nonatomic) IBOutlet UILabel *mission_description;
@property (retain, nonatomic) IBOutlet UILabel *mission_condition;
@property (retain, nonatomic) IBOutlet UIView *mission_badges;
@property (retain, nonatomic) IBOutlet UIView *badge_req;
@end
