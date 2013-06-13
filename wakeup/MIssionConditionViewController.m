//
//  MIssionConditionViewController.m
//  wakeup
//
//  Created by din1030 on 13/5/28.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import "MIssionConditionViewController.h"
#import "FMDatabase.h"
#import "DataBase.h"

#import "AppDelegate.h"
#import "BrainHoleViewController.h"

@interface MIssionConditionViewController ()
@end

@implementation MIssionConditionViewController

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
    NSLog(@"%@",self.m_id);
    
    FMResultSet *rs1 = [DataBase executeQuery:[NSString stringWithFormat:@"SELECT * FROM MISSION WHERE id = '%@'",self.m_id]];
    while ([rs1 next])
    {
        //NSString *name = [rs1 stringForColumn:@"name"];
        self.mission_description.text = [rs1 stringForColumn:@"description"];
    }
    FMResultSet *rs2 = [DataBase executeQuery:[NSString stringWithFormat:@"SELECT * FROM MISSION_CONDITION WHERE id = '%@'",self.m_id]];
    while ([rs2 next])
    {
#warning  using dictionary to package data and show in condition view
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
    [_mission_image release];
    [_mission_description release];
    [_mission_condition release];
    [_mission_badges release];
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
