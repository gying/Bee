//
//  RootPhoneRegViewController.m
//  Agree
//
//  Created by Agree on 15/6/30.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "RootPhoneRegViewController.h"
#import "SRNet_Manager.h"
#import <SVProgressHUD.h>
#import "MJExtension.h"
#import "SRImageManager.h"


#define kCountDownTime 31

#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]

@interface RootPhoneRegViewController ()<UINavigationControllerDelegate,UITextFieldDelegate, UIAlertViewDelegate> {
    BOOL _sendCodeDone;
    NSString *_phoneNum;
    NSString *_code;
    
    NSString *sendBtnTitle;
    
    RootAccountRegViewController * regViewController;
    
    BOOL _checkPhoneNumDone;
    int _waitTime;
    BOOL _isCodeDone;
    Model_User *_phoneAccount;
}
@end

@implementation RootPhoneRegViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.sendButton setAlpha:0.2];
    [self.sendButton setEnabled:NO];
    _waitTime = kCountDownTime;
    _checkPhoneNumDone = FALSE;


}

//倒计时
-(void)countdown{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(countdown) object:nil];
    
    [self.sendButton  setTitle:[NSString stringWithFormat:@"%d秒后重新发送验证码",--_waitTime] forState:UIControlStateNormal];
//    _waitTime--;
    if (0 == _waitTime) {
        
        if (_isCodeDone) {
            self.sendButton.enabled = YES;
            [self.sendButton setTitle:@"完成验证" forState:UIControlStateNormal];
            [self.sendButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
            _sendCodeDone = YES;
        } else {
            self.sendButton.enabled = YES;
            [self.sendButton setTitle:@"重新发送验证码" forState:UIControlStateNormal];
            [self.sendButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
            _sendCodeDone = NO;
        }
        
        return;
    }else {
        self.sendButton .enabled = NO;
        [self.sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self performSelector:@selector(countdown) withObject:nil afterDelay:1.0];
    }
    
}
//发送验证码按钮
- (IBAction)sendButton:(id)sender {
    if (!_sendCodeDone) {
        _waitTime = kCountDownTime;
        _phoneNum = self.numberTextfield.text;
        [SVProgressHUD showWithStatus:@"验证码码发送中..." maskType:SVProgressHUDMaskTypeGradient];
        
        [SRNet_Manager requestNetWithDic:[SRNet_Manager sendVerificationCodeDic:self.numberTextfield.text] complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
            if (jsonDic) {
                _sendCodeDone = TRUE;
                NSNumber *codeNum = [jsonDic objectForKey:@"code"];
                _code = codeNum.stringValue;
                [self.numberTextfield setText:@""];
                [self.numberTextfield setPlaceholder:@"输入验证码"];
                [self.numberLable setText:@"验证码发送成功"];
                [self.sendButton setTitle:@"完成验证" forState:UIControlStateNormal];
                [self.sendButton setTitleColor:AgreeBlue forState:UIControlStateNormal];
                [self.sendButton setEnabled:NO];
                
                [self countdown];
                [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
            } else {
                [SVProgressHUD dismiss];
            }
        } failure:^(NSError *error, NSURLSessionDataTask *task) {

        }];
      
        
    } else {
        //验证码确认
        if ([_code isEqualToString:self.self.numberTextfield.text]&&(self.sendButton.titleLabel.text = @"完成验证")) {
            [SVProgressHUD show];
            
            //确认验证码完毕,保存到帐号信息
            //验证码确认完毕.
            self.userInfo.phone = _phoneNum;
            
            if (self.regByWechat) {
                //从微信登录注册,先对手机号的唯一性进行判断
                Model_User *phoneAccount = [[Model_User alloc] init];
                phoneAccount.phone = _phoneNum;
                [SRNet_Manager requestNetWithDic:[SRNet_Manager getUserByPhoneDic:phoneAccount]
                                        complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                            if (jsonDic) {
                                                //查到用户
                                                _phoneAccount = [[Model_User objectArrayWithKeyValuesArray:(NSArray *)jsonDic] firstObject];
                                                
                                                //已经存在用户,则跳出提示,是否使用帐号进行登录
                                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                                    message:@"已经存在相关的手机帐号,是否使用已经存在的帐号进行登录?"
                                                                                                   delegate:self
                                                                                          cancelButtonTitle:@"取消"
                                                                                          otherButtonTitles:@"确定", nil];
                                                alertView.tag = 1;
                                                [alertView show];
                                                
                                                
                                            } else {
                                                //未查到用户,则直接开始注册完成流程
                                                [SVProgressHUD showWithStatus:@"帐号创建中..." maskType:SVProgressHUDMaskTypeGradient];
                                                //设置账户创建时间
                                                [self.userInfo setSetup_time:[NSDate date]];
                                                
                                                //保存头像信息
                                                [[SRImageManager initImageOSSData:self.avatarImage
                                                                          withKey:self.userInfo.avatar_path]
                                                 uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
                                                     if (isSuccess) {
                                                         //图片在保存完成之后开始保存默认的帐号信息
                                                         [SVProgressHUD showProgress:1.0 status:@"正在上传用户信息" maskType:SVProgressHUDMaskTypeGradient];
                                                         
                                                         [SRNet_Manager requestNetWithDic:[SRNet_Manager regUserDic:self.userInfo]
                                                                                 complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                                                                     if (jsonDic) {
                                                                                         //注册成功
                                                                                         //保存帐号信息
                                                                                         
                                                                                         if ([jsonDic isKindOfClass:[NSNumber class]]) {
                                                                                             self.userInfo.pk_user = (NSNumber *)jsonDic;
                                                                                         }
                                                                                         [self.userInfo saveToUserDefaults];
                                                                                         //                [self dismissViewControllerAnimated:YES completion:nil];
                                                                                         //                [self.rootController popToRootController];
                                                                                         UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
                                                                                         UITabBarController *rootController = [sb instantiateViewControllerWithIdentifier:@"rootTabbar"];
                                                                                         [self presentViewController:rootController animated:YES completion:nil];
                                                                                         [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                                                                                     } else {
                                                                                         //注册出现错误
                                                                                     }
                                                                                 } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                                                                     
                                                                                 }];
                                                         
                                                     } else {
                                                         NSLog(@"errorInfo_testDataDownloadWithProgress:%@", [error userInfo]);
                                                     }
                                                 } withProgressCallback:^(float progress) {
                                                     NSLog(@"current get %f", progress);
                                                     [SVProgressHUD showProgress:progress*0.9 status:@"正在上传头像图片" maskType:SVProgressHUDMaskTypeGradient];
                                                 }];
                                                
                                            }
                                        }
                                         failure:^(NSError *error, NSURLSessionDataTask *task) {
                                             
                                         }];
                phoneAccount = nil;
            } else {
                Model_User *phoneAccount = [[Model_User alloc] init];
                phoneAccount.phone = _phoneNum;
                [SRNet_Manager requestNetWithDic:[SRNet_Manager getUserByPhoneDic:phoneAccount]
                                        complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                            if (jsonDic) {
                                                //查到用户
                                                Model_User *loadAccount = [[Model_User objectArrayWithKeyValuesArray:(NSArray *)jsonDic] firstObject];
                                                [loadAccount saveToUserDefaults];
                                                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
                                                UITabBarController *rootController = [sb instantiateViewControllerWithIdentifier:@"rootTabbar"];
                                                [self presentViewController:rootController animated:YES completion:nil];
                                                [SVProgressHUD showSuccessWithStatus:@"查找到用户,正在进行登录" maskType:SVProgressHUDMaskTypeGradient];
                                            } else {
                                                //未查到用户
                                                _checkPhoneNumDone = YES;
                                                [self performSegueWithIdentifier:@"GoToReg" sender:self];
                                                [SVProgressHUD showSuccessWithStatus:@"未查找到用户,进入注册" maskType:SVProgressHUDMaskTypeGradient];
                                            }
                                        }
                                         failure:^(NSError *error, NSURLSessionDataTask *task) {
                                             
                                         }];
                phoneAccount = nil;
            }
        } else {
            [self.numberLable setText:@"验证码错误,请重新输入"];
        }
    }
}

//文本框控件
- (IBAction)phoneTextField:(UITextField *)sender {
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
            _isCodeDone = YES;
            _waitTime = 1;
        } else {
            [self.sendButton setAlpha:0.2];
            [self.sendButton setEnabled:NO];
        }
    }
}

//键盘回收
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.numberTextfield resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0: {
                    
                }
                    
                    break;
                    
                default: {
                    [_phoneAccount saveToUserDefaults];
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
                    UITabBarController *rootController = [sb instantiateViewControllerWithIdentifier:@"rootTabbar"];
                    [self presentViewController:rootController animated:YES completion:nil];
                    [SVProgressHUD showSuccessWithStatus:@"查找到用户,正在进行登录" maskType:SVProgressHUDMaskTypeGradient];
                }
                    break;
            }
            
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    //在推入视图前检查用户手机是否认证完毕
    return _checkPhoneNumDone;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([@"GoToReg" isEqualToString:segue.identifier]) {
        RootAccountRegViewController *childController = segue.destinationViewController;
        [childController setUserInfo:self.userInfo];
    }
}


@end
