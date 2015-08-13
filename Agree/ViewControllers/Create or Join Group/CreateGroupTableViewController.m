//
//  CreateGroupTableViewController.m
//  Agree
//
//  Created by G4ddle on 15/8/13.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "CreateGroupTableViewController.h"
#import "ChoosefriendsViewController.h"
#import "SRImageManager.h"
#import "SRTool.h"
#import <SVProgressHUD.h>
#import "EaseMob.h"
#import "GroupViewController.h"

#import "SRTextFieldTableViewCell.h"

@interface CreateGroupTableViewController () <SRChooseFriendsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate> {
    NSMutableArray *_choosePeopleArray;
    UIImagePickerController *_imagePicker;
    //选择的小组封面图片
    UIImage *_groupCoverImage;
    
    UITextField *_nameTextField;
    Model_Group *_newGroup;
}

@end

@implementation CreateGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.coverButton.layer setCornerRadius:3.0];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0: {
            SRTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inputGroupNameCell" forIndexPath:indexPath];
            if (nil == cell) {
                cell = [[SRTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"inputGroupNameCell"];
            }
            _nameTextField = cell.inputTextField;
            [_nameTextField becomeFirstResponder];
            [_nameTextField setDelegate:self];
            return cell;
        }
            break;
        case 1: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"invitationFriendCell" forIndexPath:indexPath];
            if (nil == cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"invitationFriendCell"];
            }
            
            cell.textLabel.text = @"邀请好友加入小组";
            [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (IBAction)groupNameInputEnd:(id)sender {
}



//由选择好友控制器返回的代理方法,用于传输用户列表
- (void)saveFriendList:(NSMutableArray *)friendList {
    //对用户列表进行赋值
    _choosePeopleArray = friendList;
}
- (IBAction)tapBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)tapDoneButton:(id)sender {
    //点击完成方法,开始建立小组
    
    
    if (0 == _nameTextField.text.length) {
        //如果小组名称字符串长度为0
        //显示提示
        [SRTool showSRAlertOnlyTipWithTitle:@"提示" message:@"小组名称不能为空哦~"];
    } else {
        //名称不为空,开始创建小组流程
        
        if (!_newGroup) {
            _newGroup = [[Model_Group alloc] init];
        }
        
        _newGroup.name = _nameTextField.text;
        
        
//        return YES;
        EMError *error = nil;
        EMGroupStyleSetting *groupStyleSetting = [[EMGroupStyleSetting alloc] init];
        //    groupStyleSetting.groupMaxUsersCount = 500; // 创建500人的群，如果不设置，默认是200人。
        groupStyleSetting.groupStyle = eGroupStyle_PublicOpenJoin; // 创建不同类型的群组，这里需要才传入不同的类型
        EMGroup *group = [[EaseMob sharedInstance].chatManager createGroupWithSubject:_newGroup.name description:@"群组描述" invitees:@[[Model_User loadFromUserDefaults].pk_user.stringValue] initialWelcomeMessage:@"邀请您加入群组" styleSetting:groupStyleSetting error:&error];
        if(!error){
            NSLog(@"创建成功 -- %@",group);
            
            //完成小组创建
            _newGroup.setup_time = [NSDate date];
            _newGroup.last_post_message = @"小组成立啦!";
            _newGroup.last_post_time = [NSDate date];
            _newGroup.em_id = group.groupId;
            
            //将创建者加入关系
            Model_Group_User *group_user = [[Model_Group_User alloc] init];
            [group_user setFk_user:[Model_User loadFromUserDefaults].pk_user];
            //1.创建者 2.普通成员
            [group_user setRole:[NSNumber numberWithInt:1]];
            
            //将创建者关系加入组员关系信息数组
            NSMutableArray *groupMembers = [[NSMutableArray alloc] init];
            [groupMembers addObject:group_user];
            
            for (Model_User *joinUser in _choosePeopleArray) {
                Model_Group_User *groupUser = [[Model_Group_User alloc] init];
                [groupUser setFk_user:joinUser.pk_user];
                [groupUser setRole:[NSNumber numberWithInt:2]];
                
                [groupMembers addObject:groupUser];
            }
            
            if (_groupCoverImage) {
                //如果有小组图片,则开始进行上传流程
                //先生成一个图片的uuid,以便于保存
                _newGroup.avatar_path = [NSUUID UUID].UUIDString;
                [[SRImageManager initImageOSSData:_groupCoverImage
                                          withKey:_newGroup.avatar_path] uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
                    if (isSuccess) {
                        //图片上传成功
                        [SRNet_Manager requestNetWithDic:[SRNet_Manager addGroupDic:_newGroup withMembers:groupMembers]
                                                complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                                    if (jsonDic) {
                                                        [SVProgressHUD showSuccessWithStatus:@"小组创建成功"];
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            //这里默认全部小组的页面为根视图控制器,取出并直接调用刷新方法
                                                            GroupViewController *rootController = [self.navigationController.viewControllers objectAtIndex:0];
                                                            [rootController loadUserGroupRelationship];
                                                            [self.navigationController popToRootViewControllerAnimated:YES];
                                                        });
                                                    }
                                                } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                                    
                                                }];
                    } else {
                        //上传失败
                        
                    }
                } withProgressCallback:^(float progress) {
                    [SVProgressHUD showProgress: progress*0.9
                                       maskType:SVProgressHUDMaskTypeGradient];
                }];
                //上传成功则将图片设置为空
                _groupCoverImage = nil;
                
            } else {
                [SRNet_Manager requestNetWithDic:[SRNet_Manager addGroupDic:_newGroup withMembers:groupMembers]
                                        complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                            if (jsonDic) {
                                                [SVProgressHUD showSuccessWithStatus:@"小组创建成功"];
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    //这里默认全部小组的页面为根视图控制器,取出并直接调用刷新方法
                                                    GroupViewController *rootController = [self.navigationController.viewControllers objectAtIndex:0];
                                                    [rootController loadUserGroupRelationship];
                                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                                });
                                            }
                                        } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                            
                                        }];
            }
        }else {
            NSLog(@"创建错误: %@", error);
        }
    }
}

- (IBAction)tapCoverButton:(id)sender {
    [_nameTextField resignFirstResponder];
    
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
    UIImage *pickImage = [info valueForKey:@"UIImagePickerControllerEditedImage"];
    
    
    _groupCoverImage = [SRImageManager getSubImage:pickImage withRect:CGRectMake(0, 0, self.coverButton.frame.size.width * 2, self.coverButton.frame.size.height * 2)];
    
    [self.coverButton setBackgroundImage:_groupCoverImage forState:UIControlStateNormal];
    [self.coverButton.layer setCornerRadius:3.0];
    [self.coverButton.layer setMasksToBounds:YES];
    [self.coverButton setTitle:@"" forState:UIControlStateNormal];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"GoToChooseFriend"]) {
        //进入多选加入好友界面时,将原本的备选数组置入
        if (!_choosePeopleArray) {
            _choosePeopleArray = [[NSMutableArray alloc] init];
        }
        
        ChoosefriendsViewController *childController = (ChoosefriendsViewController *)segue.destinationViewController;
        childController.delegate = self;
        childController.choosePeopleArray = _choosePeopleArray;
    }
}


@end
