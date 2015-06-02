//
//  Model_Group_User.h
//  SRAgree
//
//  Created by G4ddle on 14/12/15.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model_Group_User : NSObject
@property (nonatomic, strong)NSNumber *pk_group_user;
@property (nonatomic, strong)NSNumber *fk_group;
@property (nonatomic, strong)NSNumber *fk_user;
@property (nonatomic, strong)NSNumber *message_warn;
@property (nonatomic, strong)NSNumber *party_warn;
@property (nonatomic, strong)NSNumber *public_phone;
@property (nonatomic, strong)NSString *remarks_name;
@property (nonatomic, strong)NSNumber *role;
@property (nonatomic, strong)NSNumber *status;

@property (nonatomic, strong)NSString *nickname;
@property (nonatomic, strong)NSString *avatar_path;

@end
