//
//  SRAccountView.h
//  Agree
//
//  Created by G4ddle on 15/3/8.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_User.h"
#import "SRNet_Manager.h"
@protocol SRAccountViewDelegate <NSObject>

@end

@interface SRAccountView : UIView

@property (nonatomic, strong)UIView *msgView;
@property (nonatomic, strong)UIButton *backButton;

@property (nonatomic, strong)UIButton *avatarButton;
@property (nonatomic, strong)UIImageView *avatarImageView;

@property (nonatomic, strong)UILabel *nicknameLabel;


@property (nonatomic, strong)UILabel *phoneNumLabel;

@property (nonatomic, strong)UIButton *callButton;
@property (nonatomic, strong)UILabel *callLabel;

@property (nonatomic, strong)UIButton *msgButton;
@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *abButton;
@property (nonatomic, strong)UILabel *abllLabel;

@property (nonatomic, strong)UIButton *addFriendButton;
@property (nonatomic, strong)UILabel *addFriendLabel;

@property (nonatomic, strong)UIButton *delFriendButton;
@property (nonatomic, strong)UILabel *delFriendLabel;

@property (nonatomic, strong)UIButton *talkFriendButton;
@property (nonatomic, strong)UILabel *talkFriendLabel;

@property (nonatomic)UIViewController *rootController;

- (id)init;

- (BOOL)show;
- (void)loadWithUser:(Model_User *)user withGroup: (Model_Group *)group;




@end
