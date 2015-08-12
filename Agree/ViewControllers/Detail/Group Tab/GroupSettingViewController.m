//
//  GroupSettingViewController.m
//  Agree
//
//  Created by G4ddle on 15/1/26.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "GroupSettingViewController.h"
#import "SRNet_Manager.h"
#import <SVProgressHUD.h>
#import "Model_Group_Code.h"
#import "MJExtension.h"
#import "GroupViewController.h"
#import "UIImageView+WebCache.h"
#import "GroupPeopleCollectionViewCell.h"
#import "SRAccountView.h"
#import "Model_User.h"
#import "SRImageManager.h"
#import "SRTool.h"


#import "GroupSettingUITableViewCell.h"
#import "GroupHistroyPartyViewController.h"


#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]

@interface GroupSettingViewController ()<UITableViewDataSource, UITableViewDelegate> {
    Model_Group_User *_relationship;
    UIImageView *_backImageViwe;
    
    NSMutableArray *_relationArray;
    BOOL _saveForQuit;
    SRAccountView *_accountView;
    
    NSArray *_tableAry;
}

@end

@implementation GroupSettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD dismiss];
    
    _tableAry = @[@[@"小组名称",@"小组历史聚会",@"邀请好友加入"], @[@"聚会的信息提示",@"聊天的信息提示",@"公开手机号码"],@[@"退出小组"]];
    
    self.avatarButton.layer.cornerRadius = 3.0;
    //类型的边框与圆弧
    self.inButton.layer.cornerRadius = self.inButton.frame.size.height/4;
    self.inButton.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    self.inButton.layer.borderWidth = 0.5;
    
}
- (IBAction)changeAvatar:(id)sender {
    NSLog(@"更换头像");
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
////    [SVProgressHUD showWithStatus:@"小组信息读取中..." maskType:SVProgressHUDMaskTypeGradient];
//    
//    // Do any additional setup after loading the view.
//    _accountView = [[SRAccountView alloc] init];
//    _accountView.rootController = self;
//    
//    Model_Group_User *group_user = [[Model_Group_User alloc] init];
//    [group_user setFk_group:self.group.pk_group];
//    [group_user setFk_user:[Model_User loadFromUserDefaults].pk_user];
//    
//    _backImageViwe = [[UIImageView alloc] initWithFrame:CGRectMake(4.5, 4.5, 90, 90)];
////    _backImageViwe.backgroundColor = [UIColor redColor];
//    
//    [_backImageViwe.layer setMasksToBounds:YES];
//    [_backImageViwe.layer setCornerRadius:_backImageViwe.frame.size.width/2];
//    
//    [SRImageManager avatarImageFromOSS:[Model_User loadFromUserDefaults].avatar_path];
//    
//    //读取个人与小组的关系
//    [SRNet_Manager requestNetWithDic:[SRNet_Manager getGroupRelationshipDic:group_user]
//                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
//                                NSArray *relAry = jsonDic;
//                                if (relAry) {
//                                    _relationship = [[Model_Group_User objectArrayWithKeyValuesArray:relAry] objectAtIndex:0];
//                                }
//                                [self reloadButtonStatusSetting];
//                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
//                                
//                            }];
//    //读取小组全部的关系
//    [SRNet_Manager requestNetWithDic:[SRNet_Manager getAllRelationFromGroupDic:self.group]
//                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
//                                if (jsonDic) {
//                                    [SVProgressHUD dismiss];
//                                    _relationArray = (NSMutableArray *)[Model_Group_User objectArrayWithKeyValuesArray:jsonDic];
//                                    [self.peopleCollectionView reloadData];
//                                    
//                                } else {
//                                    
//                                }
//                                
//                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
//                                
//                            }];
//    
//}
//



#pragma mark -- 点击生成验证码
- (IBAction)pressedTheCodeButton:(UIButton *)sender {

    Model_Group *theGroup = [[Model_Group alloc] init];
    theGroup.pk_group = self.group.pk_group;

    [SRNet_Manager requestNetWithDic:[SRNet_Manager generationCodeByGroupDic:theGroup]
                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                if (jsonDic) {
                                    if ([jsonDic isKindOfClass:[NSString class]]) {
                                        [self.inButton setTitle:jsonDic forState:UIControlStateNormal];
                           
                                    } else {
                                        NSArray *codeObjArray = [Model_Group_Code objectArrayWithKeyValuesArray:jsonDic];
                                        for (Model_Group_Code *theCodeObj in codeObjArray) {
                                            if (1 != [theCodeObj.code_status intValue]) {
                                            
                                                [self.inButton setTitle:theCodeObj.pk_group_code forState:UIControlStateNormal];
                          
                                            }
                                        }
                                    }
                                }
                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                
                            }];
    
    if (![self.inButton.titleLabel.text  isEqual: @"点击生成邀请码"]) {
        //复制
        UIMenuItem *itCopy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(handleCopyCell:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:itCopy, nil]];
        [menu setTargetRect:self.inButton.frame inView:self.view];
        [menu setMenuVisible:YES animated:YES];
    }
}


