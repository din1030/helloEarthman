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
    audioArray = [[NSArray alloc] initWithObjects:@"laughing2",@"get up7", nil];
    
    NSLog(@"time up. Please play this game.");
    NSURL* url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"back4new" ofType:@"mp3"]];
    //與音樂檔案做連結
    NSError* error = nil;
    _bgPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [self.bgPlayer setNumberOfLoops:-1];
    [self.bgPlayer play];
    [url release];

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
    //與音樂檔案做連結
    NSError* error = nil;

    if (sec==15)
    {
        NSURL* url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"you are too slow2" ofType:@"mp3"]];
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [audioPlayer setNumberOfLoops:0];
        [audioPlayer play];
        [url release];
    }
    else
    {
        if (sec%5==0)
        {
            int r = arc4random_uniform(2);
            NSURL* url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:[audioArray objectAtIndex:r] ofType:@"mp3"]];
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            [audioPlayer setNumberOfLoops:0];
            [audioPlayer play];
            [url release];
        }
    }
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
    
    NSURL* url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"i got a hole1" ofType:@"mp3"]];
    //與音樂檔案做連結
    NSError* error = nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [audioPlayer setNumberOfLoops:0];
    [audioPlayer play];
    [url release];
    
}

- (IBAction)holeClick:(UIButton*)sender
{
    NSURL* url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"touch2" ofType:@"mp3"]];
    //與音樂檔案做連結
    NSError* error = nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [audioPlayer play];
    [url release];
    
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
        NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [NSString stringWithFormat:@"道地的%@!!!!",@"台灣人"],@"message",
                                       @"台灣人",@"name",
                                       @" ",@"caption",
                                       @"Hi～～～",@"description",
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
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"哇嗚～"
                                                        message:@"要先登入才能分享唷！"  //警告訊息內文的設定
                                                       delegate:self // 叫出AlertView之後，要給該ViewController去處理
                                              cancelButtonTitle:@"OK"  //cancel按鈕文字的設定
                                              otherButtonTitles:nil]; // 其他按鈕的設定
        // 如果要多個其他按鈕 >> otherButtonTitles: @"check1", @"check2", nil];
        
        [alert show];  // 把alert這個物件秀出來
        [alert release]; //釋放alert這個物件
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
