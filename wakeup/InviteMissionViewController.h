//
//  InviteMissionViewController.h
//  wakeup
//
//  Created by din1030 on 13/6/14.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteMissionViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lv_num;
@property (strong, nonatomic) IBOutlet UIProgressView *invite_progress;
@property (nonatomic) NSUInteger now_inv_amount;
@property (nonatomic) NSUInteger req_amount;
@property (retain, nonatomic) IBOutlet UILabel *now_label;
@property (retain, nonatomic) IBOutlet UILabel *req_label;
@end