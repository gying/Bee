//
//  RootAccountRegViewController.m
//  Agree
//
//  Created by G4ddle on 15/3/1.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "RootAccountRegViewController.h"
#import "SRImageManager.h"
#import "SRNet_Manager.h"
#import <SVProgressHUD.h>
#import "APService.h"
#import "AppDelegate.h"
#import "EaseMob.h"

#import "UIImageView+WebCache.h"
#import "RootPhoneRegViewController.h"
#import "SRTool.h"


#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]

@interface RootAccountRegViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
{
    UIImagePickerController *_imagePicker;
    UIImageView *_backImageViwe;
    UIImage *_avatarImage;
}

@end

@implementation RootAccountRegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.nicknameTextField setDelegate:self];

    [self.doneButton.layer setCornerRadius:self.doneButton.frame.size.height/2];
    [self.doneButton setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
    [self.doneButton.layer setMasksToBounds:YES];
    
    _backImageViwe = [[UIImageView alloc] initWithFrame:CGRectMake(4.5, 4.5, 90, 90)];
    [_backImageViwe.layer setMasksToBounds:YES];
    [_backImageViwe setBackgroundColor:[UIColor whiteColor]];
    [_backImageViwe.layer setCornerRadius:_backImageViwe.frame.size.width/2];
    [self.avatarButton addSubview:_backImageViwe];
    
    if (self.userInfo.wechat_id) {
        [self.nicknameTextField setText:self.userInfo.nickname];
        if (self.userInfo.nickname) {
            [self.doneButton setBackgroundColor:AgreeBlue];
        }
        [_backImageViwe sd_setImageWithURL:[NSURL URLWithString: self.userInfo.avatar_path] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _avatarImage = [SRImageManager getSubImage:image
                                              withRect:CGRectMake(0, 0, 360, 360)];
            [_backImageViwe setImage:_avatarImage];
        }];
    }
}

- (void)imageBtnClick {
    //点击图片按钮
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [SRTool showSRSheetInView:self.view withTitle:@"选择图片来源" message:nil
                  withButtonArray:@[@"拍照", @"相册"]
                  tapButtonHandle:^(int buttonIndex) {
                      UIImagePickerControllerSourceType sourceType;
                      switch (buttonIndex) {
                          case 0: {
                              //拍照
                              sourceType = UIImagePickerControllerSourceTypeCamera;
                          }
                              break;
                          case 1: {
                              //相册
                              sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                          }
                              break;
                          default:
                              break;
                      }
                      _imagePicker.sourceType = sourceType;
                      [self presentViewController:_imagePicker animated:YES completion:nil];
                  } tapCancelHandle:^{
                      
                  }];
    } else {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }
}

- (IBAction)pressedTheAvatarButton:(id)sender {
    [self imageBtnClick];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //对原始图片进行裁剪,并保存到用户头像信息
    _avatarImage = [SRImageManager getSubImage:[info valueForKey:@"UIImagePickerControllerOriginalImage"]
                                              withRect:CGRectMake(0, 0, 360, 360)];
    [_backImageViwe setImage:_avatarImage];
    
    if (true) {
        [self.doneButton setBackgroundColor:AgreeBlue];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (2 <= textField.text.length) {
        self.userInfo.nickname = textField.text;
        //昵称输入完成
        [textField resignFirstResponder];
    } else {
        [SRTool showSRAlertOnlyTipWithTitle:@"提示" message:@"输入的昵称不能少于两个字符哦~"];
    }
    return YES;
}


- (IBAction)nicknameValueChange:(UITextField *)sender {
    if (2 < sender.text.length) {
    }
}

- (IBAction)pressedTheDoneButton:(id)sender {
    

        BOOL isDone = NO;
        if (self.nicknameTextField.text) {
            //昵称为空
            
            if (_avatarImage) {
                isDone = YES;
            } else {
                [SRTool showSRAlertOnlyTipWithTitle:@"提示" message:@"头像不能为空哦~"];
            }
            
        } else {
            [SRTool showSRAlertOnlyTipWithTitle:@"提示" message:@"昵称可不能是空的~"];
            self.userInfo.nickname = self.nicknameTextField.text;
        }
    //从程序代理获取推送信息以及设备号以便于注册
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.userInfo.avatar_path = [NSUUID UUID].UUIDString;
    self.userInfo.jpush_id = delegate.jPushString;
    self.userInfo.device_id = delegate.deviceToken;
    self.userInfo.nickname = self.nicknameTextField.text;
    
        if (isDone) {
            if (self.userInfo.phone) {
                [SVProgressHUD showWithStatus:@"帐号创建中..." maskType:SVProgressHUDMaskTypeGradient];
                //设置账户创建时间
                [self.userInfo setSetup_time:[NSDate date]];
                
                //保存头像信息
                [[SRImageManager initImageOSSData:_avatarImage
                                          withKey:self.userInfo.avatar_path]
                 uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
                     if (isSuccess) {
                         NSLog(@"there is no error");
                         
                         //图片在保存完成之后开始保存默认的帐号信息
                         [SVProgressHUD showProgress:1.0 status:@"正在上传用户信息" maskType:SVProgressHUDMaskTypeGradient];

                         
                         [SRNet_Manager requestNetWithDic:[SRNet_Manager regUserDic:self.userInfo]
                                                 complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                                     if (jsonDic) {
                                                         //注册成功
                                                         //保存帐号信息
                                                         
                                                         if ([jsonDic isKindOfClass:[NSNumber class]]) {
                                                             self.userInfo.pk_user = (NSNumber *)jsonDic;
                                                         }
                                                         [self.userInfo saveToUserDefaults];
                                                         //                [self dismissViewControllerAnimated:YES completion:nil];
                                                         //                [self.rootController popToRootController];
                                                         UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
                                                         UITabBarController *rootController = [sb instantiateViewControllerWithIdentifier:@"rootTabbar"];
                                                         [self presentViewController:rootController animated:YES completion:nil];
                                                         [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                                                     } else {
                                                         //注册出现错误
                                                     }
                                                 } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                                     
                                                 }];
                         
                     } else {
                         NSLog(@"errorInfo_testDataDownloadWithProgress:%@", [error userInfo]);
                     }
                 } withProgressCallback:^(float progress) {
                     NSLog(@"current get %f", progress);
                     [SVProgressHUD showProgress:progress*0.9 status:@"正在上传头像图片" maskType:SVProgressHUDMaskTypeGradient];
                 }];
            }else {
                [self performSegueWithIdentifier:@"GoPhoneWithWechatDone" sender:self];
            }
        }
}

- (IBAction)tapCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//键盘回收
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nicknameTextField resignFirstResponder];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqual:@"GoPhoneWithWechatDone"]) {
        //微信登录成功,并已经输入了头像昵称,进入手机认证页面
        
        RootPhoneRegViewController *childController = segue.destinationViewController;
        childController.userInfo = self.userInfo;
        childController.avatarImage = _avatarImage;
        childController.regByWechat = YES;
    }
    
}


@end
