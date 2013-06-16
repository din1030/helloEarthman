//
//  DataBase.h
//  NCCUActivity
//
//  Created by Mahmood1 on 12/12/27.
//  Copyright (c) 2012年 Emilia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DataBase : NSObject

//@property (strong, nonatomic) FMDatabase *db;
//- (FMDatabase *)connectToDataBase;
+ (FMResultSet *)executeQuery:(NSString *)strSQL;
+ (void)executeSQL:(NSString *)strSQL;

@end
