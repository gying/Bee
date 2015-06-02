//
//  Model_User_Chat.h
//  Agree
//
//  Created by G4ddle on 15/3/23.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model_User_Chat : NSObject

@property (nonatomic, strong)NSNumber *pk_user_chat;
@property (nonatomic, strong)NSNumber *fk_user_from;
@property (nonatomic, strong)NSNumber *fk_user_to;
@property (nonatomic, strong)NSNumber *category;
@property (nonatomic, strong)NSNumber *type;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *image_path;
@property (nonatomic, strong)NSDate *create_time;

@property (nonatomic, strong)NSNumber *chat_update;
@property (nonatomic, strong)NSNumber *relationship_update;
@property (nonatomic, strong)NSNumber *status;

@property (nonatomic, strong)NSNumber *cell_height;
@property (nonatomic, strong)NSNumber *cell_width;
@property (nonatomic, strong)NSString *avatar_path;
@property (nonatomic, strong)NSString *nickname_from;
@property (nonatomic, strong)NSString *nickname_to;

@end
