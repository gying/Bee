//
//  CD_User.h
//  Agree
//
//  Created by G4ddle on 15/6/16.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Model_User.h"


@interface CD_User : NSManagedObject

@property (nonatomic, retain) NSNumber * pk_user;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * avatar_path;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSDate * setup_time;
@property (nonatomic, retain) NSDate * last_login_time;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSString * jpush_id;
@property (nonatomic, retain) NSString * device_id;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * relationship;
@property (nonatomic, retain) NSNumber * chat_update;
@property (nonatomic, retain) NSNumber * relationship_update;

+ (void)removeAllUserFromCD;

@end
