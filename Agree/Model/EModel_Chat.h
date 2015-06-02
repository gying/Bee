//
//  EModel_Chat.h
//  Agree
//
//  Created by G4ddle on 15/4/2.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMMessage.h"
#import "Model_Group_User.h"

@interface EModel_Chat : NSObject

@property (nonatomic, strong)EMMessage *message;

@property (nonatomic, strong)NSNumber *fk_user;

@property BOOL sendFromSelf;
@property (nonatomic, strong)NSNumber *cell_height;
@property (nonatomic, strong)NSNumber *cell_width;
@property (nonatomic, strong)NSString *avatar_path_from;
@property (nonatomic, strong)NSString *nickname_from;

+ (EModel_Chat *)repackEmessage:(EMMessage *)eMsg withRelation:(Model_Group_User *)sender;

@end
