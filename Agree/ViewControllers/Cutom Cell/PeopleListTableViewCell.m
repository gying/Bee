//
//  PeopleListTableViewCell.m
//  Agree
//
//  Created by G4ddle on 15/2/26.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "PeopleListTableViewCell.h"
#import "SRTool.h"
#import "UIImageView+WebCache.h"

@implementation PeopleListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.avatarImageView.layer setCornerRadius:self.avatarImageView.frame.size.width/2];
    [self.avatarImageView.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithUser: (Model_User *)user {
    self.nicknameLabel.text = user.nickname;
    
    switch ([user.relationship intValue]) {
        case 1: {
            //参与用户
            self.statusLabel.text = @"确认参与";
        }
            break;
        case 2: {
            //拒绝用户
            self.statusLabel.text = @"拒绝参与";
        }
            break;
        case 0: {
            //未表态用户
            self.statusLabel.text = @"未表态";
        }
            break;
        default:
            break;
    }
    
    
    
    //读取头像
    [self.avatarImageView setImageWithURL:[SRTool miniImageUrlFromPath:user.avatar_path]];
}

@end