//
//  SettingViewController.m
//  wakeup
//
//  Created by din1030 on 13/5/29.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import "QuartzCore/QuartzCore.h"
#import "AppDelegate.h"
#import "SettingViewController.h"
#import "DataBase.h"

@interface SettingViewController ()

- (IBAction)fbClick:(UIButton *)sender;
- (IBAction)sendClick:(UIButton *)sender;

@end

@implementation SettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 設定 nav bar
    UINavigationBar *navBar = [self.navigationController navigationBar];
    [navBar setBackgroundImage:[UIImage imageNamed:@"setting_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_bg.png"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    [tempImageView release];
    
    //[[self.edit_time layer] setBorderWidth:1.0f];
    
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSLog(@"%@",currentTimeZone.description); // Local Time Zone (Asia/Taipei (GMT+08:00) offset 28800)
    NSLog(@"%@",currentTimeZone.abbreviation); // GMT+08:00
    self.timeZone.text = currentTimeZone.abbreviation;
    //NSInteger offset = [currentTimeZone secondsFromGMT];
    //[NSDate dateWithTimeIntervalSince1970:1301322715];
    
#warning Set reminding sleeping time
    // 等待ＤＢ更新
    FMResultSet *rs = nil;
    rs = [DataBase executeQuery:@"SELECT sleeptime FROM USER"];
    NSString *sleeptime = @"";
    while ([rs next])
    {
        NSLog(@"@@");
        sleeptime = [rs stringForColumn:@"sleeptime"];
    }
    NSArray * time = [sleeptime componentsSeparatedByString:@":"];
    _sleeping_hr = [time[0] intValue];
    _sleeping_min = [time[1] intValue];
    self.time_set.text = [NSString stringWithFormat:@"%02d:%02d",_sleeping_hr,_sleeping_min];
    [rs close];
    
    [self prepareData];
    _setRemindTimePicker = [[UIPickerView alloc] init];
    _setRemindTimePicker.frame = CGRectMake(0, self.view.frame.size.height/4, 320.0, 162.0);
    _setRemindTimePicker.transform = CGAffineTransformMakeScale(1.0, 1.0);
    //setRemindTimePicker.transform = CGAffineTransformMakeTranslation(0, 40);
    _setRemindTimePicker.delegate = self;
    _setRemindTimePicker.showsSelectionIndicator = YES;
    [_setRemindTimePicker selectRow:0 inComponent:0 animated:YES];
    [_setRemindTimePicker selectRow:0 inComponent:1 animated:YES];
    [self.view addSubview:_setRemindTimePicker];
    _setRemindTimePicker.hidden = YES;
    //_mask.hidden = YES;
#warning Copyright page
    
}

- (void)sleeping_Clcik
{
    self.time_set.text = [NSString stringWithFormat:@"%02d:%02d",_sleeping_hr,_sleeping_min];
    UINavigationBar *tabBar = [self.navigationController navigationBar];
    tabBar.alpha = 1;
    [tabBar setUserInteractionEnabled:YES];
    _setRemindTimePicker.hidden=YES;
    _content.hidden = YES;
    _set_bt.hidden = YES;
    //寫入DB
    [DataBase executeSQL:[NSString stringWithFormat:@"UPDATE USER SET sleeptime='%@'",self.time_set.text]];
    //註冊推播
    NSCalendar *calendar = [NSCalendar currentCalendar]; // gets default calendar
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]]; // gets the year, month, day,hour and minutesfor today's date
    [components setHour:_sleeping_hr];
    [components setMinute:_sleeping_min];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[[UIApplication sharedApplication] scheduledLocalNotifications]count]==6)
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    else if ([[[UIApplication sharedApplication] scheduledLocalNotifications]count]==7)
    {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        //如果有鬧鐘，則重新加入鬧鐘推播
        NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        
        if (appDelegate.hr==12)
            appDelegate.set_hr=12;
        else if (appDelegate.hr>12)
        {
            if (appDelegate.set_hr!=0)
                appDelegate.set_hr = (appDelegate.set_hr+12)%24;
            else
                appDelegate.set_hr = 24;
        }
        NSLog(@"time=%d,set=%d",appDelegate.hr,appDelegate.set_hr);
        
        NSDate* firstDate = [self convertToUTC:[dateFormatter dateFromString:[NSString stringWithFormat:@"%02d:%02d:%02d",appDelegate.hr,appDelegate.min,appDelegate.sec]]];
        NSDate* secondDate = [self convertToUTC:[dateFormatter dateFromString:[NSString stringWithFormat:@"%02d:%02d:00",appDelegate.set_hr,appDelegate.set_min]]];
        if (appDelegate.set_hr==24)
            secondDate = [self convertToUTC:[dateFormatter dateFromString:[NSString stringWithFormat:@"23:59:59"]]];
        NSTimeInterval timeDifference = [secondDate timeIntervalSinceDate:firstDate];
        //如果時間差是小於0表示為隔天
        if (timeDifference<0)
            timeDifference += 43200;
        else if (appDelegate.set_hr==24)
            timeDifference+= appDelegate.set_min*60+1;
        
        if (appDelegate.isAlarm)
        {
            appDelegate.scheduledAlert = [[[UILocalNotification alloc] init] autorelease];
            appDelegate.scheduledAlert.fireDate = [NSDate dateWithTimeIntervalSinceNow:timeDifference];
            appDelegate.scheduledAlert.timeZone = [NSTimeZone defaultTimeZone];
            appDelegate.scheduledAlert.repeatInterval =  kCFCalendarUnitMinute;
            appDelegate.scheduledAlert.soundName = @"alarm2.mp3";
            appDelegate.scheduledAlert.alertBody = @"早安～地球人！";
            [[UIApplication sharedApplication] scheduleLocalNotification:appDelegate.scheduledAlert];
        }

    }
    appDelegate.scheduledSleep = [[[UILocalNotification alloc] init] autorelease];
    appDelegate.scheduledSleep.fireDate = [[calendar dateFromComponents:components] dateByAddingTimeInterval:-1800];
    appDelegate.scheduledSleep.timeZone = [NSTimeZone defaultTimeZone];
    appDelegate.scheduledSleep.repeatInterval=0;
    //    appDelegate.scheduledSleep.soundName = @"alarm2.mp3";
    appDelegate.scheduledSleep.alertBody = @"距離您預計睡覺的時間還有半小時唷！";
    [[UIApplication sharedApplication] scheduleLocalNotification:appDelegate.scheduledSleep];
    
    appDelegate.scheduledSleep.alertBody = @"已經超過您預計睡覺的時間囉！快去睡吧！";
    NSTimeInterval interval = 1800;
    for( int i = 0; i < 5; ++i ) {
        appDelegate.scheduledSleep.fireDate = [NSDate dateWithTimeInterval: interval*i sinceDate:[calendar dateFromComponents:components]];
        [[UIApplication sharedApplication] scheduleLocalNotification: appDelegate.scheduledSleep];
//        NSLog(@"%d times:%@",i,[[NSDate dateWithTimeInterval: interval*i sinceDate:[self convertToUTC:[calendar dateFromComponents:components]]] description]);
        
    }
    NSLog(@"notification count=%d",[[[UIApplication sharedApplication] scheduledLocalNotifications] count]);
    appDelegate.isSleep = YES;
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 3;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    int row;
//    if (section == 0) {
//        row = 2;
//    } else if (section == 1) {
//        row = 2;
//    }
//    else {
//        row = 1;
//    }
//    return row;
//}

/* - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 static NSString *CellIdentifier = @"Cell";
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 } */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)dealloc {
    [_fbButton release];
    [_timeZone release];
    [_mask release];
    [_time_set release];
    [_edit_time release];
    [super dealloc];
}

#pragma mark - for Facebook

- (IBAction)fbClick:(UIButton *)sender
{
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    // If the user is authenticated, log out when the button is clicked.
    // If the user is not authenticated, log in when the button is clicked.
    if (FBSession.activeSession.isOpen) {
        [appDelegate closeSession];
    } else {
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
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


- (IBAction)sendClick:(UIButton *)sender {
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
    //NSString *name = self.loggedInUser.name;
    NSString *message = [NSString stringWithFormat:@"成功送出～"]; //name != nil ? name : @"me"
    //                     self.contentText.text]; //送出的訊息
    
    // if it is available to us, we will post using the native dialog
    //    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self
    //                                                                    initialText:@"HI!"
    //                                                                          image:nil
    //                                                                            url:[NSURL URLWithString:@""]
    //                                                                        handler:nil];
    if (FBSession.activeSession.isOpen) { //name!=nil , FBSession.activeSession.isOpen
        NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       [NSString stringWithFormat:@"骨子裡其實是個%@",@"法國人"],@"message",
                                       @"法國人",@"name",
                                       @" " ,@"caption",
                                       @"Hi～～～",@"description",
                                       @"https://www.parse.com/docs/cloud_code_guide", @"link",
                                       @"http://big5.gmw.cn/images/2009-07/30/xin_1207063003540622341025.jpg", @"picture",
                                       nil];
        
        [self performPublishAction:^{
            // otherwise fall back on a request for permissions and a direct post
            [FBRequestConnection startWithGraphPath:@"me/feed"
                                         parameters:params HTTPMethod:@"POST"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      
                                      [self showAlert:message result:result error:error]; //跳出alert
                                      self.fbButton.enabled = YES;
                                  }];
            
            self.fbButton.enabled = NO;
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

// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertMsg = [NSString stringWithFormat:@"出錯了 QQ error:%@", error.localizedDescription ];
        alertTitle = @"哇～";
    } else {
        //NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = @"已分享到你的塗鴉牆囉！";
        //[NSString stringWithFormat:@"%@，蠍男小星機已分享到你的塗鴉牆囉！",self.loggedInUser.first_name];
        alertTitle = @"恭喜！";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Picker

//設定滾輪總共有幾個欄位
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 2;
}

//設定滾輪總共有幾個項目
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    //    if (component==0) {
    //        return [keys count];
    //    }else{
    //        NSString *key = [keys objectAtIndex:[thePickerView selectedRowInComponent:0]]; // 飲料或甜點
    //        NSArray *array = [data objectForKey:key];
    //        return [array count];
    //    }
    if (component==0)
        return [_hourColumnList count];
    else
        return [_minuteColumnList count];

}

- (IBAction)show_picker:(UIButton *)sender {
    //    RoundedRect *roundedRect = [[RoundedRect alloc] initWithFrame:CGRectMake(50.0, 50.0, 120.0, 200.0)];
    //    roundedRect.tag = 1;
    //    roundedRect.clipsToBounds = YES;
    //    [self.view addSubview:roundedRect];
    
    _content = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 640.0)];
    _content.backgroundColor = [UIColor blackColor];
    _content.alpha = 0.6;
    _setRemindTimePicker.hidden = NO;
    [self.view addSubview:_content];
    [self.view addSubview:_setRemindTimePicker];
    
    _set_bt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _set_bt.frame = CGRectMake(self.view.frame.size.width/2-40, self.view.frame.size.height/2+80, 90, 35);
    [_set_bt setTitle:@"設定" forState:UIControlStateNormal];
    [_set_bt addTarget:self action:@selector(sleeping_Clcik) forControlEvents:UIControlEventTouchUpInside];
    [_set_bt setBackgroundImage:[UIImage imageNamed:@"btm.png"] forState:UIControlStateNormal];
    [self.view addSubview:_set_bt];
    
    [_content release];
    
    //    UIImage *mask_bar = [UIImage imageNamed:@"setting_bar.png"];
    //    [[self.navigationController navigationBar] setBackgroundImage:mask_bar  forBarMetrics:UIBarMetricsDefault];
    UINavigationBar *tabBar = [self.navigationController navigationBar];
    tabBar.alpha = 0.6;
    [tabBar setUserInteractionEnabled:NO];
}

