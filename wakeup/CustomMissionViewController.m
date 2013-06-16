//
//  CustomMissionViewController.m
//  wakeup
//
//  Created by din1030 on 13/6/11.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import "QuartzCore/QuartzCore.h"
#import "CustomMissionViewController.h"
#import "DataBase.h"

@interface CustomMissionViewController () <UIPickerViewDelegate,UIPickerViewDataSource> // <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation CustomMissionViewController

@synthesize target_picker, badge_list, badge_image, bid, indicator;
@synthesize day,day_1,day_2,day_3,day_4,day_5;

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
    target_picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 118, 320, 216)];
    target_picker.delegate = self;
    //target_picker.showsSelectionIndicator = YES;
	target_picker.backgroundColor = [UIColor blackColor];
    
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-3.14/2);
	rotate = CGAffineTransformScale(rotate, 0.16f, 1.5f);
	[target_picker setTransform:rotate];
    
    [self.view addSubview:target_picker];
    [target_picker.layer setZPosition:1.0];
    [indicator.layer setZPosition:2.0];
    
    
    CGAffineTransform rotateItem = CGAffineTransformMakeRotation(3.14/2);
	rotateItem = CGAffineTransformScale(rotateItem, 0.7, 5);
    
    badge_list =  [[NSMutableArray alloc] init];
    FMResultSet *rs1 = [DataBase executeQuery:@"SELECT * FROM PERSON_BADGE"];
    int a = 0;
    while ([rs1 next])
    {   
        bid = [rs1 stringForColumn:@"id"];
        
        //UIImageView *badge = [[UIImageView alloc] initWithImage:[NSString stringWithFormat:@"%@.png",bid]];
        //  圖片要改？
        NSArray *rnd_img = [[NSArray alloc] initWithObjects:@"badge_tw.png",@"badge_tw_n.png",@"badge_jp.png",@"badge_jp_n.png",@"Squirrel.png",@"Squirrel_n.png", nil];
        int r = a%6;
        UIImageView *badge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[rnd_img objectAtIndex:r]]]; //[UIImage imageNamed:@"FqxZ8m5ErB.png"]];
		[rnd_img release];
                              
        badge.frame = CGRectMake(0,0, 50, 50);
		badge.backgroundColor = [UIColor clearColor];

        //[badge setImage:[UIImage imageNamed:@"FqxZ8m5ErB.png"]];
		
		badge.transform = rotateItem;
        [badge_list addObject:badge];
        [badge release];
        a++;
    }
    
    [target_picker selectRow:[badge_list count]/2 inComponent:0 animated:YES];
    day = [[NSMutableArray alloc] initWithObjects:day_1,day_2,day_3,day_4,day_5, nil];   
    [self get_lastdays];
    
}

- (void) get_lastdays {
    FMResultSet *rs = [DataBase executeQuery:@"SELECT begin_date,last_days FROM USER"];
    while ([rs next])
    {
        NSString *date = [rs stringForColumnIndex:0];
        NSUInteger last_days = [rs intForColumnIndex:1];
        NSArray *dateArray =  [date componentsSeparatedByString:@"-"];

        for (int i = 0; i <= last_days; i++) {
            UILabel *temp = day[i];
#warning 跨月的計算
            int d = [dateArray[2] intValue] + i;
            temp.text = [NSString stringWithFormat:@"%d",d];
        }
        
    }
}

#pragma mark -
#pragma mark Picker View Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	return [badge_list count];
}

- (UIView *)pickerView:(UIPickerView *)thePickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	return [badge_list objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //  圖片要改？
    NSArray *rnd_img = [[NSArray alloc] initWithObjects:@"badge_tw.png",@"badge_tw_n.png",@"badge_jp.png",@"badge_jp_n.png",@"Squirrel.png",@"Squirrel_n.png", nil];
    int r = row%6;
    badge_image.image = [UIImage imageNamed:[rnd_img objectAtIndex:r]]; //[NSString stringWithFormat:@"%@.png", bid]];
    [rnd_img release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [badge_image release];
    [indicator release];
    [day release];
    [super dealloc];
}
@end
