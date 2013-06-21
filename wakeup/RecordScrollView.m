//
//  RecordScrollView.m
//  wakeup
//
//  Created by din1030 on 13/5/27.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import "RecordScrollView.h"
#import "FMDatabase.h"
#import "DataBase.h"

static int select_month;
@implementation RecordScrollView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self)
	{
        [_lineChartView removeFromSuperview];
        [self Drawlinechart:[self UpdateData]];
    }
    return self;
}

- (NSMutableArray*) UpdateData
{
    NSMutableArray *data_ar = [NSMutableArray array];
    NSLog(@"month=%d",select_month);
    // 取得現有資料，並依資料數量決定 view 大小
    FMResultSet *rs = nil;
#warning  how to cahnge month
    if ([self.restorationIdentifier isEqualToString:@"stat1"]) {
        NSLog(@"%d",_tab_index);
        rs = [DataBase executeQuery:[NSString stringWithFormat:@"SELECT duration_time FROM DAILY_RECORD WHERE date like '%%-%02d-%%'",select_month]];
        while ([rs next])
        {
            NSString *data = [rs stringForColumnIndex:0];
            NSLog(@"data: %@",data);
            [data_ar addObject:[NSString stringWithFormat:@"%@",data]];
            
        }
    } else if ([self.restorationIdentifier isEqualToString:@"stat2"]) {
        NSLog(@"%d",_tab_index);
        rs = [DataBase executeQuery:[NSString stringWithFormat:@"SELECT wake_time FROM DAILY_RECORD WHERE date like '%%-%02d-%%'",select_month]];
        while ([rs next])
        {
            NSString *time = [rs stringForColumnIndex:0];
            NSArray * timeArray = [time componentsSeparatedByString:@":"];
            NSUInteger data = [timeArray[0] intValue];
            NSLog(@"data: %@",timeArray[0]);
            [data_ar addObject:[NSString stringWithFormat:@"%d",data]];
        }
    }
    return data_ar;
}

- (void) Drawlinechart:(NSMutableArray*)data_ar
{
    int data_amount = [data_ar count];
    // 設定折線圖 view 大小位置 及 y 軸最大最小值
    _lineChartView = [[PCLineChartView alloc] initWithFrame:CGRectMake(10,50,data_amount*30+100,[self bounds].size.height-80)];
    if ([self.restorationIdentifier isEqualToString:@"stat1"]) {
        NSLog(@"%d",_tab_index);
        [_lineChartView setMinValue:0];
        [_lineChartView setMaxValue:12];
        
    } else if ([self.restorationIdentifier isEqualToString:@"stat2"]) {
        NSLog(@"%d",_tab_index);
        [_lineChartView setMinValue:6];
        [_lineChartView setMaxValue:14];
        [_lineChartView setInterval:1];
    }
    [self addSubview:_lineChartView];
    [_lineChartView release];
    
    // 設定 scroll veiw 大小
    [self setContentSize:CGSizeMake(self.lineChartView.frame.size.width, self.lineChartView.frame.size.height)];
    [self setScrollEnabled:YES];
    
    // 建立折線圖所需 dictionary 資料
    NSDictionary *dailyInfo = [[NSDictionary alloc] initWithObjectsAndKeys:data_ar,@"dailyData",@"din1030",@"name",nil];
    NSMutableArray *userInfo_ar = [[NSMutableArray alloc] initWithObjects:dailyInfo, nil];
    
    // 日期 for x labels
    NSMutableArray *date_ar = [NSMutableArray array];
    for (int day = 1; day <= [data_ar count]; day++)
    {
        [date_ar addObject:[NSString stringWithFormat:@"%d",day]];
    }
    NSDictionary *Info = [[NSDictionary alloc] initWithObjectsAndKeys:userInfo_ar,@"data",date_ar,@"x_labels",nil];
    
    NSMutableArray *components = [NSMutableArray array];
    for (int i = 0; i < [[Info objectForKey:@"data"] count]; i++)
    {
        // 拆 dictionary
        NSDictionary *point = [[Info objectForKey:@"data"] objectAtIndex:i];
        PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
        [component setTitle:[point objectForKey:@"name"]];
        [component setPoints:[point objectForKey:@"dailyData"]];
        [component setShouldLabelValues:YES];
        if (i==0)
        {
            [component setColour:PCColorPurle];
        }
        else if (i==1)
        {
            [component setColour:PCColorYellow];
        }
        else if (i==2)
        {
            [component setColour:PCColorOrange];
        }
        else if (i==3)
        {
            [component setColour:PCColorRed];
        }
        else if (i==4)
        {
            [component setColour:PCColorGreen];
        }
        
        [components addObject:component];
        [component release];
    }
    [_lineChartView setComponents:components];
    [_lineChartView setXLabels:[Info objectForKey:@"x_labels"]];
    [dailyInfo release];
    [userInfo_ar release];
    [Info release];
}

+ (int) Getselectmonth
{
    return select_month;
}
+ (void) Setselectmonth:(int)m
{
    select_month = m;
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
