//
//  CalendarCollectionViewController.h
//  wakeup
//
//  Created by din1030 on 13/6/5.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CalendarCollectionViewController : UICollectionViewController
@property (atomic,strong) NSMutableArray *dailyInfo;
@property (nonatomic) int startday, maxmonthday;

+ (int) Getselectmonth;
+ (void) Setselectmonth:(int)m;
@end
