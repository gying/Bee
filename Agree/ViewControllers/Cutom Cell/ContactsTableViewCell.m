//
//  ContectsTableViewCell.m
//  Agree
//
//  Created by G4ddle on 15/3/19.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "ContactsTableViewCell.h"
#import "UIButton+WebCache.h"
#import "SRTool.h"

@implementation ContactsTableViewCell {
    Model_User *_user;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithUser: (Model_User *)user {
    _user = user;
    [self.avatarButton.layer setCornerRadius:self.avatarButton.frame.size.height/2];
    [self.avatarButton.layer setMasksToBounds:YES];
    
    [self.avatarButton addTarget:self action:@selector(tapAvatarButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.avatarButton setBackgroundImageWithURL:[SRTool miniImageUrlFromPath:user.avatar_path] forState:UIControlStateNormal];
    [self.nicknameLabel setText:user.nickname];
    
    
    if (0 != user.chat_update.intValue) {
        [self.countLabel setHidden:NO];
        [self.countLabel setText:[user.chat_update stringValue]];
    } else {
        [self.countLabel setHidden:YES];
    }
}

- (void)tapAvatarButton: (UIButton *)sender {
    if (self.topViewController) {
        [self.topViewController.accountView show];
        [self.topViewController.accountView loadWithUser:_user withGroup:nil];
    }
}

@end
