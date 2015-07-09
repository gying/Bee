//
//  CD_Group.h
//  Agree
//
//  Created by G4ddle on 15/6/15.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Model_Group.h"


@interface CD_Group : NSManagedObject

@property (nonatomic, retain) NSNumber * pk_group;
@property (nonatomic, retain) NSString * em_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * setup_time;
@property (nonatomic, retain) NSDate * last_post_time;
@property (nonatomic, retain) NSString * last_post_message;
@property (nonatomic, retain) NSString * avatar_path;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSNumber * party_update;
@property (nonatomic, retain) NSNumber * chat_update;
@property (nonatomic, retain) NSNumber * photo_update;
@property (nonatomic, retain) NSNumber * status;

+ (void)saveGroupToCD: (Model_Group *)group;
+ (NSMutableArray *)getGroupFromCD;
+ (void)removeGroupFromCD: (Model_Group *)group;

+ (void)removeAllGroupFromCD;

@end
