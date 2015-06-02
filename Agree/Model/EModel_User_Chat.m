//
//  EModel_User_Chat.m
//  Agree
//
//  Created by G4ddle on 15/3/31.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "EModel_User_Chat.h"

@implementation EModel_User_Chat

+ (EModel_User_Chat *)repackEmessage:(EMMessage *)eMsg withSender:(Model_User *)sender {
   
    EModel_User_Chat *newChat = [[EModel_User_Chat alloc] init];
    
    [newChat setMessage:eMsg];
    if (![sender.pk_user isEqualToNumber:[Model_User loadFromUserDefaults].pk_user]) {
        //对方发的信息
        [newChat setNickname_from:sender.nickname];
        [newChat setAvatar_path_from:sender.avatar_path];
        [newChat setFk_user:sender.pk_user];
        newChat.sendFromSelf = NO;
    } else {
        //自己发的信息
        [newChat setNickname_from:sender.nickname];
        [newChat setAvatar_path_from:sender.avatar_path];
        [newChat setFk_user:sender.pk_user];
        newChat.sendFromSelf = YES;
    }
    return newChat;
}

@end
