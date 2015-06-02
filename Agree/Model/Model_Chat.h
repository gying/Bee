//
//  Model_Chat.h
//  SRAgree
//
//  Created by G4ddle on 14/12/15.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Model_Chat : NSObject

@property (nonatomic, strong)NSNumber *pk_chat;
@property (nonatomic, strong)NSNumber *fk_group;
@property (nonatomic, strong)NSNumber *fk_user;
@property (nonatomic, strong)NSNumber *category;
@property (nonatomic, strong)NSNumber *type;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *image_path;
@property (nonatomic, strong)NSDate *create_time;
@property (nonatomic, strong)NSNumber *status;

@property (nonatomic, strong)NSNumber *cell_height;
@property (nonatomic, strong)NSNumber *cell_width;
@property (nonatomic, strong)NSString *avatar_path;
@property (nonatomic, strong)NSString *nickname;

@end
