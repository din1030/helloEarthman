//
//  BadgeHeaderView.m
//  wakeup
//
//  Created by din1030 on 13/6/8.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import "BadgeHeaderView.h"

@implementation BadgeHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(10, 50 , 300, 3.0)];
//        horizontalLine.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
//        [self  addSubview:horizontalLine];
//        
//        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320,60)];
//        self.title.font = [UIFont systemFontOfSize:20];
//        self.title.textColor = [UIColor whiteColor];
//        self.title.backgroundColor = [UIColor clearColor];
//        self.title.textAlignment = NSTextAlignmentCenter;
//        [self.title setCenter:CGPointMake( frame.size.width/2,frame.size.height/2)];
//        [self addSubview:self.title];
//        
//        [self addSubview:horizontalLine];
//        [horizontalLine release];
        
        _badge_type = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 288, 31)];
        [_badge_type setCenter:CGPointMake(frame.size.width/2,frame.size.height/2+10)];
        [self addSubview:_badge_type];

        
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

@end
