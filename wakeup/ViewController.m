//
//  ViewController.m
//  wakeup
//
//  Created by din1030 on 13/5/8.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "BrainHoleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DataBase.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
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
    
    //更改錨點
    [_badgetable .layer setAnchorPoint:CGPointMake(0.5,0)];
    _badgetable.center = CGPointMake(_badgetable.center.x, _badgetable.center.y-_badgetable.frame.size.height/2);
    
    _theme_index=0;
    _themelist = [[NSMutableArray alloc] initWithObjects: nil];
    FMResultSet *rs = nil;
    rs = [DataBase executeQuery:@"SELECT id FROM THEME"];
    [_themelist addObject:@"room"];  //default theme
    [_themelist addObject:@"6YaLTunYln"];  //default theme
    //等待DB的圖檔健全
    //    while ([rs next])
    //    {
    //        NSString *t_id = [rs stringForColumn:@"id"];
    //        [_itemlist addObject:t_id];
    //    }
    [rs close];
    [self window_reset];
}

- (void) window_reset
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.hr>=19 || appDelegate.hr<=6)
        [self.window setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_w2.png",[_themelist objectAtIndex:_theme_index]]]];
    else
        [self.window setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_w1.png",[_themelist objectAtIndex:_theme_index]]]];
}

- (void) item_animation
{
    int r = arc4random_uniform(5);
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrame.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    UIButton *btn = [_itemlist objectAtIndex:r];
    CGPoint ori_point = btn.center;
    int offset = 3;
    switch (r)
    {
        case 0:
            [self audioplay:@"alarmclock2"];
            keyFrame.values = @[[NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x-offset,ori_point.y-offset)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x+offset,ori_point.y-offset)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x-offset,ori_point.y-offset)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x+offset,ori_point.y-offset)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y)]];
            keyFrame.duration=0.2;
            [btn.layer addAnimation:keyFrame forKey:@"keyFrame"];
            break;
        case 1:
            keyFrame.values = @[[NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset*2)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset*3)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset*4)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset*3)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y-offset*2)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x,ori_point.y)]];
            keyFrame.duration=0.7;
            [btn.layer addAnimation:keyFrame forKey:@"keyFrame"];
            break;
        case 2:
            keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
            keyFrame.values = @[[NSNumber numberWithFloat:DegreeToRadian(30)],
                                [NSNumber numberWithFloat:DegreeToRadian(0)],
                                [NSNumber numberWithFloat:DegreeToRadian(-30)],
                                [NSNumber numberWithFloat:DegreeToRadian(0)],
                                [NSNumber numberWithFloat:DegreeToRadian(30)],
                                [NSNumber numberWithFloat:DegreeToRadian(0)]];
            keyFrame.duration=1.4;
            [btn.layer addAnimation:keyFrame forKey:@"keyFrame"];
            break;
        case 3:
            btn.alpha = 1.0f;
            [UIView animateWithDuration:1
                                  delay:0.5
                                options:UIViewAnimationOptionCurveEaseInOut  | UIViewAnimationOptionAutoreverse
                             animations:^{
                                 btn.alpha = 0.0f;
                             }
                             completion:^(BOOL finished){
                                 btn.alpha = 1.0f;
                             }];
            break;
        case 4:
            [self window_reset];
            [self audioplay:@"ufo"];
            offset = 5;
            ori_point = self.ufo.center;
            self.ufo.hidden = NO;
            _ufomsg.hidden = YES;
            // 移動路徑
            keyFrame.values = @[[NSValue valueWithCGPoint:CGPointMake(ori_point.x-offset*2,ori_point.y+offset)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x-offset*3,ori_point.y-offset*2)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x-offset*4,ori_point.y+offset*4)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x-offset,ori_point.y+offset*3)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x-offset*5,ori_point.y+offset*7)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x-offset*8,ori_point.y+offset*10)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x-offset*3,ori_point.y+offset*14)],
                                [NSValue valueWithCGPoint:CGPointMake(ori_point.x+offset*8,ori_point.y+offset*5)]];
            keyFrame.duration=2.9;
            [self.ufo.layer addAnimation:keyFrame forKey:@"keyFrame"];
            
            // 縮放大小
            CAKeyframeAnimation *ScalekeyFrame = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            ScalekeyFrame.values = @[[NSValue valueWithCATransform3D:CATransform3DScale (self.ufo.layer.transform, 0.2, 0.2, 0.2)],
                                [NSValue valueWithCATransform3D:CATransform3DScale (self.ufo.layer.transform, 0.4, 0.4, 0.4)],
                                [NSValue valueWithCATransform3D:CATransform3DScale (self.ufo.layer.transform, 0.6, 0.6, 0.6)],
                                [NSValue valueWithCATransform3D:CATransform3DScale (self.ufo.layer.transform, 0.8, 0.8, 0.8)],
                                [NSValue valueWithCATransform3D:CATransform3DScale (self.ufo.layer.transform, 1.0, 1.0, 1.0)],
                                [NSValue valueWithCATransform3D:CATransform3DScale (self.ufo.layer.transform, 1.2, 1.2, 1.2)],
                                [NSValue valueWithCATransform3D:CATransform3DScale (self.ufo.layer.transform, 1.4, 1.4, 1.4)],
                                [NSValue valueWithCATransform3D:CATransform3DScale (self.ufo.layer.transform, 1.6, 1.6, 1.6)],
                                [NSValue valueWithCATransform3D:CATransform3DScale (self.ufo.layer.transform, 1.8, 1.8, 1.8)]];
            ScalekeyFrame.duration=2.9;
            [self.ufo.layer addAnimation:ScalekeyFrame forKey:@"ScalekeyFrame"];
            
            // 透明度控制＆換圖
            self.ufo.alpha = 1.0f;
            [UIView animateWithDuration:0.5
                                  delay:1.9
                                options:UIViewAnimationOptionCurveEaseInOut 
                             animations:^{
                                 self.ufo.alpha = 0.0f;
                             }
                             completion:^(BOOL finished){
                                 _ufo.hidden = YES;
                                 if (appDelegate.hr>=19 || appDelegate.hr<=6)
                                 {
                                     _window.animationImages = [NSArray arrayWithObjects:
                                                                [UIImage imageNamed:[NSString stringWithFormat:@"%@_w2.png",[_themelist objectAtIndex:_theme_index]]],
                                                                [UIImage imageNamed:[NSString stringWithFormat:@"%@_w2a.png",[_themelist objectAtIndex:_theme_index]]],
                                                                [UIImage imageNamed:[NSString stringWithFormat:@"%@_w2b.png",[_themelist objectAtIndex:_theme_index]]],
                                                                [UIImage imageNamed:[NSString stringWithFormat:@"%@_w2c.png",[_themelist objectAtIndex:_theme_index]]],
                                                                [UIImage imageNamed:[NSString stringWithFormat:@"%@_w2d.png",[_themelist objectAtIndex:_theme_index]]],
                                                                [UIImage imageNamed:[NSString stringWithFormat:@"%@_w2e.png",[_themelist objectAtIndex:_theme_index]]],nil];
                                                                          [_window setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_w2e.png",[_themelist objectAtIndex:_theme_index]]]];
                                 }
                                 else
                                 {
                                     _window.animationImages = [NSArray arrayWithObjects:
                                                                [UIImage imageNamed:[NSString stringWithFormat:@"%@_w1.png",[_themelist objectAtIndex:_theme_index]]],
                                                                [UIImage imageNamed:[NSString stringWithFormat:@"%@_w1a.png",[_themelist objectAtIndex:_theme_index]]],
                                                                [UIImage imageNamed:[NSString stringWithFormat:@"%@_w1b.png",[_themelist objectAtIndex:_theme_index]]],
                                                                [UIImage imageNamed:[NSString stringWithFormat:@"%@_w1c.png",[_themelist objectAtIndex:_theme_index]]],
                                                                [UIImage imageNamed:[NSString stringWithFormat:@"%@_w1d.png",[_themelist objectAtIndex:_theme_index]]],
                                                                [UIImage imageNamed:[NSString stringWithFormat:@"%@_w1e.png",[_themelist objectAtIndex:_theme_index]]],nil];
                                     [_window setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_w1e.png",[_themelist objectAtIndex:_theme_index]]]];
                                 }
                                 [_window setAnimationRepeatCount:1];
                                 [_window setAnimationDuration:1.5];
                                 [self performSelector:@selector(showufomsg) withObject:nil afterDelay:[_window animationDuration]];
                                 [_window startAnimating];
                             }];
            
    }
}

