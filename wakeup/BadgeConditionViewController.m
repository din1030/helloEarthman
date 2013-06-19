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
    NSUInteger req;
    if ([self.b_type isEqualToString:@"person"]) {
        rs1 = [DataBase executeQuery:[NSString stringWithFormat:@"SELECT * FROM PERSON_BADGE WHERE id = '%@'",self.b_id]];
        while ([rs1 next]) // 根據時間顯示不同條件字串
        {
            req = [rs1 intForColumn:@"requirement"];
            if (req > 17 && req < 24) {
                req_string = @"晚上 %d 點睡覺代表\n你過的是%@時區唷！";
            } else if (req == 0){
                req_string = @"午夜 %d 點睡覺代表\n你過的是%@時區唷！";
            } else if (req > 0 && req <= 5){
                req_string = @"凌晨 %d 點睡覺代表\n你過的是%@時區唷！";
            } else if (req > 5 && req < 12 ){
                req_string = @"早上 %d 點睡覺代表\n你過的是%@時區唷！";
            } else if (req == 12 ){
                req_string = @"中午 %d 點睡覺代表\n你過的是%@時區唷！";
            } else if (req > 12 && req <= 17 ){
                req_string = @"下午 %d 點睡覺代表\n你過的是%@時區唷！";
            }
//            NSString *bid = [rs1 stringForColumn:@"id"];
            NSString *name = [rs1 stringForColumn:@"Nationality"];
#warning 徽章圖檔
            // 沒有圖的話先用 custom 的圖代替
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.b_id]];
            if (img != nil) {
                self.badge_image.image = img;
            } else {
                NSArray *rnd_img = [[NSArray alloc] initWithObjects:@"8NM1hTHgfE.png",@"8NM1hTHgfE_n.png",@"FqxZ8m5ErB.png",@"FqxZ8m5ErB_n.png",@"9wroWWspcS.png",@"9wroWWspcS_n.png",@"FPDYGQiaQG.png",@"FPDYGQiaQG_n.png",@"j26WD3BJrw.png",@"j26WD3BJrw_n.png",@"kanX2TK012.png",@"kanX2TK012_n.png",@"o1FVKRgshs.png",@"o1FVKRgshs_n.png",@"ypmSNBip8x.png",@"ypmSNBip8x_n.png", nil];
                int r = arc4random_uniform(16);
                self.badge_image.image = [UIImage imageNamed:[rnd_img objectAtIndex:r]];
                [rnd_img release];
            }
            self.badge_description.text = [rs1 stringForColumn:@"description"];
            self.badge_condition.text = [NSString stringWithFormat:req_string,req%12==0?12:(req%12),name];
            self.navigationController.topViewController.title= [rs1 stringForColumn:@"name"];
        }
    } else if ([self.b_type isEqualToString:@"animal"]) {
        rs1 = [DataBase executeQuery:[NSString stringWithFormat:@"SELECT * FROM ANIMAL_BADGE WHERE id = '%@'",self.b_id]];
        while ([rs1 next])
        {
            //NSString *name = [rs1 stringForColumn:@"name"];
            req = [rs1 intForColumn:@"requirement"];
            req_string = @"睡眠時數高於 %d%% 的朋友可以獲得！";
            self.badge_description.text = [rs1 stringForColumn:@"description"];
            self.badge_condition.text = [NSString stringWithFormat:req_string, req];
            self.navigationController.topViewController.title= [rs1 stringForColumn:@"name"];
        }
        // 沒有圖的話先用 custom 的圖代替
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.b_id]];
        if (img != nil) {
            self.badge_image.image = img;
        } else {
            NSArray *rnd_img = [[NSArray alloc] initWithObjects:@"8NM1hTHgfE.png",@"8NM1hTHgfE_n.png",@"FqxZ8m5ErB.png",@"FqxZ8m5ErB_n.png",@"9wroWWspcS.png",@"9wroWWspcS_n.png",@"FPDYGQiaQG.png",@"FPDYGQiaQG_n.png",@"j26WD3BJrw.png",@"j26WD3BJrw_n.png",@"kanX2TK012.png",@"kanX2TK012_n.png",@"o1FVKRgshs.png",@"o1FVKRgshs_n.png",@"ypmSNBip8x.png",@"ypmSNBip8x_n.png", nil];
            int r = arc4random_uniform(16);
            self.badge_image.image = [UIImage imageNamed:[rnd_img objectAtIndex:r]];
            [rnd_img release];
        }
    }
    
    [self.badge_description setNumberOfLines:0];
    [self.badge_description sizeToFit];
    self.badge_description.adjustsFontSizeToFitWidth =YES;
    
    // 設定 back button
    UIImage *backButtonIMG = [[UIImage imageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 21, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonIMG forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UINavigationBar *bar = self.navigationController.navigationBar ;
    bar.topItem.title = @" ";
    [bar setBackgroundImage:[UIImage imageNamed:@"badge_bar0.png"] forBarMetrics:UIBarMetricsDefault];
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
