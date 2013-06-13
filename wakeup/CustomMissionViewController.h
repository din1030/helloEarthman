//
//  CustomMissionViewController.h
//  wakeup
//
//  Created by din1030 on 13/6/11.
//  Copyright (c) 2013年 din1030. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomMissionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *preview_badge;

@end
