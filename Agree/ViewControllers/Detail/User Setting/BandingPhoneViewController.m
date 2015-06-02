//
//  BandingPhoneViewController.m
//  Agree
//
//  Created by G4ddle on 15/3/15.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "BandingPhoneViewController.h"
#import "SRNet_Manager.h"
#import "ProgressHUD.h"
#import "UserSettingViewController.h"

#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]

@interface BandingPhoneViewController ()<SRNetManagerDelegate> {
    SRNet_Manager *_netManager;
    BOOL _sendCodeDone;
    NSString *_phoneNum;
    NSString *_code;
}


@end

@implementation BandingPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.sendButton setAlpha:0.2];
    [self.sendButton setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)phoneTextEditingChanged:(UITextField *)sender {
    
    if (!_sendCodeDone) {
        if (sender.text.length == 11) {
            [self.sendButton setAlpha:1.0];
            [self.sendButton setEnabled:YES];
        } else {
            [self.sendButton setAlpha:0.2];
            [self.sendButton setEnabled:NO];
        }
    } else {
        if (sender.text.length == 4) {
            [self.sendButton setAlpha:1.0];
            [self.sendButton setEnabled:YES];
        } else {
            [self.sendButton setAlpha:0.2];
            [self.sendButton setEnabled:NO];
        }
    }
}

- (IBAction)pressedTheSendButton:(UIButton *)sender {
    if (!_netManager) {
        _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
    }
    if (!_sendCodeDone) {
        _phoneNum = self.phoneTextField.text;
        [_netManager sendVerificationCode:self.phoneTextField.text];
    } else {
        //验证码确认
        if ([_code isEqualToString:self.self.phoneTextField.text]) {
            //确认验证码完毕,保存到帐号信息
            Model_User *sendUser = [[Model_User alloc] init];
            [sendUser setPhone:_phoneNum];
            [sendUser setPk_user:[Model_User loadFromUserDefaults].pk_user];
            [_netManager updateUserInfo:sendUser];
        } else {
            [self.remarkLabel setText:@"验证码错误,请重新输入"];
        }
    }
}

- (void)interfaceReturnDataSuccess:(NSMutableDictionary *)jsonDic with:(int)interfaceType {
    
    switch (interfaceType) {
        case kSendVerificationCode: {
            if (jsonDic) {
                _sendCodeDone = TRUE;
                NSNumber *codeNum = [jsonDic objectForKey:@"code"];
                _code = codeNum.stringValue;
                [self.phoneTextField setText:@""];
                [self.phoneTextField setPlaceholder:@"输入验证码"];
                [self.remarkLabel setText:@"验证码发送成功"];
                [self.sendButton setTitle:@"完成验证" forState:UIControlStateNormal];
                //        [self.sendButton setTintColor:AgreeBlue];
                [self.sendButton setTitleColor:AgreeBlue forState:UIControlStateNormal];
                [self.sendButton setEnabled:NO];
                [ProgressHUD showSuccess:@"验证码发送成功"];
            } else {
                [ProgressHUD dismiss];
            }
        }
            break;
        case kUpdateUserInfo: {
            //保存用户信息成功
            [ProgressHUD showSuccess:@"验证码认证成功"];
            UserSettingViewController *rootController = [self.navigationController.viewControllers objectAtIndex:1];
            [rootController reloadDataView];
            //绑定手机已完成,推出到主视图
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
            break;
        default:
            break;
    }
}

- (void)interfaceReturnDataError:(int)interfaceType {
    
}
- (IBAction)tapBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
