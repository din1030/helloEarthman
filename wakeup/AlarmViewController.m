//
//  AlarmViewController.m
//  wakeup
//
//  Created by Toby Hsu on 13/6/5.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import "AlarmViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BrainHoleViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>

@interface AlarmViewController ()

@end

@implementation AlarmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINavigationBar *navBar = [self.navigationController navigationBar];
    [navBar setBackgroundImage:[UIImage imageNamed:@"set_alarm_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,21,21);
    [button setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    
    [button addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    [barButtonItem release];
    
    CGPoint center = self.alarm.center;
    self.set.center = CGPointMake(center.x,center.y+120);
    self.alarm_min.center = CGPointMake(center.x,center.y);
    self.alarm_hr.center = CGPointMake(center.x,center.y);
    self.alarm_alarm.center = CGPointMake(center.x,center.y);
    self.alarm_sec.center = CGPointMake(center.x,center.y-2);
    [self.alarm_min.layer setAnchorPoint:CGPointMake(0.5,0)];
    [self.alarm_hr.layer setAnchorPoint:CGPointMake(0.5,0)];
    [self.alarm_alarm.layer setAnchorPoint:CGPointMake(0.5,0)];
    [self.alarm_sec.layer setAnchorPoint:CGPointMake(0.5,0.1)];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    appDelegate.isAlarm = NO;
    timer=[NSTimer scheduledTimerWithTimeInterval:0.03
                                           target:self
                                         selector:@selector(countUp)
                                         userInfo:nil
                                          repeats:YES];
    self.label_alarm_time.text = [NSString stringWithFormat:@"%02d:%02d",appDelegate.set_hr,appDelegate.set_min];
    
    
    flag = NO;
    NSURL* url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"turn" ofType:@"mp3"]];
    //與音樂檔案做連結
    NSError* error = nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [url release];
    
    // notification後進入遊戲
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Game:)
                                                 name:@"appDidBecomeActive"
                                               object:nil];
    
    self.alarm_alarm.transform = CGAffineTransformMakeRotation(DegreesToRadians((appDelegate.set_hr%12*60.0+appDelegate.set_min)*0.5+180));
    self.set.transform= CGAffineTransformMakeRotation(DegreesToRadians((appDelegate.set_hr%12*60.0+appDelegate.set_min)*0.5+180));
    
    center = self.set.center;
    center.x = self.mask.center.x + self.mask.frame.size.width/2 * cos(appDelegate.degree);
    center.y = self.mask.center.y - self.mask.frame.size.height/2 * sin(appDelegate.degree);
    self.set.center = center;
    
    alarm_img = [[NSArray alloc] initWithObjects:@"alarm_hole-02.png",@"alarm_spirit.png",nil];
    // 之後要讀sqlite user table的cid
    alarm_index=0;
    [self.alarm setImage:[UIImage imageNamed:[alarm_img objectAtIndex:alarm_index]]];
    
}

- (void)countUp {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.alarm_hr.transform = CGAffineTransformMakeRotation(DegreesToRadians((appDelegate.hr*60.0+appDelegate.min)*0.5+180));
    self.alarm_min.transform = CGAffineTransformMakeRotation(DegreesToRadians(appDelegate.min*6.0+180));
    self.alarm_sec.transform = CGAffineTransformMakeRotation(DegreesToRadians(appDelegate.sec*6.0+180));
}

- (void)Game:(NSString *)clock_id
{
    // 切換clock_id對應的遊戲
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isAlarm = NO;
    BrainHoleViewController *brainhole_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GamePage"];
    [self.navigationController pushViewController:brainhole_vc animated:NO];
}

