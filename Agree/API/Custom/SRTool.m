//
//  SRTool.m
//  SuperRabbit
//
//  Created by G4ddle on 14/10/31.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import "SRTool.h"
#import "Model_User.h"

@implementation SRTool

+ (NSString *)dateToString: (NSDate *)date {
    //格式化时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [fmt stringFromDate:date];
    return dateString;
}

+ (NSDate *)stringToDate: (NSString *)string {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [fmt dateFromString:string];
    return date;
}

+ (NSString *)dateStringForPartyListCell: (NSDate *)date {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"MM月dd日 HH:mm";
    NSString *dateString = [fmt stringFromDate:date];
    return dateString;
}

+ (BOOL)isSelfID: (NSNumber *)pk_user {
    if ([[Model_User loadFromUserDefaults].pk_user isEqualToNumber:pk_user]) {
        return TRUE;
    } else {
        return FALSE;
    }
}

+ (NSURL *)imageUrlFromPath: (NSString *)path {
//    NSString *urlString = [NSString stringWithFormat:@"http://superrabbit.oss-cn-qingdao.aliyuncs.com/%@.png",path];
    NSString *urlString = [NSString stringWithFormat:@"http://image.beagree.com/%@.png",path];
    return [NSURL URLWithString:urlString];
}

+ (NSURL *)miniImageUrlFromPath: (NSString *)path {
//    NSString *urlString = [NSString stringWithFormat:@"http://superrabbit.oss-cn-qingdao.aliyuncs.com/%@_mini.png",path];
    NSString *urlString = [NSString stringWithFormat:@"http://image.beagree.com/%@.png",path];
    return [NSURL URLWithString:urlString];
}

//判断日期是属于今天还是昨天
//1:今天
//2:昨天
//3:其他日期
+ (int)dateJudgeWithDate: (NSDate *)date {
    NSDate *today = [NSDate date];
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    NSDate *refDate = date;
    
    // 10 first characters of description is the calendar date:
    NSString *todayString = [[today description] substringToIndex:10];
    NSString *yesterdayString = [[yesterday description] substringToIndex:10];
    NSString *refDateString = [[refDate description] substringToIndex:10];
    
    if ([refDateString isEqualToString:todayString])
    {
        return 1;
        
    } else if ([refDateString isEqualToString:yesterdayString]) {
        return 2;
        
    } else {
        return 3;
        
    }
}



@end