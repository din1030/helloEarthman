//
//  BadgeViewController.m
//  wakeup
//
//  Created by din1030 on 13/6/3.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import "BadgeViewController.h"
#import "BadgeCollectionCell.h"
#import "BadgeConditionViewController.h"
#import "BadgeHeaderView.h"

#import "FMDatabase.h"
#import "DataBase.h"

#import "AppDelegate.h"
#import "BrainHoleViewController.h"

@interface BadgeViewController ()

@end

@implementation BadgeViewController

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
    UINavigationBar *navBar = [self.navigationController navigationBar];
    [navBar setBackgroundImage:[UIImage imageNamed:@"badge_bar.png"] forBarMetrics:UIBarMetricsDefault];
    // 註冊一個 nib 給 header 用
    [self.collectionView registerClass:[BadgeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BadgeHeader"];
//    [self.collectionView registerNib:[UINib nibWithNibName:@"BadgeHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BadgeHeader"];
    
    // sqlite get badge ids
    _person_id = [[NSMutableArray alloc] initWithObjects: nil];
    _animal_id = [[NSMutableArray alloc] initWithObjects: nil];
    
    // sqlite 撈兩種 badge id
    FMResultSet *rs1 = nil;
    FMResultSet *rs2 = nil;
    rs1 = [DataBase executeQuery:@"SELECT id FROM PERSON_BADGE"];
    while ([rs1 next])
    {
        NSString *p_id = [rs1 stringForColumn:@"id"];
        [_person_id addObject:p_id];

    }
    rs2 = [DataBase executeQuery:@"SELECT id FROM ANIMAL_BADGE"];
    while ([rs2 next])
    {
            NSString *a_id = [rs2 stringForColumn:@"id"];
            [_animal_id addObject:a_id];
    }
    [rs1 close];
    [rs2 close];
    
    _obj_ar = [[NSMutableArray alloc]initWithObjects:_person_id,_animal_id, nil];
    [_animal_id release];
    [_person_id release];
    //[_obj_ar release];
    
    // notification後進入遊戲
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Game:)
                                                 name:@"appDidBecomeActive"
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    UINavigationBar *navBar = [self.navigationController navigationBar];
    [navBar setBackgroundImage:[UIImage imageNamed:@"badge_bar.png"] forBarMetrics:UIBarMetricsDefault];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.obj_ar count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.obj_ar objectAtIndex:section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"badge_cell";
    BadgeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSArray *rnd_img = [[NSArray alloc] initWithObjects:@"badge_tw.png",@"badge_tw_n.png",@"badge_jp.png",@"badge_jp_n.png",@"Squirrel.png",@"Squirrel_n.png", nil];
    int r = arc4random_uniform(6);
    cell.badge_thumbnail.image = [UIImage imageNamed:[rnd_img objectAtIndex:r]];
    [rnd_img release];
    
    NSUInteger section = [indexPath section];
    NSUInteger index = [indexPath row];
    //cell.cell_id = [[self.obj_ar[0] objectAtIndex:index] objectId];
    
    // 不同 badge 給不同 type（要改成從 db 抓？）
    if (section==0) {
        cell.cell_id = [_person_id objectAtIndex:index];
        cell.cell_type = @"person";
        //NSLog(@"%@ at sec 0 ",cell.cell_id);
    }
    else if (section==1) {
        cell.cell_id = [_animal_id objectAtIndex:index];
        cell.cell_type = @"animal";
        //NSLog(@"%@ at sec 1 ",cell.cell_id);
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ShowDetail" sender:cell]; // 走叫做 ShowDetail 的 segue
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowDetail"]) {
        if ([sender isKindOfClass:[BadgeCollectionCell class]]) { // 確定 sendor 是 cell
            BadgeCollectionCell *cell1 = (BadgeCollectionCell *)sender;
            //将page2设定成Storyboard Segue的目标UIViewController
            BadgeConditionViewController *conditionPage = segue.destinationViewController;
            //将值透过Storyboard Segue带给页面2的变数
            [conditionPage setValue:cell1.cell_id forKey:@"b_id"];            
            [conditionPage setValue:cell1.cell_type forKey:@"b_type"];
        }
    }
}



-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    BadgeHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"BadgeHeader" forIndexPath:indexPath];
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        if(indexPath.section == 0) { // 對不同 section 的 header 設定
            headerView.title.text = @"世界公民";
            [headerView.badge_type setImage:[UIImage imageNamed:@"person_b.png"]];
        } else if (indexPath.section == 1) {
            headerView.title.text = @"可愛動物";
            [headerView.badge_type setImage:[UIImage imageNamed:@"animal_b.png"]];
            //NSLog(@"at sec %d",indexPath.section);
        } else
            headerView.title.text = @"?????";
    }
    return headerView;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.collectionView.frame.size.width, 100);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
    [_obj_ar dealloc];
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