CGFloat DegreesToRadians(CGFloat degrees)
{
    degrees = (int)degrees%360;
    return degrees * M_PI / 180;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_alarm release];
    [_mask release];
    [_alarm_min release];
    [_alarm_hr release];
    [_alarm_alarm release];
    [_alarm_sec release];
    [_mask release];
    [_label_alarm_time release];
    [_setalarm release];
    [timer invalidate];
    [_next_alarm release];
    [_prev_alarm release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
- (IBAction)alarm_pan:(UIPanGestureRecognizer *)sender {
    if (!flag){
        CGPoint center = self.set.center;
        CGPoint touch = [sender locationInView:self.view];
        CGPoint mask_center = self.mask.center;
        
        double rotateDegree = atan2((touch.x-mask_center.x),(touch.y-mask_center.y)) * 180.0 / M_PI -90;
        self.set.transform = CGAffineTransformMakeRotation(DegreesToRadians(360-rotateDegree-90));
        self.alarm_alarm.transform = CGAffineTransformMakeRotation(DegreesToRadians(360-rotateDegree-90));
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.set_hr = (int)abs(rotateDegree-90)/30;
        if (abs(appDelegate.set_min -(int)abs((rotateDegree-90)*2)%60)>1)
        {
            [audioPlayer setNumberOfLoops:0];
            [audioPlayer play];
        }
        appDelegate.set_min = (int)abs((rotateDegree-90)*2)%60;
        self.label_alarm_time.text = [NSString stringWithFormat:@"%02d:%02d",appDelegate.set_hr,appDelegate.set_min];
        center.x = self.mask.center.x + self.mask.frame.size.width/2 * cos(rotateDegree*(M_PI/180));
        center.y = self.mask.center.y - self.mask.frame.size.height/2 * sin(rotateDegree*(M_PI/180));
        appDelegate.degree = rotateDegree*(M_PI/180);
        self.set.center = center;
    }
    
}

- (IBAction)alarmClick:(UIButton *)sender {
    flag = YES;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isAlarm = YES;
    NSLog(@"%02d:%02d",appDelegate.set_hr,appDelegate.set_min);
    
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSDate *date = [NSDate date];
    NSArray * timeArray = [[dateFormatter stringFromDate:date] componentsSeparatedByString:@":"];
    if ([timeArray[0] intValue]==12)
        appDelegate.set_hr=12;
    else if ([timeArray[0] intValue]>12)
        appDelegate.set_hr+=12;
    
    NSDate* firstDate = [self convertToUTC:[dateFormatter dateFromString:[NSString stringWithFormat:@"%02d:%02d:%02d",appDelegate.hr,appDelegate.min,appDelegate.sec]]];
    NSDate* secondDate = [self convertToUTC:[dateFormatter dateFromString:[NSString stringWithFormat:@"%02d:%02d:00",appDelegate.set_hr,appDelegate.set_min]]];
    NSTimeInterval timeDifference = [secondDate timeIntervalSinceDate:firstDate];
    //如果時間差是小於0表示為隔天
    if (timeDifference<0)
        timeDifference += 86400;

    NSLog(@"%@",firstDate);
    NSLog(@"%@",secondDate);
    NSLog(@"%f",timeDifference);
    if (appDelegate.set_hr==appDelegate.hr && appDelegate.set_min<=appDelegate.min)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"appDidBecomeActive" object:nil];
        [[UIApplication sharedApplication] cancelLocalNotification:appDelegate.scheduledAlert];
        appDelegate.isAlarm = NO;
    }
    else
    {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        appDelegate.scheduledAlert = [[[UILocalNotification alloc] init] autorelease];
        appDelegate.scheduledAlert.fireDate = [NSDate dateWithTimeIntervalSinceNow:timeDifference];
        appDelegate.scheduledAlert.timeZone = [NSTimeZone defaultTimeZone];
        appDelegate.scheduledAlert.repeatInterval =  kCFCalendarUnitMinute;
        appDelegate.scheduledAlert.soundName = @"get up7.mp3";
        appDelegate.scheduledAlert.alertBody = @"早安～地球人！";
        [[UIApplication sharedApplication] scheduleLocalNotification:appDelegate.scheduledAlert];
    }
}

//矯正時差
- (NSDate*) convertToUTC:(NSDate*)sourceDate
{
    NSTimeZone* currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone* utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval gmtInterval =  currentGMTOffset - gmtOffset;
    
    NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:sourceDate] autorelease];
    
    return destinationDate;
}

- (IBAction)next_alarmClick:(UIButton *)sender {
    if (alarm_index<[alarm_img count]-1)
        alarm_index++;
    else
        alarm_index = [alarm_img count]-1;
    [self.alarm setImage:[UIImage imageNamed:[alarm_img objectAtIndex:alarm_index]]];
    
}

- (IBAction)prev_alarmClick:(UIButton *)sender {
    if (alarm_index>0)
        alarm_index--;
    else
        alarm_index =0;
    [self.alarm setImage:[UIImage imageNamed:[alarm_img objectAtIndex:alarm_index]]];
    
}
@end
