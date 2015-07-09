//
//  CD_Photo.h
//  Agree
//
//  Created by G4ddle on 15/6/15.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Model_Photo.h"
#import "Model_Group.h"


@interface CD_Photo : NSManagedObject

@property (nonatomic, retain) NSString * pk_photo;
@property (nonatomic, retain) NSNumber * fk_group;
@property (nonatomic, retain) NSString * fk_party;
@property (nonatomic, retain) NSNumber * fk_user;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSDate * create_time;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSNumber * status;

+ (void)savePhotoToCD: (Model_Photo *)photo;
+ (NSMutableArray *)getPhotoFromCDByGroup: (Model_Group *)group;
+ (void)removePhotoFromCD: (Model_Photo *)photo;
+ (void)removePhotoFromCDByGroup: (Model_Group *)group;

+ (void)removeAllPhotoFromCD;

@end
