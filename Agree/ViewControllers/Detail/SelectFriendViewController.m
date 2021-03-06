//
//  SelectFriendViewController.m
//  Agree
//
//  Created by G4ddle on 15/3/18.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "SelectFriendViewController.h"
#import "SRNet_Manager.h"
#import <SVProgressHUD.h>
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "SRImageManager.h"
#import "SRTool.h"


@interface SelectFriendViewController () {
    Model_User *_user;
    
    BOOL _addFriend;
    int _relationStatus;
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
    if (self.avatarImage.hidden) {
        //如果头像界面那隐藏,则为查找用户
        _user = [[Model_User alloc] init];
        [_user setPhone:self.accountTextField.text];
        [_user setPk_user:[Model_User loadFromUserDefaults].pk_user];
        
        [SRNet_Manager requestNetWithDic:[SRNet_Manager getUserByPhoneDic:_user]
                                complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                    if (jsonDic) {
                                        _user = [[Model_User objectArrayWithKeyValuesArray:jsonDic] objectAtIndex:0];
                                        [self.remarkLabel setText:_user.nickname];
                                        
                                        [self.accountTextField setHidden:YES];
                                        [self.avatarImage sd_setImageWithURL:[SRImageManager avatarImageFromOSS:_user.avatar_path]];
                                        
                                        
                                        [self.avatarImage setHidden:NO];
                                        [self.reInputButton setHidden:NO];
                                        
                                        _relationStatus = _user.relationship.intValue;
                                        
                                        switch (_relationStatus) {
                                            case 0: {
                                                [self.addButton setTitle:@"发送好友请求" forState:UIControlStateNormal];
                                            }
                                                break;
                                            case 1: {
                                                [self.addButton setTitle:@"已发送好友请求" forState:UIControlStateNormal];
                                            }
                                                break;
                                            default: {
                                                [self.addButton setTitle:@"已存在好友关系" forState:UIControlStateNormal];
                                            }
                                                break;
                                        }
                                        
                                    } else {
                                        //找不到该用户
                                        [self.remarkLabel setText:@"找不到手机用户,请再次确认后输入"];
                                    }
                                } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                    
                                }];
    } else {
        if (0 == _relationStatus) {
            if ([_user.pk_user isEqualToNumber:[Model_User loadFromUserDefaults].pk_user]) {
                //出现自己添加自己的情况
                [SRTool showSRAlertOnlyTipWithTitle:@"提示" message:@"自己无法添加自己哦~"];
            } else {
                //如果用户并不存在好友关系
                //添加用户
                Model_user_user *userRelation = [[Model_user_user alloc] init];
                [userRelation setFk_user_from:[Model_User loadFromUserDefaults].pk_user];
                [userRelation setFk_user_to:_user.pk_user];
                [userRelation setRelationship:@1];
                [userRelation setStatus:@1];
                _addFriend = TRUE;
                
                [SVProgressHUD showWithStatus:@"正在发送好友请求"];
                [SRNet_Manager requestNetWithDic:[SRNet_Manager addFriendDic:userRelation]
                                        complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                            [SVProgressHUD showSuccessWithStatus:@"好友请求发送成功"];
                                            [self.navigationController popViewControllerAnimated:YES];
                                        } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                            
                                        }];
            }
        }
    }
}


- (IBAction)pressedTheReInputButton:(id)sender {
    [self.accountTextField setHidden:NO];
    [self.accountTextField setText:@""];
//    [self.remarkLabel setText:@""];
    [self.avatarImage setHidden:YES];
    [self.avatarImage sd_setImageWithURL:nil];
    [self.reInputButton setHidden:YES];
    [self.remarkLabel setText:@"输入好友必聚号或绑定的手机号码"];

    [self.addButton setTitle:@"查找用户" forState:UIControlStateNormal];
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
