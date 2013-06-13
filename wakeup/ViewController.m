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
        [self.window setImage:[UIImage imageNamed:@"room_night.png"]];
    else
        [self.window setImage:[UIImage imageNamed:@"room_day.png"]];
    
    _itemlist = [[NSArray alloc] initWithObjects:_alarm,_calendar,nil];
    _random_timer = [NSTimer scheduledTimerWithTimeInterval:5  // 遊戲秒數
                                                     target:self
                                                   selector:@selector(shake_animation)
                                                   userInfo:nil
                                                    repeats:YES];
}

- (void) shake_animation
{
    int r = arc4random_uniform(2);
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    UIButton *btn = [_itemlist objectAtIndex:r];
    CGPoint ori_point = btn.center;
    int offset = 5;
    keyFrame.values = @[[NSValue valueWithCGPoint:CGPointMake(ori_point.x-offset,ori_point.y+offset)],
                        [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(ori_point.x+offset,ori_point.y+offset)],
                        [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(ori_point.x+offset,ori_point.y+offset)],
                        [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(ori_point.x-offset,ori_point.y+offset)]];
    keyFrame.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    keyFrame.duration=0.5;
    btn.layer.position = ori_point;
    [btn.layer addAnimation:keyFrame forKey:@"keyFrame"];
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
    [super dealloc];
}

@end
