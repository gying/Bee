//
//  SRTool.m
//  SuperRabbit
//
//  Created by G4ddle on 14/10/31.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import "SRTool.h"
#import "Model_User.h"
#import <DQAlertView.h>

#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]


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
    
    if ([refDateString isEqualToString:todayString]) {
        return 1;
    } else if ([refDateString isEqualToString:yesterdayString]) {
        return 2;
    } else {
        return 3;
    }
}

+ (void)addPartyUpdateTip: (int) addNum {
    NSNumber *updateValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"party_update"];
    updateValue = [NSNumber numberWithInt: updateValue.intValue + addNum];
    [[NSUserDefaults standardUserDefaults] setObject:updateValue forKey:@"party_update"];
}

+ (BOOL)partyCreatorIsSelf: (Model_Party *)party {
    if ([[Model_User loadFromUserDefaults].pk_user isEqualToNumber:party.fk_user]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)partyPayorIsSelf: (Model_Party *)party {
    if (!party.pay_fk_user) {
        party.pay_fk_user = party.fk_user;
    }
    
    if ([[Model_User loadFromUserDefaults].pk_user isEqualToNumber:party.pay_fk_user]) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)showProgressHUD {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.9]];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setForegroundColor: AgreeBlue];
    [SVProgressHUD show];
}

+ (void)showSRAlertViewWithTitle:(NSString *)title
                         message:(NSString *)message
               cancelButtonTitle:(NSString *)cancelTitle
                otherButtonTitle:(NSString *)otherButtonTitle
           tapCancelButtonHandle:(tapCancelButton)tapCancelBlock
            tapOtherButtonHandle:(tapOtherButton)tapOtherBlock {
    
    DQAlertView *alertView = [[DQAlertView alloc] initWithTitle:title
                                                        message:message
                                              cancelButtonTitle:cancelTitle
                                               otherButtonTitle:otherButtonTitle];
    
    SRTool *delegate = [[SRTool alloc] init];
    delegate.tapCancelBlock = tapCancelBlock;
    delegate.tapOtherBlock = tapOtherBlock;
    
    [alertView.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [alertView.messageLabel setFont:[UIFont systemFontOfSize:13]];
    [alertView.messageLabel setTextColor:[UIColor darkGrayColor]];
    
    [alertView.titleLabel setTextColor:[UIColor darkGrayColor]];
    [alertView.cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    
    if (otherButtonTitle) {
        //根据按钮的数量来确定按钮颜色
        [alertView.cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [alertView.otherButton setTitleColor:AgreeBlue forState:UIControlStateNormal];
        [alertView.otherButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    } else {
        [alertView.cancelButton setTitleColor:AgreeBlue forState:UIControlStateNormal];
        [alertView.otherButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [alertView.otherButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    
    [alertView actionWithBlocksCancelButtonHandler:^{
        delegate.tapCancelBlock(@"点击取消按钮");
    } otherButtonHandler:^{
        delegate.tapOtherBlock(@"点击其他按钮");
    }];
    
    [alertView show];
}

+ (void)showSRAlertOnlyTipWithTitle:(NSString *)title
                            message:(NSString *)message {
    DQAlertView *alertView = [[DQAlertView alloc] initWithTitle:title
                                                        message:message
                                              cancelButtonTitle:@"好的"
                                               otherButtonTitle:nil];
    [alertView.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [alertView.messageLabel setFont:[UIFont systemFontOfSize:13]];
    [alertView.messageLabel setTextColor:[UIColor darkGrayColor]];
    
    [alertView.titleLabel setTextColor:[UIColor darkGrayColor]];
    [alertView.cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    
    [alertView.cancelButton setTitleColor:AgreeBlue forState:UIControlStateNormal];
    [alertView.otherButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [alertView.otherButton.titleLabel setFont:[UIFont systemFontOfSize:14]];

    
    [alertView show];
}

+ (JGActionSheet *)showSRSheetInView:(UIView *)view
                           withTitle:(NSString *)title
                             message:(NSString *)message
                     withButtonArray:(NSArray *)buttonAry
                     tapButtonHandle:(tapSheetOtherButton)tapSheetOtherButton
                     tapCancelHandle:(tapSheetCancelButton)tapSheetCancelButton {
    
    
    if (!buttonAry || 0 == buttonAry.count) {
        //如果没有按钮数组数据,则随机产生数组
        buttonAry = [NSArray arrayWithObjects:@"Yes", "No", nil];
    }
    
    SRTool *delegate = [[SRTool alloc] init];
    delegate.tapSheetCancelBlock = tapSheetCancelButton;
    delegate.tapSheetOtherBlock = tapSheetOtherButton;

    NSMutableArray *sections = [[NSMutableArray alloc] init];

    
    if ([buttonAry.firstObject isKindOfClass:[NSString class]]) {
        //如果按钮为字符对象
        
        JGActionSheetSection *selction = [JGActionSheetSection sectionWithTitle:title message:message buttonTitles:buttonAry buttonStyle:JGActionSheetButtonStyleDefault];
        [sections addObject:selction];

    } else {
        //如果不是,默认为按钮对象
        for (id object in buttonAry) {
            if ([object isKindOfClass:[JGActionSheetSection class]]) {
                //对象正确
                [sections addObject:object];
            } else {
                //对象错误
                return nil;
            }
        }
    }
    
    
    //设置取消按钮
    JGActionSheetSection *cancelSelction = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancel"] buttonStyle:JGActionSheetButtonStyleCancel];
    [sections addObject:cancelSelction];
    
    JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:sections];
    
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        if ((int)indexPath.section == (sheet.sections.count - 1)) {
            //点击最后一个section
            //则默认点击退出按钮
            [sheet dismissAnimated:YES];
            delegate.tapSheetCancelBlock();
        } else {
            delegate.tapSheetOtherBlock((int)indexPath.row);
            [sheet dismissAnimated:YES];
        }
    }];
    [sheet showInView:view animated:YES];
    return sheet;
}



@end
