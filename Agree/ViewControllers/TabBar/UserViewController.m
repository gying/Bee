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
#import "AppDelegate.h"
#import <SVProgressHUD.h>

#import "UserSettingTableViewCell.h"

@interface UserViewController () {
    UIImageView *_backImageViwe;
    
    UILabel * titleLabel;
    
    
    NSArray *_tableAry;
    
}

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableAry = @[@[@"姓名",@"性别",@"绑定手机",@"绑定微信"], @[@"绑定微信钱包",@"绑定支付宝"],@[@"反馈",@"关于必聚"],@[@"退出登录"]];

    //头像区
    _backImageViwe = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 72, 72)];
    
    [self.avatarButton addSubview:_backImageViwe];
    [_backImageViwe.layer setMasksToBounds:YES];
    [_backImageViwe.layer setCornerRadius:_backImageViwe.frame.size.width/2];
    [self resetAvatar];
}

- (void)viewWillAppear:(BOOL)animated {
    //设置当前视图控制器为根控制器
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.topRootViewController = self;
    [self.navigationController.tabBarItem setBadgeValue:nil];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.settingTableVIew dequeueReusableCellWithIdentifier:@"SETTINGCELL" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SETTINGCELL"];
    }
    NSArray *subAry = [_tableAry objectAtIndex:indexPath.section];
    cell.textLabel.text = [subAry objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_tableAry) {
        NSArray *subAry = [_tableAry objectAtIndex:section];
        return subAry.count;
    }
    return 0;
    
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return @"账户";
        }
            
            break;
        case 1: {
            return @"支付";
        }
            
            break;
        case 2: {
            return @"关于";
        }
            
            break;
        default:
            return @"其他";
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_tableAry) {
        return _tableAry.count;
    }
    return 1;
}



//被选中的CELL执行内容
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

   
    
    #pragma mark -- 注销登陆
    if ((3 == indexPath.section) && (0 == indexPath.row)) {
        
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
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    

}


@end
