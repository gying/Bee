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
#import "SRTool.h"

#import <SVProgressHUD.h>

@interface UserViewController () {
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
    //[self.accountLabel setText:[NSString stringWithFormat:@"BB号:  %@",[Model_User loadFromUserDefaults].pk_user.stringValue]];
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
    [SVProgressHUD show];
}

- (IBAction)pressedMyPartyButton:(UIButton *)sender {

}

- (IBAction)pressedTheFeedbackButton:(UIButton *)sender {
}

- (IBAction)pressedTheAboutUsButton:(UIButton *)sender {
}

- (IBAction)tapLogoutButton:(id)sender {
    [SRTool showSRAlertViewWithTitle:@"警告" message:@"确定要登出帐号吗?\n保存的资料将会被清空哦~"
                   cancelButtonTitle:@"我再想想" otherButtonTitle:@"是的"
               tapCancelButtonHandle:^(NSString *msgString) {
                   
               } tapOtherButtonHandle:^(NSString *msgString) {
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
               }];
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
