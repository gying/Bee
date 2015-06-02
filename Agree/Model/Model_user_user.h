//
//  Model_user_user.h
//  Agree
//
//  Created by G4ddle on 15/3/16.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model_user_user : NSObject

@property (nonatomic, strong)NSNumber *pk_user_user;

@property (nonatomic, strong)NSNumber *fk_user_from;
@property (nonatomic, strong)NSString *user_from_remark_name;
@property (nonatomic, strong)NSNumber *fk_user_to;
@property (nonatomic, strong)NSString *user_to_remark_name;

@property (nonatomic, strong)NSNumber *relationship;
@property (nonatomic, strong)NSDate *create_date;
@property (nonatomic, strong)NSNumber *status;

@end
