//
//  Model_Group_Code.h
//  Agree
//
//  Created by G4ddle on 15/1/27.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model_Group_Code : NSObject

@property (nonatomic, strong)NSString *pk_group_code;
@property (nonatomic, strong)NSNumber *fk_group;
@property (nonatomic, strong)NSDate *create_time;

@property (nonatomic, strong)NSNumber *code_status;

@end
