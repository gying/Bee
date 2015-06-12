//
//  Model_Party.h
//  SRAgree
//
//  Created by G4ddle on 14/12/15.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model_Party : NSObject
@property (nonatomic, strong)NSString *pk_party;
@property (nonatomic, strong)NSNumber *fk_group;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *remark;

#pragma mark -- 聚会日期
@property (nonatomic, strong)NSDate *begin_time;
@property (nonatomic, strong)NSDate *end_time;
@property (nonatomic, strong)NSDate *tip_time;


@property (nonatomic, strong)NSNumber *longitude;
@property (nonatomic, strong)NSNumber *latitude;
@property (nonatomic, strong)NSString *location;
@property (nonatomic, strong)NSNumber *fk_user;
@property (nonatomic, strong)NSNumber *status;

@property (nonatomic, strong)NSNumber *relationship;
@property (nonatomic, strong)NSNumber *pk_party_user;

//参与人数
@property (nonatomic, strong)NSNumber *inNum;

@end
