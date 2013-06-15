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
    // 設定 back button
    UIImage *backButtonIMG = [[UIImage imageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 21, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonIMG forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UINavigationBar *bar = self.navigationController.navigationBar ;
    bar.topItem.title = @" ";
    
    NSLog(@"%@",self.m_id);
    
    FMResultSet *rs1 = [DataBase executeQuery:[NSString stringWithFormat:@"SELECT * FROM MISSION WHERE id = '%@'",self.m_id]];
    while ([rs1 next])
    {
        //NSString *name = [rs1 stringForColumn:@"name"];
        self.mission_description.text = [rs1 stringForColumn:@"description"];
    }
    
    [self get_mission_req];
    
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
    [_badge_req release];
    [super dealloc];
}

- (void)get_mission_req {
    NSMutableArray *m_condition = [NSMutableArray array];
    FMResultSet *rs2 = [DataBase executeQuery:[NSString stringWithFormat:@"SELECT * FROM MISSION_CONDITION WHERE mid = '%@'",self.m_id]]; //@"jZi5KgGDWv"
    NSLog(@"GET!!");
    while ([rs2 next])
    {
        // 把需要的 badge 資料用 dictionary 裝起來再塞進 array
        // sqlite 沒有 row count 只能裝完再算 array count
        NSString *condition_type = [rs2 stringForColumn:@"type"];
        NSString *condition_id = [rs2 stringForColumn:@"bid"];
        NSString *condition_amount = [rs2 stringForColumn:@"amount"];
        NSLog(@"%@",condition_id);
        
        NSDictionary *condition = [[NSDictionary alloc] initWithObjectsAndKeys:condition_type,@"b_type",condition_id,@"b_id",condition_amount,@"b_amount", nil];
        [m_condition addObject:condition];
    }
    
    
    // 取得個數用來算 layout 位置
    NSUInteger b_num = [m_condition count];
    for (int i = 0; i < b_num; i++) {
        // prepare data
        NSDictionary *temp = [m_condition objectAtIndex:i];
        NSString *temp_id = [temp objectForKey:@"b_id"];
        NSString *temp_type = [temp objectForKey:@"b_type"];
        NSUInteger temp_amount = [[temp objectForKey:@"b_amount"] intValue];
        
        //UIImage *b_thumb = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",temp_id]];
        UIImage *b_thumb = [UIImage imageNamed:@"badge_tw.png"];
        UIImageView *new_b = [[UIImageView alloc] initWithImage:b_thumb];
        [new_b setFrame:CGRectMake(0, 0, 50, 50)];
        new_b.center = CGPointMake((self.mission_badges.frame.size.width/b_num)*(i+0.5),self.mission_badges.frame.size.height/2);
        [self.mission_badges addSubview:new_b];
        
        // query according to badge type
        FMResultSet *user_amount =nil;
        if ([temp_type isEqualToString:@"person"]) {
            user_amount = [DataBase executeQuery:[NSString stringWithFormat:@"SELECT amount FROM PERSON_BADGE WHERE id = '%@'",temp_id]];
        } else if ([temp_type isEqualToString:@"animal"]) {
            user_amount = [DataBase executeQuery:[NSString stringWithFormat:@"SELECT amount FROM ANIMAL_BADGE WHERE id = '%@'",temp_id]];
        }
        
        // get the amount of badge of user and fill into label with require amount
        while ([user_amount next])
        {
            NSUInteger cur_amount = [user_amount intForColumn:@"amount"];
            UILabel *progress = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
            progress.text = [NSString stringWithFormat:@"%d / %d",(cur_amount==-1?0:cur_amount),temp_amount];
            progress.center = CGPointMake((self.badge_req.frame.size.width/b_num)*(i+0.5),self.badge_req.frame.size.height/2);
            [progress setTextAlignment:NSTextAlignmentCenter];
            [progress setFont:[UIFont systemFontOfSize:14.0]];
            [progress setTextColor:[UIColor whiteColor]];
            
            progress.backgroundColor = [UIColor clearColor];
            [self.badge_req addSubview:progress];
        
        }
        
    }
    
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
