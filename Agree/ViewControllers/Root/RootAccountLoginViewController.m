//
//  RootAccountLoginViewController.m
//  Agree
//
//  Created by G4ddle on 15/4/5.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "RootAccountLoginViewController.h"
#import "RootAccountRegViewController.h"
#import "SRNet_Manager.h"
#import "MJExtension.h"
#import <SVProgressHUD.h>





#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]

@interface RootAccountLoginViewController () <SRNetManagerDelegate> {
    SRNet_Manager *_netManager;
    
}

@end

@implementation RootAccountLoginViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.doneButton.layer setCornerRadius:self.doneButton.frame.size.height/2];
    [self.doneButton setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    [self.doneButton.layer setMasksToBounds:YES];
    [self.doneButton setEnabled:NO];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)accountExitEdit:(id)sender {
    if (0 != self.accountTextField.text.length && 0 != self.passwordTextField.text.length) {
        [self.doneButton setEnabled:YES];
        [self.doneButton setBackgroundColor:AgreeBlue];
    }
}
- (IBAction)passwordExitEdit:(id)sender {
    if (0 != self.accountTextField.text.length && 0 != self.passwordTextField.text.length) {
        [self.doneButton setEnabled:YES];
        [self.doneButton setBackgroundColor:AgreeBlue];
    }
}

- (IBAction)tapDoneButton:(id)sender {
    
    if (!_netManager) {
        _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
    }
    Model_User *sendUser = [[Model_User alloc] init];
    [sendUser setPassword:self.passwordTextField.text];
    [sendUser setPk_user:[NSNumber numberWithInt:self.accountTextField.text.intValue]];
    
    [_netManager loginAccount:sendUser];
}

- (void)popToRootController {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
    UITabBarController *rootController = [sb instantiateViewControllerWithIdentifier:@"rootTabbar"];
    [self presentViewController:rootController animated:YES completion:nil];
}

- (void)interfaceReturnDataSuccess:(id)jsonDic with:(int)interfaceType {
    switch (interfaceType) {
        case kLoginAccount: {
            if (jsonDic) {
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                //找到帐号
                Model_User *user = [[Model_User objectArrayWithKeyValuesArray:jsonDic] objectAtIndex:0];
                [user saveToUserDefaults];
                
                [self popToRootController];
            } else {
                //没有找到帐号
                [SVProgressHUD dismiss];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                                message:@"帐号或者密码错误,请确认后再次输入"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
                [alert show];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)interfaceReturnDataError:(int)interfaceType {
    [SVProgressHUD showErrorWithStatus:@"网络错误"];
    
//    SVProgressHUD showProgress:<#(float)#> status:<#(NSString *)#> maskType:<#(SVProgressHUDMaskType)#>
}



//点击微信登录按钮
- (IBAction)tapWechatButton:(UIButton *)sender {
    
    NSLog(@"微信授权登陆");

    
}




#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.
    RootAccountRegViewController *childController = segue.destinationViewController;
    [childController setUserInfo:self.userInfo];
    [childController setRootController:self];
}


//键盘回收
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
}


@end
