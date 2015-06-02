//
//  SelectFriendViewController.m
//  Agree
//
//  Created by G4ddle on 15/3/18.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "SelectFriendViewController.h"
#import "SRNet_Manager.h"
#import "ProgressHUD.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "SRTool.h"


@interface SelectFriendViewController () <SRNetManagerDelegate> {
    SRNet_Manager *_netManager;
    Model_User *_user;
    
    BOOL _addFriend;
}

@end

@implementation SelectFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.accountTextField becomeFirstResponder];
    [self.accountTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.accountTextField setKeyboardAppearance:UIKeyboardAppearanceDark];
    
    [self.avatarImage.layer setCornerRadius:self.avatarImage.frame.size.height/2];
    [self.avatarImage.layer setMasksToBounds:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击添加按钮
- (IBAction)pressedTheAddButton:(id)sender {
    if (!_netManager) {
        _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
    }
    if (self.avatarImage.hidden) {
        //如果头像界面那隐藏,则为查找用户
        _user = [[Model_User alloc] init];
        [_user setPhone:self.accountTextField.text];
        [_netManager getUserByPhone:_user];
    } else {
        //添加用户
        Model_user_user *userRelation = [[Model_user_user alloc] init];
        [userRelation setFk_user_from:[Model_User loadFromUserDefaults].pk_user];
        [userRelation setFk_user_to:_user.pk_user];
        [userRelation setRelationship:@1];
        [userRelation setStatus:@1];
        _addFriend = TRUE;
        [_netManager addFriend:userRelation];
    }
}
- (IBAction)pressedTheReInputButton:(id)sender {
    [self.accountTextField setHidden:NO];
    [self.accountTextField setText:@""];
//    [self.remarkLabel setText:@""];
    [self.avatarImage setHidden:YES];
    [self.avatarImage setImageWithURL:nil];
    [self.reInputButton setHidden:YES];
    [self.remarkLabel setText:@"输入好友必聚号或绑定的手机号码"];
    
    
    [self.addButton setTitle:@"查找用户" forState:UIControlStateNormal];
}

- (void)interfaceReturnDataSuccess:(id)jsonDic with:(int)interfaceType {
    
    switch (interfaceType) {
        case kAddFriend: {
        
        }
            break;
            
        case kGetUserByPhone: {
            if (jsonDic) {
                _user = [[Model_User objectArrayWithKeyValuesArray:jsonDic] objectAtIndex:0];
                [self.remarkLabel setText:_user.nickname];
                
                [self.accountTextField setHidden:YES];
                [self.avatarImage setImageWithURL:[SRTool imageUrlFromPath:_user.avatar_path]];
                [self.avatarImage setHidden:NO];
                
                [self.reInputButton setHidden:NO];
                [self.addButton setTitle:@"发送好友请求" forState:UIControlStateNormal];
                
            } else {
                //找不到该用户
                [self.remarkLabel setText:@"找不到手机用户,请再次确认后输入"];
            }
        }
            break;
            
        default:
            break;
    }
    
    [ProgressHUD dismiss];
}

- (void)interfaceReturnDataError:(int)interfaceType {
    [ProgressHUD dismiss];
}
- (IBAction)tapBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
