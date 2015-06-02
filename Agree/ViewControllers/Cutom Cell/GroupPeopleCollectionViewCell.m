//
//  GroupPeopleCollectionViewCell.m
//  Agree
//
//  Created by G4ddle on 15/4/30.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "GroupPeopleCollectionViewCell.h"
#import "SRTool.h"
#import "UIImageView+WebCache.h"

@implementation GroupPeopleCollectionViewCell

- (void)initWithGroupUser: (Model_Group_User *)group_user {
    [self.avatarImageView.layer setCornerRadius:self.avatarImageView.frame.size.width/2];
    [self.avatarImageView.layer setMasksToBounds:YES];
    
    [self.avatarImageView setImageWithURL:[SRTool imageUrlFromPath:group_user.avatar_path]];
    [self.nicknameLabel setText:group_user.nickname];
    
//    switch (group_user.role.intValue) {
//        case 1: {
//            [self.statusLabel setText:@"神奇的组长"];
//        }
//            break;
//            
//        case 2: {
//            [self.statusLabel setText:@"普通成员"];
//        }
//            break;
//            
//        default:
//            break;
//    }
}

@end
