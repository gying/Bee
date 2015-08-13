//
//  GroupPeopleTableViewCell.m
//  Agree
//
//  Created by Agree on 15/8/7.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "GroupPeopleTableViewCell.h"
#import "UIButton+WebCache.h"
#import "SRImageManager.h"
#import <SDWebImageManager.h>

@implementation GroupPeopleTableViewCell
{
    
    Model_Group_User * _user ;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)initWithUser: (Model_Group_User *)user
{
    _user = user;
    [self.avatarButton.layer setCornerRadius:self.avatarButton.frame.size.height/2];
    [self.avatarButton.layer setMasksToBounds:YES];
    
//    self.avatarButton.layer.borderWidth = 0.5;
//    self.avatarButton.layer.borderColor = [UIColor lightTextColor].CGColor;
    //下载图片
    NSURL *imageUrl = [SRImageManager miniAvatarImageFromOSS:user.avatar_path];
    [self.avatarButton sd_setBackgroundImageWithURL:imageUrl forState:UIControlStateNormal];
    [self.nickName setText:user.nickname];
    
    if ([user.role isEqual:@1]) {
        self.role.text = @"群主";
    }else
    {
        self.role.text = @"成员";
    }
}

@end
