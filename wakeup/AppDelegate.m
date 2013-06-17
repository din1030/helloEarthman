//
//  AppDelegate.m
//  wakeup
//
//  Created by din1030 on 13/5/8.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import "AppDelegate.h"
#import "BrainHoleViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "DataBase.h"

@implementation AppDelegate

NSString *const FBSessionStateChangedNotification = @"din1030.wakeup:FBSessionStateChangedNotification";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //    // Override point for customization after application launch.
    //    [Parse setApplicationId:@"Lt4GQIlip844mLxgisvyxSUf0TBDISc9VErFtAF1"
    //                  clientKey:@"Eca3LRilxEUhylc89f6CJIZQoYmbsX7vl808xk2k"];
    //    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //讀取plist記錄的時間
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"alarm.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"alarm" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    self.set_min=[[temp objectForKey:@"min"] intValue];
    self.set_hr=[[temp objectForKey:@"hr"] intValue];
    self.degree = [self DegreesToRadians:(self.set_hr%12*60.0+self.set_min)*0.5+180];
    [self countUp];
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.03
                                                target:self
                                              selector:@selector(countUp)
                                              userInfo:nil
                                               repeats:YES];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSDate *firstDate = [NSDate date];
    NSDate *secondDate =  _scheduledAlert.fireDate;
    NSLog(@"firstdate=%@ , seconddate=%@",firstDate,secondDate);
    NSTimeInterval timeDifference = [secondDate timeIntervalSinceDate:firstDate];
    if ([firstDate compare:secondDate]==NSOrderedDescending | [firstDate compare:secondDate]==NSOrderedSame && timeDifference >= -1800)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"appDidBecomeActive" object:nil];
        
        @try {
            [[UIApplication sharedApplication] cancelLocalNotification:_scheduledAlert];
        }
        @catch (NSException *exception) {
            NSLog(@"notification doesn't exist.");
        }
        @finally {
            ;
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        _isAlarm = NO;

    }
    else  if ([firstDate compare:secondDate]==NSOrderedDescending | [firstDate compare:secondDate]==NSOrderedSame && timeDifference < -1800)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"起床失敗"
                                  message:@"喔哦～你失去了得到徽章的機會了！Q口Q"
                                  delegate:nil
                                  cancelButtonTitle:@"下次要早起"
                                  otherButtonTitles:nil];
        [alertView show];
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"appDidBecomeActive" object:nil];
        
        @try {
            [[UIApplication sharedApplication] cancelLocalNotification:_scheduledAlert];
        }
        @catch (NSException *exception) {
            NSLog(@"notification doesn't exist.");
        }
        @finally {
            ;
        }
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        _isAlarm = NO;
    }
    NSLog(@"%f",timeDifference);
  
    // 每日提醒設定(等待db建立）
    FMResultSet *rs = nil;
    rs = [DataBase executeQuery:@"SELECT sleeptime FROM USER"];
    NSString *sleeptime = [NSString alloc];
    while ([rs next])
    {
        sleeptime = [rs stringForColumn:@"sleeptime"];
    }
    NSArray * time = [sleeptime componentsSeparatedByString:@":"];
    NSCalendar *calendar = [NSCalendar currentCalendar]; // gets default calendar
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]]; // gets the year, month, day,hour and minutesfor today's date
    [components setHour:[time[0] intValue]];
    [components setMinute:[time[1] intValue]];
    if (!_isSleep)  //如果隔天有進入app會自動設定當天的推播
    {
        _scheduledSleep = [[[UILocalNotification alloc] init] autorelease];
        _scheduledSleep.fireDate = [[calendar dateFromComponents:components] dateByAddingTimeInterval:-1800];   //設定時間的半小時前
        _scheduledSleep.timeZone = [NSTimeZone defaultTimeZone];
        _scheduledSleep.repeatInterval=0;
        //    appDelegate.scheduledSleep.soundName = @"alarm2.mp3";
        _scheduledSleep.alertBody = @"距離您預計睡覺的時間還有半小時唷！";
        [[UIApplication sharedApplication] scheduleLocalNotification:_scheduledSleep];
        
        _scheduledSleep.alertBody = @"已經超過您預計睡覺的時間囉！快去睡吧！";
        NSTimeInterval interval = 1800;
        for( int i = 0; i < 5; i++ ) {
            _scheduledSleep.fireDate = [NSDate dateWithTimeInterval: interval*i sinceDate:[calendar dateFromComponents:components]];
            [[UIApplication sharedApplication] scheduleLocalNotification: _scheduledSleep];
        }
        NSLog(@"已自動建立提醒睡眠時間推播排程(%d)",[[[UIApplication sharedApplication] scheduledLocalNotifications] count]);
        _isSleep=YES;
    }
    else
    {
        // 判別睡眠推播時間是否已通過第一次提醒的時間，若成立則取消後續的睡眠推播時間
        int len = [[[UIApplication sharedApplication] scheduledLocalNotifications] count];
        NSLog(@"len=%d",len);
        for (int i=0;i<len;i++)
        {
            UILocalNotification *notif;
            notif = [[[UIApplication sharedApplication] scheduledLocalNotifications]objectAtIndex:i];
            firstDate = [NSDate date];
            secondDate =  notif.fireDate;
            if ([firstDate compare:secondDate]==NSOrderedDescending)
            {
                NSLog(@"firstdate=%@ > seconddate=%@",firstDate,secondDate);
                if ([[[UIApplication sharedApplication] scheduledLocalNotifications]count]==6)
                    [[UIApplication sharedApplication] cancelAllLocalNotifications];
                else if ([[[UIApplication sharedApplication] scheduledLocalNotifications]count]==7)
                {
                    [[UIApplication sharedApplication] cancelAllLocalNotifications];
                    //如果有鬧鐘，則重新加入鬧鐘推播
                    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
                    [dateFormatter setDateFormat:@"HH:mm:ss"];
                    
//                    if (self.hr==12)
//                        self.set_hr=12;
//                    else if (self.hr>12)
//                    {
//                        if (self.set_hr!=0)
//                            self.set_hr = (self.set_hr+12)%24;
//                        else
//                            self.set_hr = 24;
//                    }
                    NSLog(@"time=%d,set=%d",self.hr,self.set_hr);
                    
                    NSDate* firstDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%02d:%02d:%02d",self.hr,self.min,self.sec]];
                    NSDate* secondDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%02d:%02d:00",self.set_hr,self.set_min]];
                    if (self.set_hr==24)
                        secondDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"23:59:59"]];
                    NSTimeInterval timeDifference = [secondDate timeIntervalSinceDate:firstDate];
                    //如果時間差是小於0表示為隔天
                    if (timeDifference<0)
                        timeDifference += 43200;
                    else if (self.set_hr==24)
                        timeDifference+= self.set_min*60+1;
                    
                    if (self.isAlarm)
                    {
                        self.scheduledAlert = [[[UILocalNotification alloc] init] autorelease];
                        _scheduledAlert.fireDate =[NSDate dateWithTimeIntervalSinceNow:timeDifference];
                        NSLog(@"alert_firedate=%@",_scheduledAlert.fireDate);
                        self.scheduledAlert.timeZone = [NSTimeZone defaultTimeZone];
                        self.scheduledAlert.repeatInterval =  kCFCalendarUnitMinute;
                        self.scheduledAlert.soundName = @"alarm2.mp3";
                        self.scheduledAlert.alertBody = @"早安～地球人！";
                        [[UIApplication sharedApplication] scheduleLocalNotification:self.scheduledAlert];
                    }
                }
                break;
            }
        }
        self.isSleep = NO;
        len = [[[UIApplication sharedApplication] scheduledLocalNotifications] count];
        NSLog(@"len=%d",len);
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}

#pragma mark - for Alarm

- (void)countUp {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    //正規化的格式設定
    [formatter setDateFormat:@"HH:mm:ss"];
    //正規化取得的系統時間並顯示
    NSArray * timeArray = [[formatter stringFromDate:date] componentsSeparatedByString:@":"];
    self.hr = [timeArray[0] intValue];
    self.min = [timeArray[1] intValue];
    self.sec = [timeArray[2] intValue];
    [formatter release];
}

- (CGFloat) DegreesToRadians:(CGFloat)degrees
{
    degrees = (int)degrees%360;
    return degrees * M_PI / 180;
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

- (void) audioplay:(NSString *) filename
{
    NSURL* url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:filename ofType:@"mp3"]];
    //與音樂檔案做連結
    NSError* error = nil;
    _notificationPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [_notificationPlayer setNumberOfLoops:0];
    [_notificationPlayer play];
    [url release];
    
}

#pragma mark - for Facebook

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    return [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"] defaultAudience:20 allowLoginUI:allowLoginUI completionHandler:^(FBSession *session,
                                                                                                                                                                            FBSessionState state,
                                                                                                                                                                            NSError *error) {
        [self sessionStateChanged:session
                            state:state
                            error:error];
    }];
    
}

- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}

@end
