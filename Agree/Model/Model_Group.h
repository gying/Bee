//
//  Model_Group.h
//  SRAgree
//
//  Created by G4ddle on 14/12/15.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Model_Group : NSObject
@property (nonatomic, strong)NSNumber *pk_group;
@property (nonatomic, strong)NSString *em_id;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSDate *setup_time;
@property (nonatomic, strong)NSDate *last_post_time;
@property (nonatomic, strong)NSString *last_post_message;
@property (nonatomic, strong)NSString *avatar_path;
@property (nonatomic, strong)NSString *remark;
@property (nonatomic, strong)NSNumber *party_update;
@property (nonatomic, strong)NSNumber *chat_update;
@property (nonatomic, strong)NSNumber *photo_update;

@property (nonatomic, strong)NSNumber *status;

//用户角色 - 外表
@property (nonatomic, strong)NSNumber *role;
@property (nonatomic, strong)NSNumber *chat_last_id;
@property (nonatomic, strong)NSNumber *pk_group_user;

@property (nonatomic, strong)NSNumber *creater;

@end
