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

@interface CreateGroupViewController () <UITextFieldDelegate, SRNetManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, SRImageManagerDelegate> {
    Model_Group *_newGroup;
    SRNet_Manager *_netManager;
    UIImagePickerController *_imagePicker;
    SRImageManager *_imageManager;
    
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
        if (!_netManager) {
            _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
        }
        Model_Group_Code *newCode = [[Model_Group_Code alloc] init];
        newCode.pk_group_code = textField.text;
        [_netManager joinTheGroupByCode:newCode];
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
    
    NSLog(@"现在操作图片按钮");
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *pickImage = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (!_imageManager) {
        _imageManager = [[SRImageManager alloc] initWithDelegate:self];
    }
    
    _groupCoverImage = [SRImageManager getSubImage:pickImage withRect:CGRectMake(0, 0, self.groupCoverButton.frame.size.width * 2, self.groupCoverButton.frame.size.height * 2)];
    
    [self.groupCoverButton setBackgroundImage:_groupCoverImage forState:UIControlStateNormal];
    [self.groupCoverButton.layer setCornerRadius:3.0];
    [self.groupCoverButton.layer setMasksToBounds:YES];
    [self.groupCoverButton setTitle:@"" forState:UIControlStateNormal];
}

- (IBAction)pressedTheCodeBackButton:(id)sender {
    [self.codeInputTextField resignFirstResponder];
    [self.codeView setHidden:YES];
    NSLog(@"收到邀请码");
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
    
    NSLog(@"222");
    
    
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
    
    NSLog(@"333");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (2 >= self.groupNameTextField.text.length) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"小组名称不能为空或者小于两个字符" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return NO;
        
    } else {
        return YES;
    }
}

- (void)interfaceReturnDataSuccess:(id)jsonDic with:(int)interfaceType {
    switch (interfaceType) {
        case kJoinTheGroupByCode: {
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
                [self.groupCoverImageView sd_setImageWithURL:[SRImageManager groupFrontCoverImageFromTXYFieldID:_joinGroup.avatar_path]];
            } else {
                [SVProgressHUD showErrorWithStatus:@"未找到相关数据"];
                //未找到小组的相关数据
                [self.remarkLabel setText:@"未找到小组信息,请再次确认输入"];
                [self.codeInputTextField becomeFirstResponder];
            }
        }
            break;
            
        default:
            break;
    }
    [SVProgressHUD dismiss];
}

- (void)interfaceReturnDataError:(int)interfaceType {
    [SVProgressHUD dismiss];
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
