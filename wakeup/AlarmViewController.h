//
//  AlarmViewController.h
//  wakeup
//
//  Created by Toby Hsu on 13/6/5.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface AlarmViewController : UIViewController
{
    AVAudioPlayer *audioPlayer;
    UIBackgroundTaskIdentifier TimerTask;
    NSTimer *timer;
    NSArray *alarm_img;
    int alarm_index;
}
@property (retain, nonatomic) IBOutlet UIImageView *alarm;
@property (retain, nonatomic) IBOutlet UIImageView *set;
@property (retain, nonatomic) IBOutlet UIImageView *alarm_min;
@property (retain, nonatomic) IBOutlet UIImageView *alarm_hr;
@property (retain, nonatomic) IBOutlet UIImageView *alarm_alarm;
@property (retain, nonatomic) IBOutlet UIImageView *alarm_sec;
@property (retain, nonatomic) IBOutlet UIImageView *mask;
@property (retain, nonatomic) IBOutlet UILabel *label_alarm_time;
@property (retain, nonatomic) IBOutlet UIButton *setalarm;
@property (retain, nonatomic) IBOutlet UIButton *next_alarm;
@property (retain, nonatomic) IBOutlet UIButton *prev_alarm;

- (IBAction)alarm_pan:(UIPanGestureRecognizer *)sender;
- (IBAction)alarmClick:(UIButton *)sender;
- (IBAction)next_alarmClick:(UIButton *)sender;
- (IBAction)prev_alarmClick:(UIButton *)sender;
@end
