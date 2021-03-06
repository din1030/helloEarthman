//
//  BrainHoleViewController.m
//  wakeup
//
//  Created by din1030 on 13/5/30.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import "AppDelegate.h"
#import "BrainHoleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "DataBase.h"

@interface BrainHoleViewController ()
@end

@implementation BrainHoleViewController

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
	// Do any additional setup after loading the view.
    remain_hole = kHOLES;
    self.hole_img = [NSArray arrayWithObjects:@"brainhole1.png",@"brainhole2.png",@"brainhole3.png",@"brainhole4.png",nil];
    
    [_eye.layer setAnchorPoint: CGPointMake(0.5,0.5)];
    levelup_timer = [NSTimer scheduledTimerWithTimeInterval:12  // 洞升級秒數
                                                     target:self
                                                   selector:@selector(generateHole)
                                                   userInfo:nil
                                                    repeats:YES];
    
    game_timer = [NSTimer scheduledTimerWithTimeInterval:1  // 遊戲秒數
                                                  target:self
                                                selector:@selector(counting)
                                                userInfo:nil
                                                 repeats:YES];
    
    NSLog(@"time up. Please play this game.");
    NSURL* url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"holeback" ofType:@"mp3"]];
    //與音樂檔案做連結
    NSError* error = nil;
    _bgPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [self.bgPlayer setNumberOfLoops:-1];
    [self.bgPlayer play];
    [url release];
    
    // 無視使用者音量控制
    AudioSessionInitialize (NULL, NULL, NULL, NULL);
    AudioSessionSetActive(true);
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty (kAudioSessionProperty_AudioCategory,
                             sizeof(sessionCategory),&sessionCategory);

}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    // 恢復預設值
    AudioSessionInitialize (NULL, NULL, NULL, NULL);
    AudioSessionSetActive(true);
    UInt32 sessionCategory = kAudioSessionCategory_AmbientSound;
    AudioSessionSetProperty (kAudioSessionProperty_AudioCategory,
                             sizeof(sessionCategory),&sessionCategory);
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_eye release];
    [levelup_timer invalidate];
    [game_timer invalidate];
    [check_timer invalidate];
    [audioPlayer release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void) counting
{
    sec++;
    if (sec==15)
        [self audioplay:@"you are too slow2"];
}

- (void) generateHole
{
    for (id obj in self.view.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton *oldHole = (UIButton*) obj;
            switch (oldHole.tag) {  // 判斷下個 level 的圖
                case 1:
                    [oldHole setBackgroundImage:[UIImage imageNamed:@"brainhole2.png"] forState:UIControlStateNormal];
                    oldHole.tag++;
                    NSLog(@"new hole 2");
                    break;
                case 2:
                    [oldHole setBackgroundImage:[UIImage imageNamed:@"brainhole3.png"] forState:UIControlStateNormal];
                    oldHole.tag++;
                    NSLog(@"new hole 3");
                    break;
                case 3:
                    [oldHole setBackgroundImage:[UIImage imageNamed:@"brainhole4.png"] forState:UIControlStateNormal];
                    oldHole.tag++;
                    NSLog(@"new hole 4");
                    break;
                case 0:
                    oldHole.hidden = NO;
                    oldHole.tag++;
                    remain_hole++;
                    break;
            }
        }
    }
    
    [self audioplay:@"i got a hole1"];
}

- (IBAction)holeClick:(UIButton*)sender
{
    [self audioplay:@"touch2"];
    
    UIButton *thisHole = (UIButton*) sender;
    if (thisHole.tag == 1) {
        thisHole.tag--;
        thisHole.hidden = YES;
        remain_hole--;
        if (remain_hole == 0) {
            NSLog(@"SUCCES!!!");
            [levelup_timer invalidate];
            [game_timer invalidate];
            [audioPlayer release];
            [_bgPlayer stop];
            [self showAlert];
        }
    }
    else {
        thisHole.tag--;
        NSLog(@"%d",thisHole.tag);
        [thisHole setBackgroundImage:[UIImage imageNamed:[self.hole_img objectAtIndex:(thisHole.tag-1)]] forState:UIControlStateNormal];
    }
    //[levelup_timer invalidate];
}

- (void) audioplay:(NSString *) filename
{
    NSURL* url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:filename ofType:@"mp3"]];
    //與音樂檔案做連結
    NSError* error = nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [audioPlayer setNumberOfLoops:0];
    [audioPlayer play];
    [url release];
    
}

