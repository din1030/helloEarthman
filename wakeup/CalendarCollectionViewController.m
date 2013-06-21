//
//  CalendarCollectionViewController.m
//  wakeup
//
//  Created by din1030 on 13/6/5.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import "CalendarCollectionViewController.h"
#import "CalendarViewCell.h"
#import "CalHeaderView.h"

#import "AppDelegate.h"
#import "BrainHoleViewController.h"

#import "DataBase.h"

@interface CalendarCollectionViewController ()

@end

static int select_month;
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
    [self.collectionView registerClass:[CalHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CalHeader"];
//    [self.collectionView registerNib:[UINib nibWithNibName:@"CalHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CalHeader"];
    //[self.collectionView registerClass:[BadgeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BadgeHeaderView"];
    
    [self getMonthStartDay:NO];
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UpdateCalendar)
                                                 name:@"UpdateCalendar"
                                               object:nil];
}

- (void) UpdateCalendar
{
    [self getMonthStartDay:YES];
    [self.collectionView reloadData];
}

- (void) getMonthStartDay:(BOOL)flag
{
    NSDate *today = [NSDate date];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:today];
    components.day=1;
    if (flag==NO)
        select_month = components.month;
    else
        components.month = select_month;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *modifydate = [formatter dateFromString:[NSString stringWithFormat:@"%d-%02d-%02d",components.year,components.month,components.day]];
    [formatter setDateFormat:@"EEEE"];
    NSString *dayname = [formatter stringFromDate:modifydate];
    NSLog(@"dayname=%@",dayname);
    if ([dayname isEqualToString:@"Monday"] || [dayname isEqualToString:@"星期一"])
        _startday=1;
    else     if ([dayname isEqualToString:@"Tuesday"] || [dayname isEqualToString:@"星期二"])
        _startday=2;
    else    if ([dayname isEqualToString:@"Wednesday"]|| [dayname isEqualToString:@"星期三"])
        _startday=3;
    else    if ([dayname isEqualToString:@"Thursday"]|| [dayname isEqualToString:@"星期四"])
        _startday=4;
    else    if ([dayname isEqualToString:@"Friday"]|| [dayname isEqualToString:@"星期五"])
        _startday=5;
    else     if ([dayname isEqualToString:@"Saturday"]|| [dayname isEqualToString:@"星期六"])
        _startday=6;
    else
        _startday=7;
    switch (select_month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            _maxmonthday = 31;
            break;
        case 2:
            if (components.year%4==0 && components.year%100!=0 && components.year%400==0)
                _maxmonthday=29;
            else
                _maxmonthday=28;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            _maxmonthday = 30;
            break;
        default:
            break;
    }
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
    
    NSArray *rnd_img = [[NSArray alloc] initWithObjects:@"Squirrel.png",@"Squirrel_n.png",@"FqxZ8m5ErB.png",@"FqxZ8m5ErB_n.png",@"9wroWWspcS.png",@"9wroWWspcS_n.png",@"FPDYGQiaQG.png",@"FPDYGQiaQG_n.png",@"j26WD3BJrw.png",@"j26WD3BJrw_n.png",@"kanX2TK012.png",@"kanX2TK012_n.png",@"o1FVKRgshs.png",@"o1FVKRgshs_n.png", nil];
    int r = arc4random_uniform(14);
    int offset = indexPath.item / 5;
//    if (indexPath.item+1+(8-_startday)*(offset+1)<=_maxmonthday && _startday>5)
    if (_startday>5 && indexPath.item+1+(8-_startday)+offset*2<=_maxmonthday)
    {
        cell.date_num.text =  [NSString stringWithFormat:@"%d",indexPath.item+1+(8-_startday)+offset*2] ;
        cell.badge_thumb.image = [UIImage imageNamed:[rnd_img objectAtIndex:r]];
    }
    else if (_startday < 6 && indexPath.item+1>=_startday && indexPath.item+1 - (_startday-1)+2*offset<=_maxmonthday)
    {
        cell.date_num.text =  [NSString stringWithFormat:@"%d",indexPath.item+1 - (_startday-1)+2*offset] ;        
        cell.badge_thumb.image = [UIImage imageNamed:[rnd_img objectAtIndex:r]];
    }
    else
    {
        cell.date_num.text = @"";
        cell.badge_thumb.image = nil;
    }
    [rnd_img release];
    return cell;
}

#pragma mark - Header

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CalHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CalHeader"forIndexPath:indexPath];
    headerView.month_title.text = [NSString stringWithFormat:@"%d",select_month];
    return headerView;
}

+ (int) Getselectmonth
{
    return select_month;
}
+ (void) Setselectmonth:(int)m
{
    select_month = m;
}

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeMake(self.collectionView.frame.size.width, 100);
//    
//}



@end
