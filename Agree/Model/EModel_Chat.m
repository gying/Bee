//
//  EModel_Chat.m
//  Agree
//
//  Created by G4ddle on 15/4/2.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "EModel_Chat.h"
#import "Model_User.h"

@implementation EModel_Chat

+ (EModel_Chat *)repackEmessage:(EMMessage *)eMsg withRelation:(Model_Group_User *)sender {
    
    EModel_Chat *newChat = [[EModel_Chat alloc] init];
    [newChat setMessage:eMsg];
    if ([sender.fk_user isEqualToNumber:[Model_User loadFromUserDefaults].pk_user]) {
        //自己发的信息
        [newChat setNickname_from:sender.nickname];
        [newChat setAvatar_path_from:sender.avatar_path];
        [newChat setFk_user:sender.fk_user];
        newChat.sendFromSelf = YES;
    } else {
        //对方发的信息
        [newChat setNickname_from:sender.nickname];
        [newChat setAvatar_path_from:sender.avatar_path];
        [newChat setFk_user:sender.fk_user];
        newChat.sendFromSelf = NO;
    }
//    if (sender) {
//        
//    } else {
//        
//    }
    return newChat;
}

@end
