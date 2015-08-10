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
#import <JGActionSheet.h>

@interface SRTool : NSObject


typedef void (^tapCancelButton)(NSString *msgString);
typedef void (^tapOtherButton)(NSString *msgString);

@property (strong)tapCancelButton tapCancelBlock;
@property (strong)tapOtherButton tapOtherBlock;


typedef void (^tapSheetCancelButton)(void);
typedef void (^tapSheetOtherButton)(int buttonIndex);

@property (strong)tapSheetCancelButton tapSheetCancelBlock;
@property (strong)tapSheetOtherButton tapSheetOtherBlock;

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


+ (void)showSRAlertViewWithTitle:(NSString *)title
                         message:(NSString *)message
               cancelButtonTitle:(NSString *)cancelTitle
                otherButtonTitle:(NSString *)otherButtonTitle
           tapCancelButtonHandle:(tapCancelButton)tapCancelBlock
            tapOtherButtonHandle:(tapOtherButton)tapOtherBlock;

+ (void)showSRAlertOnlyTipWithTitle:(NSString *)title
                            message:(NSString *)message;

+ (JGActionSheet *)showSRSheetInView:(UIView *)view
                           withTitle:(NSString *)title
                             message:(NSString *)message
                     withButtonArray:(NSArray *)buttonAry
                     tapButtonHandle:(tapSheetOtherButton)tapSheetOtherButton
                     tapCancelHandle:(tapSheetCancelButton)tapSheetCancelButton;

@end
