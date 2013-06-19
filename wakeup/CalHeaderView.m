//
//  CalHeaderView.m
//  wakeup
//
//  Created by Toby Hsu on 13/6/19.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import "CalHeaderView.h"
#import "CalendarCollectionViewController.h"

@implementation CalHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:CGRectMake(0, 0, 320, 57)];
        [self setBackgroundColor:[UIColor clearColor]];
        _prev_month = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [_prev_month setCenter:CGPointMake(frame.size.width/2-40,frame.size.height/2+10)];
        [_prev_month setBackgroundImage:[UIImage imageNamed:@"left_w.png"] forState:UIControlStateNormal];
        [_prev_month addTarget:self action:@selector(prev_monthClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_prev_month];
        _month_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 48, 31)];
        [_month_title setCenter:CGPointMake(frame.size.width/2,frame.size.height/2+10)];
        [_month_title setFont:[UIFont systemFontOfSize:35]];
        [_month_title setBackgroundColor:[UIColor clearColor]];
        [_month_title setTextAlignment:NSTextAlignmentCenter];
        [_month_title setTextColor:[UIColor whiteColor]];
        [self addSubview:_month_title];
        _next_month = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [_next_month setCenter:CGPointMake(frame.size.width/2+40,frame.size.height/2+10)];
        [_next_month setBackgroundImage:[UIImage imageNamed:@"right_w.png"] forState:UIControlStateNormal];
        [_next_month addTarget:self action:@selector(next_monthClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_next_month];
    }
    return self;
}

- (void)next_monthClick
{
    if ([CalendarCollectionViewController Getselectmonth]<12)
        [CalendarCollectionViewController Setselectmonth:[CalendarCollectionViewController Getselectmonth]+1];
    else
        [CalendarCollectionViewController Setselectmonth:1];
    _month_title.text = [NSString stringWithFormat:@"%d",[CalendarCollectionViewController Getselectmonth]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCalendar" object:nil];
}
- (void)prev_monthClick
{
    if ([CalendarCollectionViewController Getselectmonth]>1)
        [CalendarCollectionViewController Setselectmonth:[CalendarCollectionViewController Getselectmonth]-1];
    else
        [CalendarCollectionViewController Setselectmonth:12];
    _month_title.text = [NSString stringWithFormat:@"%d",[CalendarCollectionViewController Getselectmonth]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateCalendar" object:nil];
}
@end