- (void) prepareData {
    //    data = [[NSMutableDictionary alloc] init];
    //    for (int i=0;i<24;i++)
    //        [data setValue:[NSArray arrayWithObjects:@"00分",@"15分",@"30分",@"45分", nil] forKey:[NSString stringWithFormat:@"%d點",i]];
    //    keys =[[data allKeys]
    //           sortedArrayUsingComparator:(NSComparator)^(id obj1,id obj2){
    //               return [obj1 caseInsensitiveCompare:obj2];
    //           }];
    
    _hourColumnList = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23", nil];
    _minuteColumnList = [[NSArray alloc] initWithObjects:@"00",@"15",@"30",@"45", nil];
}


//設定滾輪顯示的文字
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    //    NSLog(@"component=%d",component);
    //    NSLog(@"row=%d",row);
    //    if (component==0) {
    //        return[keys objectAtIndex:row];
    //    }else{
    //        NSString *key = [keys objectAtIndex:[thePickerView selectedRowInComponent:0]]; // 飲料或甜點
    //        NSArray *array = [data objectForKey:key];
    //        return [array objectAtIndex:row];
    //    }
    
    if (component==0)
        return [_hourColumnList objectAtIndex:row];
    else
        return [_minuteColumnList objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0)
        _sleeping_hr = [[_hourColumnList objectAtIndex:row] intValue];
    else
        _sleeping_min = [[_minuteColumnList objectAtIndex:row] intValue];
}
@end
