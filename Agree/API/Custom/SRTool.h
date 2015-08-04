//
//  SRTool.h
//  SuperRabbit
//
//  Created by G4ddle on 14/10/31.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model_Party.h"
#import <SVProgressHUD.h>

@interface SRTool : NSObject

+ (NSString *)dateToString: (NSDate *)date;
//+ (NSDate *)stringToDate: (NSString *)string;
+ (NSString *)dateStringForPartyListCell: (NSDate *)date;
+ (BOOL)isSelfID: (NSNumber *)pk_user;

+ (int)dateJudgeWithDate: (NSDate *)date;

+ (void)addPartyUpdateTip: (int) addNum;

//判断聚会创建者是否是自己
+ (BOOL)partyCreatorIsSelf: (Model_Party *)party;

//判断聚会的支付者是否是自己
+ (BOOL)partyPayorIsSelf: (Model_Party *)party;

//+ (void)showProgressHUD;

@end
