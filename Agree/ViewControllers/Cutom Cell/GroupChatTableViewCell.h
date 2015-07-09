//
//  GroupChatTableViewCell.h
//  Agree
//
//  Created by G4ddle on 15/2/16.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRChatLabel.h"
#import "GroupDetailViewController.h"
#import "EModel_Chat.h"

@interface GroupChatTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *chatMessageTextLabel;
@property (weak, nonatomic) IBOutlet UIView *chatMessageBackground;
@property (weak, nonatomic) IBOutlet UILabel *chatNicknameLabel;
@property (weak, nonatomic) IBOutlet UIButton *messageBackgroundButton;
@property (weak, nonatomic) IBOutlet UILabel *chatDateLabel;



@property (weak, nonatomic) IBOutlet UIButton *messageBackgroundButton_self;

@property (weak, nonatomic) IBOutlet UIView *chatMessageBackground_self;
@property (weak, nonatomic) IBOutlet UILabel *chatMessageTextLabel_self;
@property (weak, nonatomic) IBOutlet UILabel *chatDateLabel_self;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherViewConRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selfViewConLeft;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

//@property (weak, nonatomic) IBOutlet UIButton *avatarButton_self;

@property (weak, nonatomic) IBOutlet UIButton *avatarButton_self;

- (void)setTalkingAccountType: (int)type;
- (void)initWithChat: (EModel_Chat *)message;

@property (nonatomic, strong)GroupDetailViewController *topViewController;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIButton *imageButton_self;

@end
