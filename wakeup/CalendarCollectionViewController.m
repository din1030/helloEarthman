//
//  CalendarCollectionViewController.m
//  wakeup
//
//  Created by din1030 on 13/6/5.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import "CalendarCollectionViewController.h"
#import "CalendarViewCell.h"

#import "AppDelegate.h"
#import "BrainHoleViewController.h"

#import "DataBase.h"

@interface CalendarCollectionViewController ()

@end

@implementation CalendarCollectionViewController

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
    // 設定 nav bar
    UINavigationBar *navBar = [self.navigationController navigationBar];
    [navBar setBackgroundImage:[UIImage imageNamed:@"calendar_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    // 註冊一個 nib 給 header 用
    [self.collectionView registerNib:[UINib nibWithNibName:@"CalHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CalHeader"];
    //[self.collectionView registerClass:[BadgeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BadgeHeaderView"];
 #warning Rewrite using sqlite to get data  
    // 抓 daily_record
    FMResultSet *daily =nil;
    daily = [DataBase executeQuery:@"SELECT * FROM DAILY_RECORD"];
    while ([daily next]) {
        // QQQQQQQQQ
    }
    _dailyInfo = [[NSMutableArray alloc] initWithObjects:@"A",@"B",@"C",@"D",@"E",@"A",@"B",@"C",@"D",@"E",@"A",@"B",@"C",@"D",@"E",@"A",@"B",@"C",@"D",@"E",@"A",@"B",@"C",@"D",@"E", nil];
    
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

- (void)Game:(NSString *)clock_id
{
    // 切換clock_id對應的遊戲
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isAlarm = NO;
    BrainHoleViewController *brainhole_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GamePage"];
    [self.navigationController pushViewController:brainhole_vc animated:NO];
}

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dailyInfo count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"cal_cell";
    CalendarViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSArray *rnd_img = [[NSArray alloc] initWithObjects:@"badge_tw.png",@"badge_tw_n.png",@"badge_jp.png",@"badge_jp_n.png",@"Squirrel.png",@"Squirrel_n.png", nil];
    int r = arc4random_uniform(6);
    cell.badge_thumb.image = [UIImage imageNamed:[rnd_img objectAtIndex:r]];
    [rnd_img release];
    
    cell.date_num.text =  [NSString stringWithFormat:@"%d",indexPath.item+1] ;
    //NSLog(@"%f,%f",cell.center.x,cell.center.y);

    return cell;
}

#pragma mark - Header

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CalHeader"forIndexPath:indexPath];
    return headerView;
}

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeMake(self.collectionView.frame.size.width, 100);
//    
//}



@end
