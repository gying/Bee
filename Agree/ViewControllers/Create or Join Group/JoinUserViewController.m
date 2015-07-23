//
//  JoinUserViewController.m
//  SRAgree
//
//  Created by G4ddle on 14/12/16.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import "JoinUserViewController.h"
#import <SVProgressHUD.h>
#import "SRImageManager.h"
#import "GroupViewController.h"
#import "EaseMob.h"

#import "ChoosefriendsViewController.h"


@interface JoinUserViewController () {
    NSMutableArray *_groupMembers;
    
    ChoosefriendsViewController * choosefriendsVC;
    
}

@end

@implementation JoinUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.groupCoverButton setBackgroundImage:self.groupCover forState:UIControlStateNormal];
    [self.groupCoverButton.layer setCornerRadius:3.0];
    [self.groupCoverButton.layer setMasksToBounds:YES];
    [self.groupCoverButton setTitle:@"" forState:UIControlStateNormal];
    
    [self.groupNameTextField setText:self.theGroup.name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)groupCreateDone:(id)sender {
    [self createEMGroup];
}

- (void)createEMGroup {
//    [SVProgressHUD showWithStatus:@"正在建立小组"];
//    [SVProgressHUD showProgress:1.0 maskType:SVProgressHUDMaskTypeGradient];
    
    EMError *error = nil;
    EMGroupStyleSetting *groupStyleSetting = [[EMGroupStyleSetting alloc] init];
    //    groupStyleSetting.groupMaxUsersCount = 500; // 创建500人的群，如果不设置，默认是200人。
    groupStyleSetting.groupStyle = eGroupStyle_PublicOpenJoin; // 创建不同类型的群组，这里需要才传入不同的类型
    EMGroup *group = [[EaseMob sharedInstance].chatManager createGroupWithSubject:self.theGroup.name description:@"群组描述" invitees:@[[Model_User loadFromUserDefaults].pk_user.stringValue] initialWelcomeMessage:@"邀请您加入群组" styleSetting:groupStyleSetting error:&error];
    if(!error){
        NSLog(@"创建成功 -- %@",group);
        
        //完成小组创建
        self.theGroup.setup_time = [NSDate date];
        self.theGroup.last_post_message = @"小组成立啦!";
        self.theGroup.last_post_time = [NSDate date];
        self.theGroup.em_id = group.groupId;
        
        //将创建者加入关系
        Model_Group_User *group_user = [[Model_Group_User alloc] init];
        [group_user setFk_user:[Model_User loadFromUserDefaults].pk_user];
        //1.创建者 2.普通成员
        [group_user setRole:[NSNumber numberWithInt:1]];
        
        //将创建者关系加入组员关系信息数组
        _groupMembers = [[NSMutableArray alloc] init];
        [_groupMembers addObject:group_user];
        
        for (Model_User *joinUser in self.choosePeopleArray) {
            Model_Group_User *groupUser = [[Model_Group_User alloc] init];
            [groupUser setFk_user:joinUser.pk_user];
            [groupUser setRole:[NSNumber numberWithInt:2]];

            [_groupMembers addObject:groupUser];
        }
        
        if (self.groupCover) {
            self.theGroup.avatar_path = [NSUUID UUID].UUIDString;
            [[SRImageManager initImageOSSData:self.groupCover
                                     withKey:self.theGroup.avatar_path] uploadWithUploadCallback:^(BOOL isSuccess, NSError *error) {
                if (isSuccess) {
                    //图片上传成功
                    [SRNet_Manager requestNetWithDic:[SRNet_Manager addGroupDic:self.theGroup withMembers:_groupMembers]
                                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                                if (jsonDic) {
                                                    [SVProgressHUD showSuccessWithStatus:@"小组创建成功"];
                                                    dispatch_async(dispatch_get_main_queue(), ^{
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

            
            self.groupCover = nil;
            
        } else {
            [SRNet_Manager requestNetWithDic:[SRNet_Manager addGroupDic:self.theGroup withMembers:_groupMembers]
                                    complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                        if (jsonDic) {
                                            [SVProgressHUD showSuccessWithStatus:@"小组创建成功"];
                                            dispatch_async(dispatch_get_main_queue(), ^{
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


- (IBAction)tapBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"gotoChooseFriend"]) {
        //进入多选加入好友界面时,将原本的备选数组置入
        if (!self.choosePeopleArray) {
            self.choosePeopleArray = [[NSMutableArray alloc] init];
        }
        
        ChoosefriendsViewController *childController = (ChoosefriendsViewController *)segue.destinationViewController;
        childController.rootController = self;
        childController.choosePeopleArray = self.choosePeopleArray;
    }
}


@end
