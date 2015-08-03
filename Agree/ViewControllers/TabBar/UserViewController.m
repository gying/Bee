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
#import "AppDelegate.h"
#import "EaseMob.h"
#import "SRImageManager.h"
#import "CD_Group.h"
#import "CD_Party.h"
#import "CD_Group_User.h"
#import "CD_Photo.h"

#import <SVProgressHUD.h>

@interface UserViewController () <UIAlertViewDelegate>{
    NSString *_imageName;
    UIImageView *_backImageViwe;
}

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    
    //头像区
    _backImageViwe = [[UIImageView alloc] initWithFrame:CGRectMake(4.5, 4.5, 90, 90)];
    
    [self.avatarButton addSubview:_backImageViwe];
    [_backImageViwe.layer setMasksToBounds:YES];
    [_backImageViwe.layer setCornerRadius:_backImageViwe.frame.size.width/2];
    [self resetAvatar];
    
    //BB号
    [self.accountLabel setText:[NSString stringWithFormat:@"BB号:  %@",[Model_User loadFromUserDefaults].pk_user.stringValue]];
}


- (void)resetAvatar {
    //下载图片

    [_backImageViwe sd_setImageWithURL:[SRImageManager avatarImageFromOSS:[Model_User loadFromUserDefaults].avatar_path]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 if (!error) {
                                     [_backImageViwe setImage:image];
                                 } else {
                                 
                                 }
                             }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedTheAccountSettingButton:(UIButton *)sender {
}

- (IBAction)pressedMyPartyButton:(UIButton *)sender {

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
    logoutAlert.tag = 1;
    [logoutAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == alertView.tag) {
        switch (buttonIndex) {
            case 0: {   //取消
                
            }
                break;
            case 1: {   //确定
                [SVProgressHUD showWithStatus:@"正在退出帐号"];
                //将用户资料清空
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDefUser];
                
                //退出环信
                EMError *error = nil;
                NSDictionary *info = [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:YES error:&error];
                if (!error && info) {
                    NSLog(@"退出帐号成功");
                }
                
                //移除用户资料
                [CD_Group removeAllGroupFromCD];
                [CD_Party removeAllPartyFromCD];
                [CD_Group_User removeAllGroupUserFromCD];
                [CD_Photo removeAllPhotoFromCD];
                
                //设置代理,弹出视图控制器
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [delegate logout];
                [SVProgressHUD showSuccessWithStatus:@"退出成功"];
            }
                break;
            default:
                break;
        }
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([@"GoToMyParty" isEqualToString:identifier]) {
        UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                              message:@"我的聚会还未开放,我们将会很快的在下个版本开放它."
                                                             delegate:self
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil];
        logoutAlert.tag = 2;
        [logoutAlert show];

        return NO;
    }
    return YES;
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
