//
//  RootAccountRegViewController.h
//  Agree
//
//  Created by G4ddle on 15/3/1.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_User.h"
#import "RootAccountLoginViewController.h"

@interface RootAccountRegViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (nonatomic, strong)Model_User *userInfo;
@property (nonatomic, strong)RootAccountLoginViewController *rootController;




@end
