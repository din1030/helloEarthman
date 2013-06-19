//
//  CalHeaderView.h
//  wakeup
//
//  Created by Toby Hsu on 13/6/19.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalHeaderView : UICollectionReusableView
@property(atomic,strong) IBOutlet UILabel *month_title;
@property(atomic,strong) IBOutlet UIButton *next_month;
@property(atomic,strong) IBOutlet UIButton *prev_month;

- (void)next_monthClick;
- (void)prev_monthClick;
@end
