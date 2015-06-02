//
//  People.h
//  Agree
//
//  Created by G4ddle on 15/3/19.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model_User.h"

@interface People : NSObject

@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSMutableArray *phoneAry;
@property int people_id;

@property (nonatomic, strong)Model_User *userInfo;

@end
