//
//  UserSettingViewController.h
//  Agree
//
//  Created by G4ddle on 15/2/7.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserViewController.h"

#import "TXYDownloader.h"

#import "WXApiObject.h"
#import "WXApi.h"

//@protocol  UserSettingViewController<NSObject>
//
//
//@end

@interface UserSettingViewController : UIViewController<WXApiDelegate>

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UIButton *sexButton;

@property (weak, nonatomic) IBOutlet UIButton *passwordButton;
@property (nonatomic, strong)UserViewController *rootViewController;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UILabel *passwordRemarkLabel;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic , strong)NSString * codeStr;
- (void)reloadDataView;

@end
