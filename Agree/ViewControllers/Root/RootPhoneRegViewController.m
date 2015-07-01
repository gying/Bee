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
//#import "RootAccountLoginViewController.h"
//#import "RootAccountRegViewController.h"




#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]

@interface RootPhoneRegViewController ()<UINavigationControllerDelegate,UITextFieldDelegate,SRNetManagerDelegate>

{
    SRNet_Manager *_netManager;
    BOOL _sendCodeDone;
    NSString *_phoneNum;
    NSString *_code;
    
    RootAccountRegViewController * regViewController;
}
@end

@implementation RootPhoneRegViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
    [self.sendButton setAlpha:0.2];
    [self.sendButton setEnabled:NO];
//    regViewController = [RootAccountRegViewController new];

    
}
//发送验证码按钮
- (IBAction)sendButton:(id)sender {
    if (!_netManager) {
        _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
    }
    if (!_sendCodeDone) {
        _phoneNum = self.numberTextfield.text;
        [_netManager sendVerificationCode:self.numberTextfield.text];
    } else {
        //验证码确认
        if ([_code isEqualToString:self.self.numberTextfield.text]&&(self.sendButton.titleLabel.text = @"完成验证")) {
            //确认验证码完毕,保存到帐号信息
//            Model_User *sendUser = [[Model_User alloc] init];
//            [sendUser setPhone:_phoneNum];
//            [sendUser setPk_user:[Model_User loadFromUserDefaults].pk_user];
//            [_netManager updateUserInfo:sendUser];
            
                        [self showViewController:regViewController sender:nil];
            
//            [self.navigationController showViewController:self.regViewController sender:nil];
            
//            [self presentViewController:regViewController animated:YES completion:nil];
//            
            
            
            
            
            
        } else {
            [self.numberLable setText:@"验证码错误,请重新输入"];
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
                [self.numberTextfield setText:@""];
                [self.numberTextfield setPlaceholder:@"输入验证码"];
                [self.numberLable setText:@"验证码发送成功"];
                [self.sendButton setTitle:@"完成验证" forState:UIControlStateNormal];
                //        [self.sendButton setTintColor:AgreeBlue];
                [self.sendButton setTitleColor:AgreeBlue forState:UIControlStateNormal];
                [self.sendButton setEnabled:NO];
                [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
            } else {
                [SVProgressHUD dismiss];
            }
        }
            break;
        case kUpdateUserInfo: {
            //保存用户信息成功
            [SVProgressHUD showSuccessWithStatus:@"验证码认证成功"];
            

//            RootAccountLoginViewController *rootController = [self.navigationController.viewControllers objectAtIndex:1];
//            [rootController reloadDataView];
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
        } else {
            [self.sendButton setAlpha:0.2];
            [self.sendButton setEnabled:NO];
        }
    }
}


    

- (void)interfaceReturnDataError:(int)interfaceType {
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
