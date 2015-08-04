//
//  RootViewController.h
//  Agree
//
//  Created by Agree on 15/8/4.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_User.h"
#import "WXApiObject.h"
#import "WXApi.h"

@interface RootViewController : UIViewController<WXApiDelegate>

@property (weak, nonatomic) IBOutlet UIView *loginRegView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *regButton;

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *phoneLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *weChatLoginButton;

@property (weak, nonatomic) IBOutlet UIView *regView;
@property (weak, nonatomic) IBOutlet UIButton *phoneRegButton;
@property (weak, nonatomic) IBOutlet UIButton *weChatRegButton;




@property (nonatomic , strong)NSString * codeStr;












@end
