//
//  RecordViewController.h
//  wakeup
//
//  Created by din1030 on 13/5/27.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCLineChartView.h"
#import "RecordScrollView.h"

@interface RecordViewController : UIViewController

@property (retain, nonatomic) IBOutlet RecordScrollView *record;
@property (nonatomic) NSUInteger cur_tab;
@property (retain, nonatomic) IBOutlet UIButton *prev_month;
@property (retain, nonatomic) IBOutlet UIButton *next_month;
@property (retain, nonatomic) IBOutlet UILabel *selectmonth;
- (IBAction)prev_monthClick:(UIButton *)sender;
- (IBAction)next_monthClick:(UIButton *)sender;
@end