-(void) showAlert
{
    [[[[UIAlertView alloc]
       initWithTitle:@"恭喜！"
       message:[NSString stringWithFormat:@"花了%d秒成功填補所有腦洞啦～～",sec]
       delegate:self
       cancelButtonTitle:@"OK"
       otherButtonTitles: nil] autorelease] show];
    
}

// 按了 alert 的 按鈕之後的動作（發佈到fb、轉回首頁。
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //將按鈕的Title當作判斷的依據
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OK"]) {
        NSLog(@"after click OK button");
        [self performSegueWithIdentifier:@"backHome" sender:self];
        [self sendFBMessage];
    }
}

- (void)sendFBMessage {
    
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    // If the user is authenticated, log out when the button is clicked.
    // If the user is not authenticated, log in when the button is clicked.
    if (!FBSession.activeSession.isOpen) {
        [appDelegate openSessionWithAllowLoginUI:YES];
        
    }
    

    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
    //NSString *name = self.loggedInUser.name;
    //NSString *message = [NSString stringWithFormat:@"成功送出～"]; //name != nil ? name : @"me"
    //                     self.contentText.text]; //送出的訊息
    
    // if it is available to us, we will post using the native dialog
    //    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self
    //                                                                    initialText:@"HI!"
    //                                                                          image:nil
    //                                                                            url:[NSURL URLWithString:@""]
    //                                                                        handler:nil];
    if (FBSession.activeSession.isOpen) { //name!=nil , FBSession.activeSession.isOpen
        
        // 抓取person_badge資訊
        
        //讀取plist記錄的入睡時間
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
        
        FMResultSet *rs = nil;
        rs = [DataBase executeQuery:[NSString stringWithFormat:@"SELECT * FROM PERSON_BADGE WHERE requirement=%d",[[temp objectForKey:@"sleep_hr"] intValue]]];
        NSString *p_id = @"";
        NSString *name = @"";
        NSString *description = @"";
        NSString *nationality = @"";
        while ([rs next])
        {
            p_id = [rs stringForColumn:@"id"];
            name = [rs stringForColumn:@"name"];
            description = [rs stringForColumn:@"description"];
            nationality = [rs stringForColumn:@"Nationality"];
        }
        NSLog(@"hr=%d",[[temp objectForKey:@"sleep_hr"] intValue]);
        NSLog(@"p_id=%@",p_id);
        NSLog(@"name=%@",name);
        
        //讀取plist記錄的問候語
        errorDesc = nil;
        rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                        NSUserDomainMask, YES) objectAtIndex:0];
        plistPath = [rootPath stringByAppendingPathComponent:@"test.plist"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
            plistPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"];
        }
        plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        temp = (NSDictionary *)[NSPropertyListSerialization
                                propertyListFromData:plistXML
                                mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                format:&format
                                errorDescription:&errorDesc];
        if (!temp) {
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        }
        NSString *msg = [temp objectForKey:p_id];
        NSLog(@"%@",[temp objectForKey:p_id]);
        
        
        
        NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       msg,@"message",
                                       [NSString stringWithFormat:@"%@人",nationality],@"name",
                                       @" ",@"caption",
                                       description,@"description",
                                       @"https://apps.facebook.com/dinguagua/?share_id=Z900SrENR0", @"link",
                                       @"http://140.119.19.34/din/wakeupup/badge_tw.png", @"picture",
                                       nil];
        
        [self performPublishAction:^{
            // otherwise fall back on a request for permissions and a direct post
            [FBRequestConnection startWithGraphPath:@"me/feed"
                                         parameters:params HTTPMethod:@"POST"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      
                                      //[self showAlert:message result:result error:error]; //跳出alert
                                  }];
        }];
    }
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        
        [FBRequestConnection
         startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                           id<FBGraphUser> user,
                                           NSError *error) {
             if (!error) {
                 userInfo = @"";
                 
                 // Example: typed access (name)
                 // - no special permissions required
                 userInfo = [userInfo
                             stringByAppendingString:
                             [NSString stringWithFormat:@"%@",
                              user.name]];
                 
                 }
             }
         ];
    }
}

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                } //For this example, ignore errors (such as if user cancels).
                                            }];
    } else {
        action();
    }
    
}

@end
