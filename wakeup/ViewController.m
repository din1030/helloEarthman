//
//  ViewController.m
//  wakeup
//
//  Created by din1030 on 13/5/8.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "BrainHoleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DataBase.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 設定 back button
    UIImage *backButtonIMG = [[UIImage imageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 21, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonIMG forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UINavigationBar *bar = self.navigationController.navigationBar ;
    bar.topItem.title = @" ";
    
    // notification後進入遊戲
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if (appDelegate.isAlarm)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Game:)
                                                 name:@"appDidBecomeActive"
                                               object:nil];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    //正規化的格式設定
    [formatter setDateFormat:@"HH:mm:ss"];
    //正規化取得的系統時間並顯示
    NSArray * timeArray = [[formatter stringFromDate:date] componentsSeparatedByString:@":"];
    if ([timeArray[0] intValue]>=19 || [timeArray[0] intValue]<=6)
        [self.window setImage:[UIImage imageNamed:@"room_w2.png"]];
    else
        [self.window setImage:[UIImage imageNamed:@"room_w1.png"]];
    [formatter release];
    
    //更改錨點
    [_badgetable .layer setAnchorPoint:CGPointMake(0.5,0)];
    _badgetable.center = CGPointMake(_badgetable.center.x, _badgetable.center.y-_badgetable.frame.size.height/2);
    
    _itemlist = [[NSArray alloc] initWithObjects:_alarm, _calendar, _badgetable, _theme, _setting, _window, nil];
    _random_timer = [NSTimer scheduledTimerWithTimeInterval:15  // 遊戲秒數
                                                     target:self
                                                   selector:@selector(item_animation)
                                                   userInfo:nil
                                                    repeats:YES];
    
    _theme_index=0;
    _themelist = [[NSMutableArray alloc] initWithObjects: nil];
    FMResultSet *rs = nil;
    rs = [DataBase executeQuery:@"SELECT id FROM THEME"];
    [_themelist addObject:@"room"];  //default theme
    [_themelist addObject:@"6YaLTunYln"];  //default theme
    //等待DB的圖檔健全
    //    while ([rs next])
    //    {
    //        NSString *t_id = [rs stringForColumn:@"id"];
    //        [_itemlist addObject:t_id];
    //    }
    [rs close];

}

- (void) item_animation
{
    int r = arc4random_uniform(5);
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrame.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    UIButton *btn = [_itemlist objectAtIndex:r];
    CGPoint ori_point = btn.center;
    int offset = 3;
    switch (r)
    {
        case 0:
            keyFrame.values = @[[NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x-offset,ori_point.y-offset)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x+offset,ori_point.y-offset)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x-offset,ori_point.y-offset)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x+offset,ori_point.y-offset)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y)]];
            keyFrame.duration=0.2;
            [btn.layer addAnimation:keyFrame forKey:@"keyFrame"];
            break;
        case 1:
            keyFrame.values = @[[NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset*2)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset*3)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset*4)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset*3)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset*2)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y)]];
            keyFrame.duration=0.7;
            [btn.layer addAnimation:keyFrame forKey:@"keyFrame"];
            break;
        case 2:
            keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
            keyFrame.values = @[[NSNumber numberWithFloat:DegreeToRadian(30)],
                                [NSNumber numberWithFloat:DegreeToRadian(0)],
                                [NSNumber numberWithFloat:DegreeToRadian(-30)],
                                [NSNumber numberWithFloat:DegreeToRadian(0)],
                                [NSNumber numberWithFloat:DegreeToRadian(30)],
                                [NSNumber numberWithFloat:DegreeToRadian(0)]];
            keyFrame.duration=1.4;
            [btn.layer addAnimation:keyFrame forKey:@"keyFrame"];
            break;
        case 3:
        case 4:
            btn.alpha = 1.0f;
            [UIView animateWithDuration:1
                                  delay:0.5
                                options:UIViewAnimationOptionCurveEaseInOut  | UIViewAnimationOptionAutoreverse
                             animations:^{
                                 btn.alpha = 0.0f;
                             }
                             completion:^(BOOL finished){
                                 btn.alpha = 1.0f;
                             }];
            break;
        case 5:
            break;
            
    }
}

CGFloat DegreeToRadian(CGFloat degrees)
{
    degrees = (int)degrees%360;
    return degrees * M_PI / 180;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)Game:(NSString *)clock_id
{
    // 切換clock_id對應的遊戲
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isAlarm = NO;
    BrainHoleViewController *brainhole_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GamePage"];
    [self.navigationController pushViewController:brainhole_vc animated:NO];
}

- (IBAction)theme_OnClick:(UIButton *)sender {
    if (_theme_index==[_themelist count]-1)
        _theme_index=0;
    else
        _theme_index++;
    [_background setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_bg.png",[_themelist objectAtIndex:_theme_index]]]];
    [_alarm setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_a.png",[_themelist objectAtIndex:_theme_index]]] forState:UIControlStateNormal];
    [_calendar setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_c.png",[_themelist objectAtIndex:_theme_index]]] forState:UIControlStateNormal];
    [_badgetable setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_mb.png",[_themelist objectAtIndex:_theme_index]]] forState:UIControlStateNormal];
    [_theme setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_t.png",[_themelist objectAtIndex:_theme_index]]] forState:UIControlStateNormal];
    [_setting setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_s.png",[_themelist objectAtIndex:_theme_index]]] forState:UIControlStateNormal];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    //正規化的格式設定
    [formatter setDateFormat:@"HH:mm:ss"];
    //正規化取得的系統時間並顯示
    NSArray * timeArray = [[formatter stringFromDate:date] componentsSeparatedByString:@":"];
    if ([timeArray[0] intValue]>=19 || [timeArray[0] intValue]<=6)
        [self.window setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_w2.png",[_themelist objectAtIndex:_theme_index]]]];
    else
        [self.window setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_w1.png",[_themelist objectAtIndex:_theme_index]]]];
    [formatter release];
}


- (void)dealloc {
    [_window release];
    [_alarm release];
    [_badgetable release];
    [_theme release];
    [_calendar release];
    [_setting release];
    [_random_timer invalidate];
    [_itemlist release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_background release];
    [super dealloc];
}

@end
