//
//  PeopleListTableViewCell.m
//  Agree
//
//  Created by G4ddle on 15/2/26.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "PeopleListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SRImageManager.h"

#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]
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

- (void)initWithUser: (Model_User *)user withShowStatus: (int)showStatus {
//    self.payButton.layer.masksToBounds = YES;
//    self.payButton.layer.cornerRadius = self.payButton.frame.size.height/4;
//    self.payButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.payButton.layer.borderWidth = 1.0;
    
//    self.tapSwitch.tintColor = AgreeBlue;
//    self.tapSwitch.thumbTintColor = AgreeBlue;
    
    
    switch (showStatus) {
        case 1:{
            [self.tapSwitch setHidden:NO];
        }
            break;
            
        case 2: {
            [self.tapSwitch setHidden:YES];
        }
            break;
            
        case 3: {
            [self.tapSwitch setHidden:YES];
        }
            break;
            
        default:
            break;
    }
    
    self.tapSwitch.onTintColor = AgreeBlue;
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

    //下载图片
    NSURL *imageUrl = [SRImageManager miniAvatarImageFromOSS:user.avatar_path];
    [self.avatarImageView sd_setImageWithURL:imageUrl];
    
}

@end
