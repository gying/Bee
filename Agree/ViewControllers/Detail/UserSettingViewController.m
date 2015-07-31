//
//  UserSettingViewController.m
//  Agree
//
//  Created by G4ddle on 15/2/7.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "UserSettingViewController.h"
#import "Model_User.h"
#import "SRNet_Manager.h"
#import <SVProgressHUD.h>
#import "MJExtension.h"

#import "UIImageView+WebCache.h"
#import "SRImageManager.h"



@interface UserSettingViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, UIAlertViewDelegate> {
    Model_User *_userInfo;
    UIImagePickerController *_imagePicker;
    
    UIImageView *_backImageViwe;
    UIImage *_avatarImage;
    
    NSString *_password;
    
    BOOL _isUpdateAvatar;
    BOOL _isQuit;
    BOOL _isUpdateData;
    
    
}

@end

@implementation UserSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _backImageViwe = [[UIImageView alloc] initWithFrame:CGRectMake(4.5, 4.5, 90, 90)];
    [_backImageViwe.layer setMasksToBounds:YES];
    [_backImageViwe.layer setCornerRadius:_backImageViwe.frame.size.width/2];
    [self.avatarButton addSubview:_backImageViwe];

    Model_User *defAccount = [Model_User loadFromUserDefaults];
    
    Model_User *account = [[Model_User alloc] init];
    account.pk_user = defAccount.pk_user;
    
    [SRNet_Manager requestNetWithDic:[SRNet_Manager getUserInfoDic:account]
                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                //读取用户资料
                                NSArray *accountAry = [Model_User objectArrayWithKeyValuesArray:jsonDic];
                                
                                if (0 != accountAry.count) {
                                    _userInfo = [accountAry objectAtIndex:0];
                                    [self reloadDataView];
                                }
                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                
                            }];
    
    if (defAccount.avatar_path) {
        [_backImageViwe sd_setImageWithURL:[SRImageManager avatarImageFromOSS:defAccount.avatar_path]];
    }
    
    if (defAccount.password) {
        [self.passwordButton setTitle:@"更改密码" forState:UIControlStateNormal];
    }
    
    if (defAccount.wechat_id && [@"" isEqual:defAccount.wechat_id]) {
        [self.weChatButton setTitle:@"重新绑定微信帐号" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadDataView {
    [_backImageViwe sd_setImageWithURL:[SRImageManager avatarImageFromOSS:[Model_User loadFromUserDefaults].avatar_path]];
    self.nicknameTextField.text = _userInfo.nickname;
    
    if (_userInfo.phone) {
        [self.phoneButton setTitle:_userInfo.phone forState:UIControlStateNormal];
    }
    
    switch (_userInfo.sex.intValue) {
        case 0: {
            [self.sexButton setTitle:@"性别" forState:UIControlStateNormal];
        }
            break;
        case 1: {
            [self.sexButton setTitle:@"男" forState:UIControlStateNormal];
        }
            break;
        case 2: {
            [self.sexButton setTitle:@"女" forState:UIControlStateNormal];
        }
            break;
        case 3: {
            [self.sexButton setTitle:@"人妖" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (IBAction)pressedTheAvatarButton:(id)sender {
    [self imageBtnClick];
}

- (IBAction)tapPasswordBackButton:(id)sender {
    [self.passwordTextField resignFirstResponder];
    self.passwordView.hidden = YES;
}

- (IBAction)passwordEditEnd:(id)sender {
    
//    if ([self.passwordTextField.text isEqual:_userInfo.password])
//        
    
    {
        if (!_password) {
            _password = self.passwordTextField.text;
            self.passwordTextField.text = nil;
            self.passwordRemarkLabel.text = @"为了确保正确,请再次输入密码";
            [self.passwordTextField becomeFirstResponder];
        } else {
            
            if ([_password isEqual:self.passwordTextField.text]) {
                _userInfo.password = _password;
                _password = nil;
                //设置密码完成
                [self.passwordTextField resignFirstResponder];
                [self.passwordRemarkLabel setText:@"请输入想要设置的密码"];
                [self.passwordView setHidden:YES];
                _isUpdateData = YES;
                self.passwordTextField.text = nil;
            } else {
                //两次密码输入不一样
                _password = nil;
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"您输入的两次密码并不相同,请重新进行输入."
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                self.passwordRemarkLabel.text = @"请输入想要设置的密码";
                [alertView show];
                [self.passwordTextField becomeFirstResponder];
                self.passwordTextField.text = nil;
            }
        }

    }

}
- (void)imageBtnClick {
    //点击图片按钮
    
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //判断是否有摄像头
        if(![UIImagePickerController isSourceTypeAvailable:_imagePicker.sourceType]) {
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"图片库", nil];
        [sheet showInView:self.view];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (2 == actionSheet.tag) {
        //退出界面选择
        if (0 == buttonIndex) {
            //保存退出
            _isQuit = TRUE;
            [self saveAccountData];
        } else if (1 == buttonIndex) {
            //直接退出
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            return;
        }
    } else {
        UIImagePickerControllerSourceType sourceType;
        if (0 == buttonIndex) {
            //直接拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
        } else if (1 == buttonIndex) {
            //使用相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } else {
            return;
        }
        _imagePicker.sourceType = sourceType;
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:Nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:Nil];
    _isUpdateAvatar = TRUE;
    //对原始图片进行裁剪,并保存到用户头像信息
    _avatarImage = [SRImageManager getSubImage:[info valueForKey:@"UIImagePickerControllerOriginalImage"]
                                              withRect:CGRectMake(0, 0, 180, 180)];
    [_backImageViwe setImage:_avatarImage];
}


- (IBAction)pressedThePasswordButton:(UIButton *)sender {
    self.passwordView.hidden = NO;
    [self.passwordTextField becomeFirstResponder];
}


- (IBAction)pressedTheSexButton:(UIButton *)sender {
    _isUpdateData = TRUE;
    if ([sender.titleLabel.text isEqual:@"性别"] ) {
        [sender setTitle:@"男" forState:UIControlStateNormal];
        _userInfo.sex = @1;
    } else if ([sender.titleLabel.text isEqual:@"男"]) {
        [sender setTitle:@"女" forState:UIControlStateNormal];
        _userInfo.sex = @2;
    } else if ([sender.titleLabel.text isEqual:@"女"]) {
        [sender setTitle:@"人妖" forState:UIControlStateNormal];
        _userInfo.sex = @3;
    } else {
        [sender setTitle:@"性别" forState:UIControlStateNormal];
        _userInfo.sex = @0;
    }
}

- (IBAction)pressedThePhoneButton:(UIButton *)sender {
    
}



//绑定微信按钮
- (IBAction)pressedTheWechatButton:(UIButton *)sender {
    NSLog(@"绑定微信");
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
    // @"post_timeline,sns"
    req.state = @"xxxtiaozhuan";
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
    
    if (openid) {
        _userInfo.wechat_id = openid;
        _isUpdateData = YES;
    }
}

- (IBAction)nicknameEditingChanged:(UITextField *)sender {
    if (sender.text.length < 2) {
        
    } else {
        _isUpdateData = TRUE;
        _userInfo.nickname = sender.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (textField.text.length < 2) {
        [textField setText:_userInfo.nickname];
    } else {
        _isUpdateData = TRUE;
        _userInfo.nickname = textField.text;
    }
    return TRUE;
}

- (void)saveAccountData {
    //上传头像信息
    if (_isUpdateAvatar) {
        //更新头像信息
        [SVProgressHUD showProgress:1.0];
        
        _userInfo.avatar_path = [NSUUID UUID].UUIDString;
        
        [[SRImageManager initImageOSSData:_avatarImage
                                  withKey:_userInfo.avatar_path] uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
            if (isSuccess) {
                //图片上传成功,开始更新用户数据
                Model_User *userInfo = [Model_User loadFromUserDefaults];
                userInfo.avatar_path = _userInfo.avatar_path;
                [userInfo saveToUserDefaults];
                
                
                //更新根控制器的用户头像
                [self.rootViewController resetAvatar];
                
                //查看是否需要更新数据
                //更新用户数据
                _isUpdateData = TRUE;
                [SRNet_Manager requestNetWithDic:[SRNet_Manager updateUserInfoDic:_userInfo]
                                        complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                            //更新用户资料
                                            _isUpdateData = FALSE;
                                            
                                            Model_User *userInfo = [Model_User loadFromUserDefaults];
                                            //更新用户昵称
                                            userInfo.nickname = self.nicknameTextField.text;
                                            [userInfo saveToUserDefaults];
                                            
                                            if (_isQuit) {
                                                //是否退出
                                                [self.navigationController popViewControllerAnimated:YES];
                                            } else {
                                                _isUpdateData = FALSE;
                                            }
                                        } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                            
                                        }];
                _isUpdateAvatar = FALSE;
            } else {
                //图片上传失败
            }
            
        } withProgressCallback:^(float progress) {
            [SVProgressHUD showProgress:progress*0.9];
        }];

        [SVProgressHUD dismiss];
    } else {
        if (_isUpdateData) {
            //查看是否需要更新数据
            //更新用户数据
            [SRNet_Manager requestNetWithDic:[SRNet_Manager updateUserInfoDic:_userInfo]
                                    complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                        //更新用户资料
                                        _isUpdateData = FALSE;
                                        
                                        Model_User *userInfo = [Model_User loadFromUserDefaults];
                                        //更新用户昵称
                                        userInfo.nickname = self.nicknameTextField.text;
                                        [userInfo saveToUserDefaults];
                                        
                                        if (_isQuit) {
                                            //是否退出
                                            [self.navigationController popViewControllerAnimated:YES];
                                        } else {
                                            _isUpdateData = FALSE;
                                        }
                                    } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                        
                                    }];
        }
    }
}


- (IBAction)pressedTheSaveButton:(UIButton *)sender {
    _isQuit = FALSE;
    [self.nicknameTextField resignFirstResponder];
    [self saveAccountData];
}

- (IBAction)pressedTheBackButton:(id)sender {
    if (_isUpdateData || _isUpdateAvatar) {
        //资料已更改
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"用户资料已更改" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存退出" otherButtonTitles:@"不保存退出", nil];
        sheet.tag = 2;
        [sheet showInView:self.view];
    } else {
        //资料未更改
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {   //取消
            
        }
            break;
        case 1: {   //确定
            [self performSegueWithIdentifier:@"BandPhone" sender:self];
        }
            break;
        default:
            break;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([@"BandPhone" isEqual:identifier]) {
        if (_userInfo.phone) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"您已经绑定了手机号码,是否重新绑定另一个号码?"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
            [alertView show];
            return NO;
        }
        return YES;
    }
    return YES;
}

#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
