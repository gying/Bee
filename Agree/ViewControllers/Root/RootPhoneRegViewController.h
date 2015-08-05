//
//  RootPhoneRegViewController.h
//  Agree
//
//  Created by Agree on 15/6/30.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRNet_Manager.h"
#import "RootAccountRegViewController.h"
#import "Model_User.h"

@interface RootPhoneRegViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *numberLable;
@property (weak, nonatomic) IBOutlet UITextField *numberTextfield;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (nonatomic, strong)Model_User *userInfo;

@property BOOL regByWechat;
@property (nonatomic, strong)UIImage *avatarImage;


@end
