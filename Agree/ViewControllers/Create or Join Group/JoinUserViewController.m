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


@interface JoinUserViewController () <SRImageManagerDelegate> {
    SRNet_Manager *_netManager;
    SRImageManager *_imageManager;
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

-(void)imageUploading:(float)proFloat
{
    [SVProgressHUD showProgress:proFloat*0.9];
    NSLog(@"小组正在创建");
}

- (void)createEMGroup {
    
    
//    [SVProgressHUD showWithStatus:@"正在建立小组"];
    [SVProgressHUD showProgress:1.0];
    
    EMError *error = nil;
    EMGroupStyleSetting *groupStyleSetting = [[EMGroupStyleSetting alloc] init];
    //    groupStyleSetting.groupMaxUsersCount = 500; // 创建500人的群，如果不设置，默认是200人。
    groupStyleSetting.groupStyle = eGroupStyle_PublicOpenJoin; // 创建不同类型的群组，这里需要才传入不同的类型
    EMGroup *group = [[EaseMob sharedInstance].chatManager createGroupWithSubject:self.theGroup.name description:@"群组描述" invitees:@[[Model_User loadFromUserDefaults].pk_user.stringValue] initialWelcomeMessage:@"邀请您加入群组" styleSetting:groupStyleSetting error:&error];
    if(!error){
        NSLog(@"创建成功 -- %@",group);
        
        //完成小组创建
        if (!_netManager) {
            _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
        }
        
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
            if (!_imageManager) {
                _imageManager = [[SRImageManager alloc] initWithDelegate:self];
            }
            [_imageManager updateImageToTXY:self.groupCover];
            self.groupCover = nil;
        } else {
            [_netManager addGroup:self.theGroup withMembers:_groupMembers];
        }
    }else {
    }
}


- (void)interfaceReturnDataSuccess:(NSMutableDictionary *)jsonDic with:(int)interfaceType {
    //群组创建成功
    [SVProgressHUD showSuccessWithStatus:@"小组创建成功"];
//    [SVProgressHUD showProgress:1.0];
    
    
    switch (interfaceType) {
        case kAddGroup: {
            if (jsonDic) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    GroupViewController *rootController = [self.navigationController.viewControllers objectAtIndex:0];
                    [rootController loadUserGroupRelationship];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
        }
            break;
            
        default:
            break;
    }
}



- (void)interfaceReturnDataError:(int)interfaceType {
    [SVProgressHUD showErrorWithStatus:@"网络错误"];
}

- (void)imageUploadDoneWithFieldID:(NSString *)fieldID {
    self.theGroup.avatar_path = fieldID;
    [_netManager addGroup:self.theGroup withMembers:_groupMembers];
}

- (void)imageUpladError {
    
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
