//
//  Model_User.h
//  SRAgree
//
//  Created by G4ddle on 14/12/15.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kDefUser    @"defUser"

@interface Model_User : NSObject
@property (nonatomic, strong)NSNumber *pk_user;
@property (nonatomic, strong)NSString *nickname;
@property (nonatomic, strong)NSString *avatar_path;
@property (nonatomic, strong)NSString *phone;
@property (nonatomic, strong)NSString *password;
@property (nonatomic, strong)NSDate *setup_time;
@property (nonatomic, strong)NSDate *last_login_time;
@property (nonatomic, strong)NSNumber *sex;
@property (nonatomic, strong)NSString *jpush_id;
@property (nonatomic, strong)NSString *device_id;
@property (nonatomic, strong)NSNumber *status;

@property (nonatomic, strong)NSNumber *relationship;

@property (nonatomic, strong)NSNumber *chat_update;
@property (nonatomic, strong)NSNumber *relationship_update;

- (void)saveToUserDefaults;
+ (Model_User *)loadFromUserDefaults;

@end
