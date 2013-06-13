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
@end
