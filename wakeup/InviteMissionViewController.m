//
//  InviteMissionViewController.m
//  wakeup
//
//  Created by din1030 on 13/6/14.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import "InviteMissionViewController.h"
#import "DataBase.h"

@interface InviteMissionViewController ()

@end

@implementation InviteMissionViewController

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
    FMResultSet *rs = nil;
    FMResultSet *rs1 = nil;
    
    rs = [DataBase executeQuery:@"SELECT * FROM INVITE_MISSION"];
    rs1 = [DataBase executeQuery:@"SELECT invite_amount FROM USER"];
    _now_inv_amount = 0;
    _req_amount = 1;  // prevent from dividinf by 0
    while ([rs1 next])
    {
        _now_inv_amount = [rs1 intForColumn:@"invite_amount"];
    }
    while ([rs next])
    {
        NSLog(@"rs");
        _req_amount = [rs intForColumn:@"req_times"];
        BOOL state = [rs boolForColumn:@"state"];
        if (!state) {
            NSLog(@"state");
            NSUInteger lv = [rs intForColumn:@"level"];
            [self.lv_num setText:[NSString stringWithFormat:@"LV: %d",lv]];
            break;
        }
    }
    [rs close];
    [rs1 close];
    
    
    if (_now_inv_amount > _req_amount) {
        [_check_button setUserInteractionEnabled:YES];
        [_check_button setAlpha:1.0];
    }
    
    [_invite_progress setProgress:(float)_now_inv_amount/_req_amount];
    [_req_label setText:[NSString stringWithFormat:@"%d / %d",_now_inv_amount,_req_amount]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setInvite_progress:nil];
    [self setLv_num:nil];
    [super viewDidUnload];
}

- (void)updateProgress {
    
}


- (void)dealloc {
    [_req_label release];
    [_check_button release];
    [super dealloc];
}
@end
