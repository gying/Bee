//
//  CreateGroupViewController.m
//  SRAgree
//
//  Created by G4ddle on 14/12/16.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "Model_Group.h"
#import "JoinUserViewController.h"
#import "SRNet_Manager.h"
#import <SVProgressHUD.h>
#import "MJExtension.h"
#import "GroupViewController.h"
#import "SRImageManager.h"
#import "UIImageView+WebCache.h"

//#import <DQAlertView.h>
#import "SRTool.h"

@interface CreateGroupViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    Model_Group *_newGroup;
    UIImagePickerController *_imagePicker;
    
    UIImage *_groupCoverImage;
    Model_Group *_joinGroup;
}

@end

@implementation CreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _newGroup = [[Model_Group alloc] init];
    self.codeView.hidden = YES;
    
}
- (IBAction)pressedTheShowCodeViewButton:(UIButton *)sender {
    if (self.codeView.hidden) {
        self.codeView.hidden = NO;
        [self.codeInputTextField becomeFirstResponder];
    } else {
        self.codeView.hidden = YES;
    }
}
- (IBAction)pressedTheCoverButton:(id)sender {
    //点击小组封面按钮
    [self imageBtnClick];
    NSLog(@"现在操作小组封面按钮");
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([@"CodeField" isEqual:textField.restorationIdentifier]) {
        //验证码输入界面
        Model_Group_Code *newCode = [[Model_Group_Code alloc] init];
        newCode.pk_group_code = textField.text;
        
        [SRNet_Manager requestNetWithDic:[SRNet_Manager joinTheGroupByCodeDic:newCode]
                                complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                    if (jsonDic) {
                                        [SVProgressHUD showSuccessWithStatus:@"找到小组"];
                                        _joinGroup = [[Model_Group objectArrayWithKeyValuesArray:jsonDic] firstObject];
                                        
                                        //显示要加入的小组
                                        [self.groupCoverImageView setHidden:NO];
                                        [self.groupNameLabel setHidden:NO];
                                        [self.recodeButton setHidden:NO];
                                        [self.joinButton setHidden:NO];
                                        [self.publicPhoneLabel setHidden:NO];
                                        [self.publicPhoneSeg setHidden:NO];
                                        
                                        [self.codeInputTextField setHidden:YES];
                                        [self.groupCoverButton setHidden:YES];
                                        [self.remarkLabel setHidden:YES];
                                        
                                        [self.groupNameLabel setText:_joinGroup.name];
                                        
                                        //下载图片
                                        NSURL *imageUrl = [SRImageManager groupFrontCoverImageImageFromOSS:_joinGroup.avatar_path];
                                        [self.groupCoverImageView sd_setImageWithURL:imageUrl];
                                        
                                    }
                                    else {
                                        [SVProgressHUD showErrorWithStatus:@"未找到相关数据"];
                                        //未找到小组的相关数据
                                        [self.remarkLabel setText:@"未找到小组信息,请再次确认输入"];
                                        [self.codeInputTextField becomeFirstResponder];
                                    }
                                } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                    
                                }];
    } else if([self.groupNameTextField.restorationIdentifier isEqualToString:textField.restorationIdentifier]) {
        //输入小组名称
        _newGroup.name = textField.text;
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)imageBtnClick {
    //点击图片按钮
    
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
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


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *pickImage = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    
    _groupCoverImage = [SRImageManager getSubImage:pickImage withRect:CGRectMake(0, 0, self.groupCoverButton.frame.size.width * 2, self.groupCoverButton.frame.size.height * 2)];
    
    [self.groupCoverButton setBackgroundImage:_groupCoverImage forState:UIControlStateNormal];
    [self.groupCoverButton.layer setCornerRadius:3.0];
    [self.groupCoverButton.layer setMasksToBounds:YES];
    [self.groupCoverButton setTitle:@"" forState:UIControlStateNormal];
}

- (IBAction)pressedTheCodeBackButton:(id)sender {
    [self.codeInputTextField resignFirstResponder];
    [self.codeView setHidden:YES];
}

- (IBAction)pressedTheJoinButton:(id)sender {
    GroupViewController *rootController = [self.navigationController.viewControllers objectAtIndex:0];
    rootController.joinGroup = _joinGroup;
    
    if (0 == self.publicPhoneSeg.selectedSegmentIndex) {
        //公开
        rootController.needPublicPhone = YES;
    } else {
        //不公开
        rootController.needPublicPhone = NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
        GroupViewController *rootController = [self.navigationController.viewControllers objectAtIndex:0];
        [rootController joinGroupRelation];
    });
}

- (IBAction)pressedTheRecodeButton:(id)sender {
    //重新输入验证码
    [self.groupNameLabel setText:@""];
    [self.groupCoverImageView setImage:nil];
    
    [self.groupCoverImageView setHidden:YES];
    [self.groupNameLabel setHidden:YES];
    [self.recodeButton setHidden:YES];
    [self.joinButton setHidden:YES];
    
    [self.publicPhoneLabel setHidden:YES];
    [self.publicPhoneSeg setHidden:YES];
    
    [self.codeInputTextField setHidden:NO];
    [self.groupCoverButton setHidden:NO];
    [self.remarkLabel setHidden:NO];
    
    
    [self.codeInputTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (0 == self.groupNameTextField.text.length) {
        [SRTool showSRAlertViewWithTitle:@"提示"
                                 message:@"小组名称不能为空哦~"
                       cancelButtonTitle:@"好的"
                        otherButtonTitle:nil
                   tapCancelButtonHandle:^(NSString *msgString) {
                             
                   } tapOtherButtonHandle:^(NSString *msgString) {
                             
                         }];
        return NO;
        
    } else {
        return YES;
    }
}

- (IBAction)tapBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([@"CreateDone" isEqualToString:segue.identifier]) {
        JoinUserViewController *childController = segue.destinationViewController;
        childController.theGroup = _newGroup;
        childController.theGroup.name = self.groupNameTextField.text;
        childController.groupCover = _groupCoverImage;
    }
}

@end
