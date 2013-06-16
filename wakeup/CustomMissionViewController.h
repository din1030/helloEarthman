//
//  CustomMissionViewController.h
//  wakeup
//
//  Created by din1030 on 13/6/11.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomMissionViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource> // <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (retain, nonatomic) NSMutableArray *badge_list;
@property (retain, nonatomic) NSString *bid;
@property (retain, nonatomic) IBOutlet UIImageView *badge_image;
@property (retain, nonatomic) IBOutlet UIPickerView *target_picker;
@property (retain, nonatomic) IBOutlet UIImageView *indicator;

@property (retain, nonatomic) NSMutableArray *day;
@property (retain, nonatomic) IBOutlet UILabel *day_1;
@property (retain, nonatomic) IBOutlet UILabel *day_2;
@property (retain, nonatomic) IBOutlet UILabel *day_3;
@property (retain, nonatomic) IBOutlet UILabel *day_4;
@property (retain, nonatomic) IBOutlet UILabel *day_5;
@end
