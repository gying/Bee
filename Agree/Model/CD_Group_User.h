//
//  CD_Group_User.h
//  Agree
//
//  Created by G4ddle on 15/6/16.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Model_Group_User.h"
#import "Model_Group.h"


@interface CD_Group_User : NSManagedObject

@property (nonatomic, retain) NSNumber * pk_group_user;
@property (nonatomic, retain) NSNumber * fk_group;
@property (nonatomic, retain) NSNumber * fk_user;
@property (nonatomic, retain) NSNumber * message_warn;
@property (nonatomic, retain) NSNumber * party_warn;
@property (nonatomic, retain) NSNumber * public_phone;
@property (nonatomic, retain) NSString * remarks_name;
@property (nonatomic, retain) NSNumber * role;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * avatar_path;

+ (void)saveGroupUserToCD: (Model_Group_User *)groupUser;
+ (NSMutableArray *)getGroupUserFromCD;
+ (void)removeGroupUserFromCD: (Model_Group_User *)groupUser;
+ (NSMutableArray *)getGroupUserFromCDByGroup: (Model_Group *)group;
+ (void)removeGroupUserFromCDByGroup: (Model_Group *)group;

+ (void)removeAllGroupUserFromCD;

@end
