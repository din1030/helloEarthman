//
//  AppDelegate.m
//  wakeup
//
//  Created by din1030 on 13/5/8.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import "AppDelegate.h"
#import "BrainHoleViewController.h"

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
    [self countUp];
    if (self.hr==self.set_hr && self.min>=self.set_min && self.isAlarm)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"appDidBecomeActive" object:nil];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        _isAlarm = NO;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
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
