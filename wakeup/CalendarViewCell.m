//
//  CalendarViewCell.m
//  wakeup
//
//  Created by din1030 on 13/6/8.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import "CalendarViewCell.h"

@implementation CalendarViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [_date_num release];
    [_badge_thumb release];
    [super dealloc];
}
@end
