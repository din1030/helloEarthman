//
//  BadgeCollectionCell.m
//  wakeup
//
//  Created by Toby Hsu on 13/6/6.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import "BadgeCollectionCell.h"

@implementation BadgeCollectionCell

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
    [_badge_thumbnail release];
    [super dealloc];
}
@end
