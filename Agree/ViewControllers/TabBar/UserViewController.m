//
//  UserViewController.m
//  Agree
//
//  Created by G4ddle on 15/2/14.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "UserViewController.h"
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
#import "UserSettingDetailTableViewController.h"
#import "MJExtension.h"

@interface UserViewController () {
    UIImageView *_backImageViwe;
    
    UILabel * titleLabel;
    
    NSArray *_tableAry;

    NSIndexPath *_selectedIndex;
    
    Model_User *_wechatUser;
    BOOL _wechatLoginDone;
    
    Model_User *_userInfo;
        NSString *_openid;
    
        BOOL _isUpdateData;
    
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
    
    self.nameLabel.text = [Model_User loadFromUserDefaults].nickname;
    
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


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = indexPath;
    return indexPath;
}


//被选中的CELL执行内容
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if((3 == indexPath.section) && (0 == indexPath.row)) {
        
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    switch (_selectedIndex.section) {
        case 0: {

            switch (_selectedIndex.row) {
                case 3: {
                    NSLog(@"绑定微信");
                    
                    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    delegate.wechatViewController = self;
                    
                    
                    NSLog(@"微信授权登陆");
                    /*! @brief 第三方程序向微信终端请求认证的消息结构
                     *
                     * 第三方程序要向微信申请认证，并请求某些权限，需要调用WXApi的sendReq成员函数，
                     * 向微信终端发送一个SendAuthReq消息结构。微信终端处理完后会向第三方程序发送一个处理结果。
                     * @see SendAuthResp
                     */
                    SendAuthReq * req = [[SendAuthReq alloc]init];
                    /** 第三方程序要向微信申请认证，并请求某些权限，需要调用WXApi的sendReq成员函数，向微信终端发送一个SendAuthReq消息结构。微信终端处理完后会向第三方程序发送一个处理结果。
                     * @see SendAuthResp
                     * @note scope字符串长度不能超过1K
                     */
                    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
                    /** 第三方程序本身用来标识其请求的唯一性，最后跳转回第三方程序时，由微信终端回传。
                     * @note state字符串长度不能超过1K
                     */
                    req.state = @"xxxx";
                    /** 由用户微信号和AppID组成的唯一标识，发送请求时第三方程序必须填写，用于校验微信用户是否换号登录*/
                    req.openID = @"0c806938e2413ce73eef92cc3";
                    [WXApi sendAuthReq:req viewController:self delegate:self];
                    return NO;
                }
                    
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 2: {
            switch (_selectedIndex.row) {
                case 1:{
                    if ([identifier isEqualToString:@"GoToAboutUs"]) {
                        return YES;
                    } else {
                        [self performSegueWithIdentifier:@"GoToAboutUs" sender:self];
                        return NO;
                    }
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
        case 3: {
            switch (_selectedIndex.row) {
                case 0:
                    return NO;
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
        
        }
            break;
            
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    switch (_selectedIndex.section) {
        case 0:
            switch (_selectedIndex.row) {
                case 0:{
                    NSLog(@"姓名");
                    
                    UserSettingDetailTableViewController *childController = segue.destinationViewController;
                    childController.inputType = kNickName;
                }
                    
                    break;
                case 1:{
                    NSLog(@"性别");
                    
                    UserSettingDetailTableViewController *childController = segue.destinationViewController;
                    childController.inputType = kChooseSex;
                }
                    break;
                case 2:{
                    NSLog(@"绑定手机");
                    
                    UserSettingDetailTableViewController *childController = segue.destinationViewController;
                    childController.inputType = kBandPhone;
                }
                    break;
                case 3:{
                    NSLog(@"绑定微信");
                    
                    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    delegate.wechatViewController = self;
                    
                    
                    NSLog(@"微信授权登陆");
                    /*! @brief 第三方程序向微信终端请求认证的消息结构
                     *
                     * 第三方程序要向微信申请认证，并请求某些权限，需要调用WXApi的sendReq成员函数，
                     * 向微信终端发送一个SendAuthReq消息结构。微信终端处理完后会向第三方程序发送一个处理结果。
                     * @see SendAuthResp
                     */
                    SendAuthReq * req = [[SendAuthReq alloc]init];
                    /** 第三方程序要向微信申请认证，并请求某些权限，需要调用WXApi的sendReq成员函数，向微信终端发送一个SendAuthReq消息结构。微信终端处理完后会向第三方程序发送一个处理结果。
                     * @see SendAuthResp
                     * @note scope字符串长度不能超过1K
                     */
                    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
                    /** 第三方程序本身用来标识其请求的唯一性，最后跳转回第三方程序时，由微信终端回传。
                     * @note state字符串长度不能超过1K
                     */
                    req.state = @"xxxx";
                    /** 由用户微信号和AppID组成的唯一标识，发送请求时第三方程序必须填写，用于校验微信用户是否换号登录*/
                    req.openID = @"0c806938e2413ce73eef92cc3";
                    
                    
                    /*! @brief 发送Auth请求到微信，支持用户没安装微信，等待微信返回onResp
                     *
                     * 函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。支持SendAuthReq类型。
                     * @param req 具体的发送请求，在调用函数后，请自己释放。
                     * @param viewController 当前界面对象。
                     * @param delegate  WXApiDelegate对象，用来接收微信触发的消息。
                     * @return 成功返回YES，失败返回NO。
                     */
                    [WXApi sendAuthReq:req viewController:self delegate:self];
                    
                    

                    
                }
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:
            switch (_selectedIndex.row) {
                case 0:{
                    NSLog(@"绑定微信钱包");
                    
                }
                    break;
                case 1:{
                    NSLog(@"绑定支付宝");
                    
                }
                    break;
                    
                default:
                    break;
            }
            break;
        case 2:
            switch (_selectedIndex.row) {
                case 0:{
                    NSLog(@"反馈");
                    UserSettingDetailTableViewController *childController = segue.destinationViewController;
                    childController.inputType = kFeedback;
                }
                    break;
                case 1:{
                    NSLog(@"关于必聚");
                    
                }
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }

}


#pragma mark -- 和微信终端交互，因此需要实现WXApiDelegate协议的两个方法
//-(void) onReq:(BaseReq*)req{
//    //onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
//
//    //发送消息到客户端执行的方法
//    NSLog(@"发送消息到客户端！！！！！！！！！！！！！！！！！！！！！");
//
//    if([req isKindOfClass:[GetMessageFromWXReq class]])
//    {
//        GetMessageFromWXReq *temp = (GetMessageFromWXReq *)req;
//
//        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
//        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
//        NSString *strMsg = [NSString stringWithFormat:@"openID: %@", temp.openID];
//
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        alert.tag = 1000;
//        [alert show];
//
//    }
//    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
//    {
//        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
//        WXMediaMessage *msg = temp.message;
//
//        //显示微信传过来的内容
//        WXAppExtendObject *obj = msg.mediaObject;
//
//        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
//        NSString *strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n附加消息:%@\n", temp.openID, msg.title, msg.description, obj.extInfo, msg.thumbData.length, msg.messageExt];
//
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//
//    }
//    else if([req isKindOfClass:[LaunchFromWXReq class]])
//    {
//        LaunchFromWXReq *temp = (LaunchFromWXReq *)req;
//        WXMediaMessage *msg = temp.message;
//
//        //从微信启动App
//        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
//        NSString *strMsg = [NSString stringWithFormat:@"openID: %@, messageExt:%@", temp.openID, msg.messageExt];
//
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//
//    }
//}

-(void) onResp:(BaseResp*)resp{
    //如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
    //从微信客户端返回第三方客户端的执行方法
    NSLog(@"从客户端返回第三方客户端的执行方法！！！！！！！！！！！！！！！！！！");
    //    SendAuthResp *temp = (SendAuthResp*)resp;
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *temp = (SendAuthResp*)resp;
        _codeStr = temp.code;
    }
    else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]])
    {
    }
    
    
    //access_token等内容的请求地址
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString * urlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=wx9be30a70fcb480ae&secret=5afb616b4c62f245508643e078735bfb&code=%@&grant_type=authorization_code",_codeStr];
    //code字符串
    NSLog(@"%@",_codeStr);
    NSString * newUrlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:newUrlStr];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //access_token等内容的数组
    NSDictionary * urlDataDic = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:nil];
    NSLog(@"%@",urlDataDic);
    //获取access_token
    NSString * tokenStr = [urlDataDic objectForKey:@"access_token"];
    //    NSLog(@"%@",tokenStr);
    //获取openid
    NSString * openid = [urlDataDic objectForKey:@"openid"];
    //    NSLog(@"%@",openid);
    
    //TOKEN请求个人信息地址（只需要上述的access_token以及openid即可)
    //https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    NSString * uidStr = [NSString stringWithFormat:@"https:api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",tokenStr,openid];
    
    NSString * newUidStr = [uidStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL * uidUrl = [NSURL URLWithString:newUidStr];
    
    NSURLRequest * uidRequest = [NSURLRequest requestWithURL:uidUrl];
    
    NSURLResponse *uidResponse = nil;
    
    NSError *uidError = nil;
    
    NSData *uidData = [NSURLConnection sendSynchronousRequest:uidRequest returningResponse:&uidResponse error:&uidError];
    //    NSLog(@"%@",uidData);
    //unionid字典内容(获取个人信息)
    NSDictionary * uidDataDic = [NSJSONSerialization JSONObjectWithData:uidData options:kNilOptions error:nil];
    NSLog(@"%@",uidDataDic);
    
    //新建由微信创建的用户信息
    _wechatUser = [[Model_User alloc] init];
    _wechatUser.wechat_id = [uidDataDic objectForKey:@"openid"];
    _wechatUser.nickname = [uidDataDic objectForKey:@"nickname"];
    _wechatUser.avatar_path = [uidDataDic objectForKey:@"headimgurl"];
    
    
    if (openid) {
        [SRNet_Manager requestNetWithDic:[SRNet_Manager getUserInfoByWechatDic:_wechatUser]
                                complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                    if (jsonDic) {
                                        //使用微信openid的账户存在
                                        _openid = openid;
                                        [SRTool showSRAlertViewWithTitle:@"提示" message:@"该微信已经绑定了其他帐号\n是否解绑来绑定到这个帐号呢?"
                                                       cancelButtonTitle:@"我再想想"
                                                        otherButtonTitle:@"是的"
                                                   tapCancelButtonHandle:^(NSString *msgString) {
                                                       
                                                   } tapOtherButtonHandle:^(NSString *msgString) {
                                                       _userInfo.wechat_id = _openid;
                                                       _isUpdateData = YES;
//                                                       [self popToRootController];
                                                   }];
                                        
                                    } else {
                                        //使用微信openid的账户不存在
                                        _userInfo.wechat_id = openid;
                                        _isUpdateData = YES;
                                        
                                    }
                                } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                    
                                }];
    }
}


- (void)popToRootController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
    UITabBarController *rootController = [sb instantiateViewControllerWithIdentifier:@"rootTabbar"];
    [self presentViewController:rootController animated:YES completion:nil];
}



@end