-(void)showufomsg {
    [_window.layer removeAllAnimations];
    _ufomsg.hidden = NO;
    // 讀取plist
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"ufomsg"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"ufomsg" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    NSArray *msg = [temp objectForKey:@"msg"];
    int r = arc4random_uniform(9);
    _ufomsg.text = [msg objectAtIndex:r];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }

}

CGFloat DegreeToRadian(CGFloat degrees)
{
    degrees = (int)degrees%360;
    return degrees * M_PI / 180;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    _itemlist = [[NSArray alloc] initWithObjects:_alarm, _calendar, _badgetable, _theme, _window, nil];
    _random_timer = [NSTimer scheduledTimerWithTimeInterval:10  // 遊戲秒數
                                                     target:self
                                                   selector:@selector(item_animation)
                                                   userInfo:nil
                                                    repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    [_random_timer invalidate];
    [_themePlayer stop];
}

- (void)Game:(NSString *)clock_id
{
    // 切換clock_id對應的遊戲
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isAlarm = NO;
    BrainHoleViewController *brainhole_vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GamePage"];
    [self.navigationController pushViewController:brainhole_vc animated:NO];
}

- (IBAction)theme_OnClick:(UIButton *)sender {
    [self audioplay:@"item_change"];
    if (_theme_index==[_themelist count]-1)
        _theme_index=0;
    else
        _theme_index++;
    [_background setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_bg.png",[_themelist objectAtIndex:_theme_index]]]];
    [_alarm setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_a.png",[_themelist objectAtIndex:_theme_index]]] forState:UIControlStateNormal];
    [_calendar setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_c.png",[_themelist objectAtIndex:_theme_index]]] forState:UIControlStateNormal];
    [_badgetable setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_mb.png",[_themelist objectAtIndex:_theme_index]]] forState:UIControlStateNormal];
    [_theme setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_t.png",[_themelist objectAtIndex:_theme_index]]] forState:UIControlStateNormal];
    [_setting setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_s.png",[_themelist objectAtIndex:_theme_index]]] forState:UIControlStateNormal];
    _ufomsg.hidden = YES;
    [self window_reset];
}

- (void) audioplay:(NSString *) filename
{
    NSURL* url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:filename ofType:@"mp3"]];
    //與音樂檔案做連結
    NSError* error = nil;
    _themePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    [_themePlayer setNumberOfLoops:0];
    [_themePlayer play];
    [url release];

}

- (void)dealloc {
    [_window release];
    [_alarm release];
    [_badgetable release];
    [_theme release];
    [_calendar release];
    [_setting release];
    [_random_timer invalidate];
    [_itemlist release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_background release];
    [_ufo release];
    [_themePlayer release];
    [_ufomsg release];
    [super dealloc];
}

@end
