//
//  UserSettingViewController.h
//  Agree
//
//  Created by G4ddle on 15/2/7.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserViewController.h"

@interface UserSettingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UIButton *sexButton;

@property (nonatomic, strong)UserViewController *rootViewController;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UILabel *passwordRemarkLabel;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (void)reloadDataView;

@end
