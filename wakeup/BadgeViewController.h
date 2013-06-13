//
//  BadgeViewController.h
//  wakeup
//
//  Created by din1030 on 13/6/3.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeViewController : UICollectionViewController
@property (nonatomic, strong) NSArray *pobj_ar;
@property (nonatomic, strong) NSArray *aobj_ar;
@property (nonatomic, strong) NSMutableArray *obj_ar;
@property (nonatomic, strong) NSMutableArray *person_id;
@property (nonatomic, strong) NSMutableArray *animal_id;
@end