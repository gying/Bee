//
//  GroupPeopleCollectionViewCell.m
//  Agree
//
//  Created by G4ddle on 15/4/30.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "GroupPeopleCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "SRImageManager.h"

@implementation GroupPeopleCollectionViewCell

- (void)initWithGroupUser: (Model_Group_User *)group_user {
    [self.avatarImageView.layer setCornerRadius:self.avatarImageView.frame.size.width/2];
    [self.avatarImageView.layer setMasksToBounds:YES];

    //下载图片
    NSURL *imageUrl = [SRImageManager avatarImageFromOSS:group_user.avatar_path];
    [self.avatarImageView sd_setImageWithURL:imageUrl];
    [self.nicknameLabel setText:group_user.nickname];
}

@end
