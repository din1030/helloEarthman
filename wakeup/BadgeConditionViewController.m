//
//  BadgeConditionViewController.m
//  wakeup
//
//  Created by Toby Hsu on 13/6/6.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import "BadgeConditionViewController.h"
#import "AppDelegate.h"
#import "BrainHoleViewController.h"

#import "FMDatabase.h"
#import "DataBase.h"


@interface BadgeConditionViewController ()

@end

@implementation BadgeConditionViewController

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
    FMResultSet *rs1 = nil;
    NSString *req_string = @"";
    if ([self.b_type isEqualToString:@"person"]) {
        rs1 = [DataBase executeQuery:[NSString stringWithFormat:@"SELECT * FROM PERSON_BADGE WHERE id = '%@'",self.b_id]];
        req_string = @"必須要在%@點時起床唷！";
        
    } else if ([self.b_type isEqualToString:@"animal"]) {
        rs1 = [DataBase executeQuery:[NSString stringWithFormat:@"SELECT * FROM ANIMAL_BADGE WHERE id = '%@'",self.b_id]];
        req_string = @"你的睡眠時數排行朋友中的前 %@%%！";
    }
    while ([rs1 next])
    {
        //NSString *name = [rs1 stringForColumn:@"name"];
        self.badge_description.text = [rs1 stringForColumn:@"description"];
        NSString *req = [rs1 stringForColumn:@"requirement"];
        self.badge_condition.text =  [NSString stringWithFormat:req_string, req];
    }

    // 設定 back button
    UIImage *backButtonIMG = [[UIImage imageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 21, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonIMG forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UINavigationBar *bar = self.navigationController.navigationBar ;
    bar.topItem.title = @" ";
    // notification後進入遊戲
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Game:)
                                                 name:@"appDidBecomeActive"
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_badge_image release];
    [_badge_description release];
    [_badge_condition release];
    [super dealloc];
}

- (void)Game:(NSString *)clock_id
{
    // 切換clock_id對應的遊戲
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isAlarm = NO;
    BrainHoleViewController *brainhole_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GamePage"];
    [self.navigationController pushViewController:brainhole_vc animated:NO];
}
@end
