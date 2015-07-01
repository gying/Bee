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

#import "AppDelegate.h"

@interface UserSettingViewController () <SRNetManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, SRImageManagerDelegate, UIAlertViewDelegate> {
    Model_User *_userInfo;
    SRNet_Manager *_netManager;
    UIImagePickerController *_imagePicker;
    
    UIImageView *_backImageViwe;
    SRImageManager *_imageManager;
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
    
    if (!_netManager) {
        _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
    }
    
    Model_User *defAccount = [Model_User loadFromUserDefaults];
    
    Model_User *account = [[Model_User alloc] init];
    account.pk_user = defAccount.pk_user;
    [_netManager getUserInfo:account];
    
    if (defAccount.avatar_path) {
        NSURL *imageUrl = [SRImageManager avatarImageFromTXYFieldID:defAccount.avatar_path];
        NSString * urlstr = [imageUrl absoluteString];
        
        [[TXYDownloader sharedInstanceWithPersistenceId:nil]download:urlstr target:_backImageViwe succBlock:^(NSString *url, NSData *data, NSDictionary *info) {
            [_backImageViwe setImage:[UIImage imageWithContentsOfFile:[info objectForKey:@"filePath"]]];
        } failBlock:nil progressBlock:nil param:nil];
        
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
    [_backImageViwe sd_setImageWithURL:[SRImageManager avatarImageFromTXYFieldID:[Model_User loadFromUserDefaults].avatar_path]];
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

- (void)imageBtnClick {
    //点击图片按钮
    
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        //判断是否有摄像头
        if(![UIImagePickerController isSourceTypeAvailable:sourceType]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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

- (void)imageUploadDoneWithFieldID:(NSString *)fieldID {
    //图片上传成功,开始更新用户数据
    Model_User *userInfo = [Model_User loadFromUserDefaults];
    userInfo.avatar_path = fieldID;
    [userInfo saveToUserDefaults];
    
    
    //更新根控制器的用户头像
    [self.rootViewController resetAvatar];
    
    //查看是否需要更新数据
    //更新用户数据
    _isUpdateData = TRUE;
    [_netManager updateUserInfo: _userInfo];
    _isUpdateAvatar = FALSE;
}

- (void)imageUpladError {
    
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

- (IBAction)pressedTheWechatButton:(UIButton *)sender {
    if (!_netManager) {
        _netManager = [[SRNet_Manager alloc] init];
        [_netManager setDelegate:self];
    }
    [_netManager testInterface];
    
    
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

-(void)imageUploading:(float)proFloat {
    [SVProgressHUD showProgress:proFloat*0.9];
}


- (void)saveAccountData {
    //上传头像信息
    if (_isUpdateAvatar) {
        //更新头像信息
        if (!_imageManager) {
            _imageManager = [[SRImageManager alloc] initWithDelegate:self];
        }
        //设置头像路径到系统头像路径
        [SVProgressHUD showProgress:1.0];
        [_imageManager updateImageToTXY:_avatarImage];
        [SVProgressHUD dismiss];
    } else {
        if (_isUpdateData) {
            //查看是否需要更新数据
            //更新用户数据
            [_netManager updateUserInfo: _userInfo];
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



- (void)interfaceReturnDataSuccess:(id)jsonDic with:(int)interfaceType {
    switch (interfaceType) {
        case kUpdateUserInfo: { //更新用户资料
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
        }
            break;
        case kGetUserInfo: {
            //读取用户资料
            NSArray *accountAry = [Model_User objectArrayWithKeyValuesArray:jsonDic];
            
            if (0 != accountAry.count) {
                _userInfo = [accountAry objectAtIndex:0];
                [self reloadDataView];
            } else {
                
            }
        }
            
            break;
            
        case kTestInterface: {    //读取用户资料

        }
            
            break;
        default:
            break;
    }
//    [SVProgressHUD dismiss];
}

- (void)interfaceReturnDataError:(int)interfaceType {
    [SVProgressHUD dismiss];
}

#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
