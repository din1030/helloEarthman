//
//  DataBase.m
//  NCCUActivity
//
//  Created by Mahmood1 on 12/12/27.
//  Copyright (c) 2012年 Emilia. All rights reserved.
//

#import "DataBase.h"

@implementation DataBase

// Connect to Database
+ (FMDatabase *)connectToDataBase
{
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbPath = [docPath stringByAppendingPathComponent:@"wakeup.db"];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // Check if the database is existed.
    if(![fm fileExistsAtPath:dbPath])
    {
        NSError* error;
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"wakeup.db"];
        BOOL success = [fm copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        if(!success){
            NSLog(@"can't copy db template.");
            assert(false);
        }
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open])
    {
        NSLog(@"Could not open db.");
        return nil;
    }
    return db;
}

// Select Table Content
+ (FMResultSet *)executeQuery:(NSString *)strSQL
{
    FMDatabase *db = [self connectToDataBase];
    return [db executeQuery:strSQL];
}

// Modify Table
+ (void)executeModifySQL:(NSString *)strSQL
{
    FMDatabase *db = [self connectToDataBase];
    [db executeUpdate:strSQL];
}

@end
