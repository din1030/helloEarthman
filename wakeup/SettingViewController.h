//
//  SettingViewController.h
//  wakeup
//
//  Created by din1030 on 13/5/29.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SettingViewController : UITableViewController <UIPickerViewDelegate>
{
    NSMutableDictionary *data;
    NSArray *keys;
}

@property (retain, nonatomic) IBOutlet UILabel *timeZone;
@property (strong, nonatomic) IBOutlet UIButton *fbButton;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UIPickerView *setRemindTimePicker;
@property (retain, nonatomic) IBOutlet UIImageView *mask;
- (IBAction)show_picker:(UIButton *)sender;

@end
