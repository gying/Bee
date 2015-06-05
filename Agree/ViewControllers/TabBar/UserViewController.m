//
//  UserViewController.m
//  Agree
//
//  Created by G4ddle on 15/2/14.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "UserViewController.h"
#import "UserSettingViewController.h"
#import "UIImageView+WebCache.h"
#import "SRTool.h"
#import "AppDelegate.h"
#import "EaseMob.h"

@interface UserViewController () <UIAlertViewDelegate>{
    NSString *_imageName;
    UIImageView *_backImageViwe;
}

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _backImageViwe = [[UIImageView alloc] initWithFrame:CGRectMake(4.5, 4.5, 90, 90)];
    
    [self.avatarButton addSubview:_backImageViwe];
    [_backImageViwe.layer setMasksToBounds:YES];
    [_backImageViwe.layer setCornerRadius:_backImageViwe.frame.size.width/2];
    
    [_backImageViwe setImageWithURL:[SRTool imageUrlFromPath:[Model_User loadFromUserDefaults].avatar_path]];
    [self.accountLabel setText:[NSString stringWithFormat:@"比聚号:  %@",[Model_User loadFromUserDefaults].pk_user.stringValue]];
}

- (void)resetAvatar {
    [_backImageViwe setImageWithURL:[SRTool imageUrlFromPath:[Model_User loadFromUserDefaults].avatar_path]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedTheAccountSettingButton:(UIButton *)sender {
}
- (IBAction)pressedTheFeedbackButton:(UIButton *)sender {
}
- (IBAction)pressedTheAboutUsButton:(UIButton *)sender {
}

- (IBAction)tapLogoutButton:(id)sender {
    UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"警告"
                                                          message:@"确定要登出帐号,您在手机中的帐号信息将会被清空"
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确定", nil];
    [logoutAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0: {   //取消
            
        }
            break;
        case 1: {   //确定
            //将用户资料清空
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDefUser];
            
            //退出环信
            EMError *error = nil;
            NSDictionary *info = [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:YES error:&error];
            if (!error && info) {
                NSLog(@"退出成功");
            }
            
            //设置代理,弹出视图控制器
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate logout];

        }
            break;
        default:
            break;
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"AccountDetailFromAvatar"] || [segue.identifier isEqualToString:@"AccountDetailFromButtom"]) {
        UserSettingViewController *childController = segue.destinationViewController;
        childController.rootViewController = self;
    }
}


@end