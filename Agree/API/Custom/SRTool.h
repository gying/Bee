//
//  SRTool.h
//  SuperRabbit
//
//  Created by G4ddle on 14/10/31.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRTool : NSObject

+ (NSString *)dateToString: (NSDate *)date;
//+ (NSDate *)stringToDate: (NSString *)string;
+ (NSString *)dateStringForPartyListCell: (NSDate *)date;
+ (BOOL)isSelfID: (NSNumber *)pk_user;

//+ (NSURL *)imageUrlFromPath: (NSString *)path;
//+ (NSURL *)miniImageUrlFromPath: (NSString *)path;
+ (int)dateJudgeWithDate: (NSDate *)date;
@end