#pragma mark -- 保存BUTTON
- (IBAction)tapSaveButton:(id)sender {
    _saveForQuit = NO;
//    [SVProgressHUD show];
//    [SRNet_Manager requestNetWithDic:[SRNet_Manager updateGroupRelationShip:_relationship]
//                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
//                                [self updateGroupRelationShipDone:jsonDic];
                                [SVProgressHUD showSuccessWithStatus:@"设置保存成功"];
//                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
//                                
//                            }];
}


#pragma mark -- 返回BUTTON
- (IBAction)tapBackButton:(id)sender {
    if (_saveForQuit) {
        //资料已更改
        [SRTool showSRSheetInView:self.view withTitle:@"提示" message:@"小组的信息已经更改,是否保存后退出?"
                  withButtonArray:@[@"是的", @"不,我想要直接退出"]
                  tapButtonHandle:^(int buttonIndex) {
                      switch (buttonIndex) {
                          case 0: {
                              //保存后退出
                              //保存退出
                              _saveForQuit = NO;
                              [SRNet_Manager requestNetWithDic:[SRNet_Manager updateGroupRelationShip:_relationship]
                                                      complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                                          [self updateGroupRelationShipDone:jsonDic];
                                                      } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                                          
                                                      }];
                              [self.navigationController popViewControllerAnimated:YES];
                              [self.rootController tapCloseButton:nil];
                          }
                              break;
                          case 1: {
                              //直接退出
                              [self.navigationController popViewControllerAnimated:YES];
                              [self.rootController tapCloseButton:nil];
                          }
                              break;
                          default:
                              break;
                      }
                  } tapCancelHandle:^{
                      
                  }];
        
    } else {
        
        [self.rootController tapCloseButton:nil];

        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


- (void)updateGroupRelationShipDone: (id)jsonDic {
    if (_saveForQuit) {
        dispatch_async(dispatch_get_main_queue(), ^{
            GroupViewController *rootController = [self.navigationController.viewControllers objectAtIndex:0];
            [rootController loadUserGroupRelationship];
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }
}

#pragma mark -- 第一响应
- (BOOL)canBecomeFirstResponder{
    return YES;
}

#pragma mark -- 长按赋值方法
- (void)handleCopyCell:(id)sender {

    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.inButton.titleLabel.text;
}


#pragma mark -- 聚会信息提醒
//- (IBAction)pressedThePartyButton:(UIButton *)sender {
//    if (1 == _relationship.party_warn.intValue) {
//        [_relationship setParty_warn:[NSNumber numberWithInt:0]];
//    } else {
//        [_relationship setParty_warn:[NSNumber numberWithInt:1]];
//    }
//    [self reloadButtonStatusSetting];
//    
//    _saveForQuit = true;
//}
#pragma mark -- 聊天信息提醒
//- (IBAction)pressedTheChatButton:(UIButton *)sender {
//    if (1 == _relationship.message_warn.intValue) {
//        [_relationship setMessage_warn:[NSNumber numberWithInt:0]];
//    } else {
//        [_relationship setMessage_warn:[NSNumber numberWithInt:1]];
//    }
//    [self reloadButtonStatusSetting];
//    
//    _saveForQuit = true;
//}
#pragma mark -- 公开手机号
//- (IBAction)pressedThePhoneButton:(UIButton *)sender {
//    if (1 == _relationship.public_phone.intValue) {
//        [_relationship setPublic_phone:[NSNumber numberWithInt:0]];
//    } else {
//        [_relationship setPublic_phone:[NSNumber numberWithInt:1]];
//    }
//    [self reloadButtonStatusSetting];
//    
//    _saveForQuit = true;
//}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupSettingUITableViewCell *cell = [self.groupSettingTableView dequeueReusableCellWithIdentifier:@"GROUPSETTINGCELL" forIndexPath:indexPath];
    if (!cell) {
        cell = [[GroupSettingUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GROUPSETTINGCELL"];
    }
    NSArray *subAry = [_tableAry objectAtIndex:indexPath.section];
    cell.textLabel.text = [subAry objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_tableAry) {
        NSArray *subAry = [_tableAry objectAtIndex:section];
        return subAry.count;
    }
    return 0;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return @"小组";
        }
            
            break;
        case 1: {
            return @"提示";
        }
            
            break;

        default:
            return @"其他";
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_tableAry) {
        return _tableAry.count;
    }
    return 1;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ((0 == indexPath.section)&&(0 == indexPath.row)) {
//        NSLog(@"小组名称");
//        
//    }
//    else if ((0 == indexPath.section)&&(1 == indexPath.row)) {
//        NSLog(@"小组历史聚会");
//        
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
//        
//        GroupHistroyPartyViewController *childController = [sb instantiateViewControllerWithIdentifier:@"GroupHistroyPartyViewController"];
//        [self.navigationController showViewController:childController sender:self];
//        
//    }
//    else if ((0 == indexPath.section)&&(2 == indexPath.row)) {
//        NSLog(@"邀请好友加入");
//        
//    }
//    else if ((1 == indexPath.section)&&(0 == indexPath.row)) {
//        NSLog(@"聚会信息提示");
//        
//    }
//    else if ((1 == indexPath.section)&&(1 == indexPath.row)) {
//        NSLog(@"聊天信息提示");
//        
//    }
//    else if ((1 == indexPath.section)&&(2 == indexPath.row)) {
//        NSLog(@"公开手机号码");
//        
//    }
//    else if ((2 == indexPath.section)&&(0 == indexPath.row)) {
//        NSLog(@"退出小组");
//        
//        [SRTool showSRAlertViewWithTitle:@"警告" message:@"真的要退出这个小组吗?"
//                            cancelButtonTitle:@"我再想想" otherButtonTitle:@"是的"
//                        tapCancelButtonHandle:^(NSString *msgString) {
//         
//                        } tapOtherButtonHandle:^(NSString *msgString) {
//                            //确认发送
//                            _relationship.status = @0;
//                            _saveForQuit = YES;
//                            [SRNet_Manager requestNetWithDic:[SRNet_Manager updateGroupRelationShip:_relationship]
//                                                    complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
//                                                        [self updateGroupRelationShipDone:jsonDic];
//                                                    } failure:^(NSError *error, NSURLSessionDataTask *task) {
//         
//                                                    }];
//                        }];
//
//    }
//    
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                     NSLog(@"小组名称");
                    
                }
                    break;
                case 1:
                {
                    NSLog(@"小组历史聚会");
                    
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
                    
                    GroupHistroyPartyViewController *childController = [sb instantiateViewControllerWithIdentifier:@"GroupHistroyPartyViewController"];
                    [self.navigationController showViewController:childController sender:self];

                    
                }
                    break;
                case 2:
                {
                     NSLog(@"邀请好友加入");
                    
                }
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                     NSLog(@"聚会信息提示");
                    
                }
                    break;
                case 1:
                {
                     NSLog(@"聊天信息提示");
                    
                }
                    break;
                case 2:
                {
                    NSLog(@"公开手机号码");
                    
                }
                    break;
                    
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                {
                    NSLog(@"退出小组");
                    
                    [SRTool showSRAlertViewWithTitle:@"警告" message:@"真的要退出这个小组吗?"
                                   cancelButtonTitle:@"我再想想" otherButtonTitle:@"是的"
                               tapCancelButtonHandle:^(NSString *msgString) {
                                   
                               } tapOtherButtonHandle:^(NSString *msgString) {
                                   //确认发送
                                   _relationship.status = @0;
                                   _saveForQuit = YES;
                                   [SRNet_Manager requestNetWithDic:[SRNet_Manager updateGroupRelationShip:_relationship]
                                                           complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                                               [self updateGroupRelationShipDone:jsonDic];
                                                           } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                                               
                                                           }];
                               }];
                    

                }
                    break;

                    
                default:
                    break;
            }
            break;
            
            
        default:
            break;
    }
    
    
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    

    
}


@end
