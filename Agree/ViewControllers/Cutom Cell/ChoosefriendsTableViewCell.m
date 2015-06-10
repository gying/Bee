//
//  ChoosefriendsTableViewCell.m
//  Agree
//
//  Created by Agree on 15/6/9.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "ChoosefriendsTableViewCell.h"
#import "UIButton+WebCache.h"
#import "SRTool.h"

@implementation ChoosefriendsTableViewCell {
    Model_User *_user;
}

- (void)awakeFromNib {
    // Initialization code
    
//    self.backgroundColor = [UIColor redColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    
}

- (void)initWithUser: (Model_User *)user {
    _user = user;
    [self.avataButton.layer setCornerRadius:self.avataButton.frame.size.height/2];
    [self.avataButton.layer setMasksToBounds:YES];
    
    [self.avataButton addTarget:self action:@selector(tapAvatarButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.avataButton setBackgroundImageWithURL:[SRTool miniImageUrlFromPath:user.avatar_path] forState:UIControlStateNormal];
    [self.nicknameLabel setText:user.nickname];
    

}

- (void)tapAvatarButton: (UIButton *)sender {
    if (self.topViewController) {
        [self.topViewController.accountView show];
        [self.topViewController.accountView loadWithUser:_user withGroup:nil];
    }


}



@end
