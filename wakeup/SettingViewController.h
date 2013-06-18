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

@property (strong, nonatomic) NSArray *hourColumnList;
@property (strong, nonatomic) NSArray *minuteColumnList;
@property (nonatomic) int sleeping_hr;
@property (nonatomic) int sleeping_min;
@property (strong,nonatomic) UIView *content;
@property (strong,nonatomic) UIButton *set_bt;

@property (retain, nonatomic) IBOutlet UILabel *timeZone;
@property (strong, nonatomic) IBOutlet UIButton *fbButton;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) IBOutlet UIPickerView *setRemindTimePicker;
@property (retain, nonatomic) IBOutlet UIImageView *mask;
@property (retain, nonatomic) IBOutlet UILabel *time_set;
@property (retain, nonatomic) IBOutlet UIButton *edit_time;
- (IBAction)show_picker:(UIButton *)sender;

@end
