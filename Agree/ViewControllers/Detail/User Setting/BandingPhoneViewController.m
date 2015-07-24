//
//  BandingPhoneViewController.m
//  Agree
//
//  Created by G4ddle on 15/3/15.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "BandingPhoneViewController.h"
#import "SRNet_Manager.h"
#import <SVProgressHUD.h>
#import "UserSettingViewController.h"

#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]

@interface BandingPhoneViewController (){
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
    if (!_sendCodeDone) {
        _phoneNum = self.phoneTextField.text;
        [SRNet_Manager requestNetWithDic:[SRNet_Manager sendVerificationCodeDic:self.phoneTextField.text]
                                complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
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
                                        [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
                                    } else {
                                        [SVProgressHUD dismiss];
                                    }
                                } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                    
                                }];
    } else {
        //验证码确认
        if ([_code isEqualToString:self.self.phoneTextField.text]) {
            //确认验证码完毕,保存到帐号信息
            Model_User *sendUser = [[Model_User alloc] init];
            [sendUser setPhone:_phoneNum];
            [sendUser setPk_user:[Model_User loadFromUserDefaults].pk_user];
            
            [SRNet_Manager requestNetWithDic:[SRNet_Manager updateUserInfoDic:sendUser]
                                    complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                        //保存用户信息成功
                                        [SVProgressHUD showSuccessWithStatus:@"验证码认证成功"];
                                        UserSettingViewController *rootController = [self.navigationController.viewControllers objectAtIndex:1];
                                        [rootController reloadDataView];
                                        //绑定手机已完成,推出到主视图
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self.navigationController popViewControllerAnimated:YES];
                                        });
                                    } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                        
                                    }];
            
        } else {
            [self.remarkLabel setText:@"验证码错误,请重新输入"];
        }
    }
}

- (IBAction)tapBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


//键盘回收
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.phoneTextField resignFirstResponder];
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
