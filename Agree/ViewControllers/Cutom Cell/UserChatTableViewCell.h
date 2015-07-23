//
//  UserChatTableViewCell.h
//  Agree
//
//  Created by G4ddle on 15/3/23.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserChatViewController.h"
#import "EModel_User_Chat.h"


@interface UserChatTableViewCell : UITableViewCell<UIActionSheetDelegate>


@property (weak, nonatomic) IBOutlet UIButton *messageBackgroundButton;

//他人发送消息的LABEL
@property (weak, nonatomic) IBOutlet UILabel *chatMessageTextLabel;
@property (weak, nonatomic) IBOutlet UIView *chatMessageBackground;
@property (weak, nonatomic) IBOutlet UILabel *chatNicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *chatDateLabel;

@property (weak, nonatomic) IBOutlet UIButton *messageBackgroundButton_self;
@property (weak, nonatomic) IBOutlet UIView *chatMessageBackground_self;

//自己发送消息的LABEL
@property (weak, nonatomic) IBOutlet UILabel *chatMessageTextLabel_self;
@property (weak, nonatomic) IBOutlet UILabel *chatDateLabel_self;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherViewConRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selfViewConLeft;

//他人头像BUTTON
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
//自己的头像BUTTON
@property (weak, nonatomic) IBOutlet UIButton *avatarButton_self;

- (void)setTalkingAccountType: (int)type;
- (void)initWithChat: (EModel_User_Chat *)message;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIButton *imageButton_self;

@property (nonatomic, strong)UserChatViewController *topViewController;

@end
