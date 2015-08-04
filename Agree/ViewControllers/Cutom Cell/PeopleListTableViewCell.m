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
@implementation PeopleListTableViewCell  {
    Model_User *_user;
}

- (void)awakeFromNib {
    // Initialization code
    
    [self.avatarImageView.layer setCornerRadius:self.avatarImageView.frame.size.width/2];
    [self.avatarImageView.layer setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

- (void)initWithUser: (Model_User *)user
      withShowStatus: (int)showStatus
           isCreator: (BOOL)isCreator
             isPayor: (BOOL)isPayor {
//    self.payButton.layer.masksToBounds = YES;
//    self.payButton.layer.cornerRadius = self.payButton.frame.size.height/4;
//    self.payButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.payButton.layer.borderWidth = 1.0;
    
//    self.tapSwitch.tintColor = AgreeBlue;
//    self.tapSwitch.thumbTintColor = AgreeBlue;
    _user = user;

    
    switch (showStatus) {
        case 1:{
//            if (YES) {
            if (isPayor) {
                //在当前用户为付款者的时候才进行支付控制的展示
                [self.tapSwitch setHidden:NO];
                [self.payLabel setHidden:NO];
                
                if (!user.pay_type) {
                    user.pay_type = @0;
                }

                switch (user.pay_type.intValue) {
                    case 1: {   //未付
                        [self.tapSwitch setOn:NO];
                        [self switchChange:self.tapSwitch];
                    }
                        break;
                    case 2: {
                        //已付
                        //已付款情况直接禁用switch.
                        [self.tapSwitch setOn:YES];
                        [self.tapSwitch setEnabled:NO];
                        [self switchChange:self.tapSwitch];
                    }
                        break;
                    case 3: {   //代付
                        
                    }
                        break;
                    default: {  //其他
                        [self.tapSwitch setOn:NO];
                        [self switchChange:self.tapSwitch];
                    }
                        break;
                }
                
                [self.tapSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
                
            } else {
                //在非付款者的情况下也进行支付显示,不过禁用switch按钮
                [self.tapSwitch setHidden:NO];
                [self.payLabel setHidden:NO];
                
                if (!user.pay_type) {
                    user.pay_type = @0;
                }
                
                switch (user.pay_type.intValue) {
                    case 1: {   //未付
                        [self.tapSwitch setOn:NO];
                        [self switchChange:self.tapSwitch];
                    }
                        break;
                    case 2: {
                        //已付
                        //已付款情况直接禁用switch.
                        [self.tapSwitch setOn:YES];
                        [self.tapSwitch setEnabled:NO];
                        [self switchChange:self.tapSwitch];
                    }
                        break;
                    case 3: {   //代付
                        
                    }
                        break;
                    default: {  //其他
                        [self.tapSwitch setOn:NO];
                        [self switchChange:self.tapSwitch];
                    }
                        break;
                }
                
                //设置为全部禁用
                [self.tapSwitch setEnabled:NO];
            }
        }
            break;
            
        case 2: {
            [self.tapSwitch setHidden:YES];
            [self.payLabel setHidden:YES];
        }
            break;
            
        case 3: {
            [self.tapSwitch setHidden:YES];
            [self.payLabel setHidden:YES];
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
            
            if (user.pay_amount) {
                self.statusLabel.text = [[NSString alloc] initWithFormat:@"%d元", user.pay_amount.intValue];
            }
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
    
    
    switch (user.pay_type.intValue) {
        case 1: {   //未付
            self.statusLabel.text = [[NSString alloc] initWithFormat:@"%d元 等待支付..", user.pay_amount.intValue];
        }
            break;
        case 2: {
            //已付
            self.statusLabel.text = [[NSString alloc] initWithFormat:@"%d元 支付完成..", user.pay_amount.intValue];
        }
            break;
        case 3: {   //代付
            
        }
            break;
        default: {  //其他
            
        }
            break;
    }

    //下载图片
    NSURL *imageUrl = [SRImageManager miniAvatarImageFromOSS:user.avatar_path];
    [self.avatarImageView sd_setImageWithURL:imageUrl];
    
}

- (void)switchChange: (id)sender {
    if (self.tapSwitch.on) {
        [self.payLabel setText:@"已支付"];
        [self.payLabel setTextColor:AgreeBlue];
        _user.pay_type = @2;
        
        
    } else {
        [self.payLabel setText:@"未支付"];
        [self.payLabel setTextColor:[UIColor lightGrayColor]];
        _user.pay_type = @0;
    }
}

@end
