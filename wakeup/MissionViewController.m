//
//  MissionViewController.m
//  wakeup
//
//  Created by din1030 on 13/5/28.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import "MissionViewController.h"
#import "MIssionConditionViewController.h"
#import "MissionCollectionCell.h"
#import "DataBase.h"

#import "AppDelegate.h"
#import "BrainHoleViewController.h"

@interface MissionViewController ()

@end

@implementation MissionViewController

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
    // 設定 nav bar
    UINavigationBar *navBar = [self.navigationController navigationBar];
    [navBar setBackgroundImage:[UIImage imageNamed:@"mission_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    // 設定透明
    //navBar.translucent = YES;
    
    //    sqlite get mission ids
    _mission = [[NSMutableArray alloc] initWithObjects: nil];
    FMResultSet *rs = nil;
    rs = [DataBase executeQuery:@"SELECT * FROM MISSION"];
    while ([rs next])
    {
        NSString *m_id = [rs stringForColumn:@"id"];
        NSString *name = [rs stringForColumn:@"name"];
        NSString *description = [rs stringForColumn:@"description"];
        NSString *award_type = [rs stringForColumn:@"award_type"];
        NSString *award_var = [rs stringForColumn:@"award_var"];
        NSString *state = [rs stringForColumn:@"state"];
        
        [_mission addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                             m_id, @"id",
                             name, @"name",
                             description, @"description",
                             award_type,@"award_type",
                             award_var,@"award_var",
                             state,@"state",
                             nil]];
    }
    [rs close];
    
    // notification後進入遊戲
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Game:)
                                                 name:@"appDidBecomeActive"
                                               object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    UINavigationBar *navBar = [self.navigationController navigationBar];
    [navBar setBackgroundImage:[UIImage imageNamed:@"mission_bar.png"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int num = 5;
    if (section == 0) {
        num = 2;
    } else {
        num = [_mission count];
    }
    return num;
}

// header!!
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    UICollectionReusableView *supplementaryView = nil;

    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                               withReuseIdentifier:@"footer"
                                                                      forIndexPath:indexPath];
    }
    return supplementaryView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MissionCollectionCell *cell = nil;
    if (indexPath.section == 0 ) {
        if (indexPath.item == 0) {
            NSString *cellIdentifier = @"custom_cell";
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                             forIndexPath:indexPath];
            cell.thumbnail.image = [UIImage imageNamed:@"custom.png"];
        } else {
            NSString *cellIdentifier = @"invite_cell";
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                             forIndexPath:indexPath];
            cell.thumbnail.image = [UIImage imageNamed:@"3Ra7fF3syR_s.png"];
        }
    } else {
        NSString *cellIdentifier = @"mission_cell";
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                         forIndexPath:indexPath];
        NSUInteger index = [indexPath item];
        NSString *name = [[_mission objectAtIndex:index ] objectForKey:@"name"];
        cell.mission_name.text = name;
        cell.cell_id = [[_mission objectAtIndex:index ] objectForKey:@"id"];
        NSLog(@"%@ %@", name, cell.cell_id);
        
        // 沒有圖的話先用 custom 的圖代替
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%@_s.png", cell.cell_id]];
        if (img != nil) {
            cell.thumbnail.image = img;
        } else {
            cell.thumbnail.image = [UIImage imageNamed:@"custom.png"];
        }
        // 完成的任務把 lock 隱藏起來
        if ([[[_mission objectAtIndex:index ] objectForKey:@"state"] boolValue]) {
            cell.lock.hidden = YES;
        }
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(130.0f, 130.0f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.item == 0) {
            [self performSegueWithIdentifier:@"ShowCustom" sender:cell];
        } else if (indexPath.item == 1) {
            [self performSegueWithIdentifier:@"ShowInvite" sender:cell];
        }
    } else if (indexPath.section == 1) {
        [self performSegueWithIdentifier:@"ShowCollect" sender:cell];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[MissionCollectionCell class]]) {
        if ([segue.identifier isEqualToString:@"ShowCollect"]) {
            MissionCollectionCell *cell1 = (MissionCollectionCell *)sender;
            MIssionConditionViewController *conditionPage = segue.destinationViewController;
            [conditionPage setValue:cell1.cell_id forKey:@"m_id"];
        } else if ([segue.identifier isEqualToString:@"ShowInvite"]) {
            //MissionCollectionCell *cell1 = (MissionCollectionCell *)sender;
            //MIssionConditionViewController *conditionPage = segue.destinationViewController;
            //[conditionPage setValue:cell1.cell_id forKey:@"m_id"];
        } else if ([segue.identifier isEqualToString:@"ShowCustom"]) {
            //MissionCollectionCell *cell1 = (MissionCollectionCell *)sender;
            //MIssionConditionViewController *conditionPage = segue.destinationViewController;
            //[conditionPage setValue:cell1.cell_id forKey:@"m_id"];
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
