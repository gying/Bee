//
//  RootAccountLoginViewController.m
//  Agree
//
//  Created by G4ddle on 15/4/5.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "RootAccountLoginViewController.h"
#import "RootAccountRegViewController.h"
#import "RootPhoneRegViewController.h"
#import "SRNet_Manager.h"
#import "MJExtension.h"
#import <SVProgressHUD.h>



#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]

@interface RootAccountLoginViewController () <SRNetManagerDelegate, UIAlertViewDelegate> {
    SRNet_Manager *_netManager;
    Model_User *_wechatUser;
    BOOL _wechatLoginDone;
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

- (void)viewWillAppear:(BOOL)animated {
    
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
        case kGetUserInfoByWechat: {
            if (jsonDic) {
                [super viewDidLoad];
                //使用微信openid的账户存在
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                //找到帐号
                Model_User *user = [[Model_User objectArrayWithKeyValuesArray:jsonDic] objectAtIndex:0];
                [user saveToUserDefaults];
                [self popToRootController];
                
            } else {
                //使用微信openid的账户不存在
                [self performSegueWithIdentifier:@"GoToReg" sender:self];
            }
        }
        default:
            break;
    }
}


- (void)interfaceReturnDataError:(int)interfaceType {
    [SVProgressHUD showErrorWithStatus:@"网络错误"];
}



//点击微信登录按钮
- (IBAction)tapWechatButton:(UIButton *)sender {
    
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


#pragma mark -- 和微信终端交互，因此需要实现WXApiDelegate协议的两个方法
-(void) onReq:(BaseReq*)req{
    //onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
    
    //发送消息到客户端执行的方法
    NSLog(@"发送消息到客户端！！！！！！！！！！！！！！！！！！！！！");
    
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
//        GetMessageFromWXReq *temp = (GetMessageFromWXReq *)req;
//        
//        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
//        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
//        NSString *strMsg = [NSString stringWithFormat:@"openID: %@", temp.openID];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        alert.tag = 1000;
//        [alert show];

    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
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

    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
//        LaunchFromWXReq *temp = (LaunchFromWXReq *)req;
//        WXMediaMessage *msg = temp.message;
//        
//        //从微信启动App
//        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
//        NSString *strMsg = [NSString stringWithFormat:@"openID: %@, messageExt:%@", temp.openID, msg.messageExt];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];

    }
}

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
        if (!_netManager) {
            _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
        }
        [_netManager getUserInfoByWechat:_wechatUser];
    }
}


//键盘回收
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([@"GoToBandPhone" isEqualToString:segue.identifier]) {
        //登录或者注册手机帐号
        RootPhoneRegViewController *childController = segue.destinationViewController;
        childController.userInfo = self.userInfo;
        childController.rootController = self;
    } else {
        //微信登录注册逻辑
        RootAccountRegViewController *childController = segue.destinationViewController;
        if (_wechatUser) {
            [childController setUserInfo:_wechatUser];
        } else {
            [childController setUserInfo:self.userInfo];
        }
        [childController setRootController:self];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self popToRootController];
}


@end
