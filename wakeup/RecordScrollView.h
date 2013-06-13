//
//  RecordScrollView.h
//  wakeup
//
//  Created by din1030 on 13/5/27.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCLineChartView.h"

@interface RecordScrollView : UIScrollView
@property (nonatomic, strong) PCLineChartView *lineChartView;
@property (nonatomic) NSUInteger tab_index;
@end
