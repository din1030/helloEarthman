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
//    FMResultSet *rs2 = nil;
//    FMResultSet *rs3 = nil;
    
    rs = [DataBase executeQuery:@"SELECT req_times FROM INVITE_MISSION WHERE level = 1"];
    rs1 = [DataBase executeQuery:@"SELECT invite_amount FROM USER"];
//    _now_inv_amount = 0;
//    _req_amount = 1;
    while ([rs next])
    {
        _req_amount = [rs intForColumn:@"req_times"];
        //NSLog(@"%d",_req_amount);
    }
    while ([rs1 next])
    {
        _now_inv_amount = [rs1 intForColumn:@"invite_amount"];
       // NSLog(@"now: %d",_now_inv_amount);
    }
    [_invite_progress setProgress:(float)_now_inv_amount/_req_amount];
    [_now_label setText:[NSString stringWithFormat:@"%d",_now_inv_amount]];
    [_req_label setText:[NSString stringWithFormat:@"%d",_req_amount]];
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
    [_now_label release];
    [_req_label release];
    [super dealloc];
}
@end
