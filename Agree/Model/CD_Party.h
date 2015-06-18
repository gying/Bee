//
//  CD_Party.h
//  Agree
//
//  Created by G4ddle on 15/6/16.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Model_Party.h"
#import "Model_Group.h"


@interface CD_Party : NSManagedObject

@property (nonatomic, retain) NSString * pk_party;
@property (nonatomic, retain) NSNumber * fk_group;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSDate * begin_time;
@property (nonatomic, retain) NSDate * end_time;
@property (nonatomic, retain) NSDate * tip_time;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * fk_user;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * relationship;
@property (nonatomic, retain) NSNumber * pk_party_user;
@property (nonatomic, retain) NSNumber * inNum;

+ (void)savePartyToCD: (Model_Party *)party;
+ (NSMutableArray *)getPartyFromCD;
+ (void)removePartyFromCD: (Model_Party *)party;
+ (NSMutableArray *)getPartyFromCDByRelation: (int)relation;

+ (NSMutableArray *)getPartyFromCDByGroup: (Model_Group *)group;
+ (void)removePartyFromCDByGroup: (Model_Group *)group;

@end
