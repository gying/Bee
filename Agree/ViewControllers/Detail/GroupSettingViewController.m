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

#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]

@interface GroupSettingViewController ()<UICollectionViewDelegate, UIActionSheetDelegate> {
    Model_Group_User *_relationship;
    UIImageView *_backImageViwe;
    
    NSMutableArray *_relationArray;
    BOOL _saveForQuit;
    SRAccountView *_accountView;
}

@end

@implementation GroupSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"小组信息读取中..." maskType:SVProgressHUDMaskTypeGradient];
    
    // Do any additional setup after loading the view.
    _accountView = [[SRAccountView alloc] init];
    _accountView.rootController = self;
    
    Model_Group_User *group_user = [[Model_Group_User alloc] init];
    [group_user setFk_group:self.group.pk_group];
    [group_user setFk_user:[Model_User loadFromUserDefaults].pk_user];
    
    _backImageViwe = [[UIImageView alloc] initWithFrame:CGRectMake(4.5, 4.5, 90, 90)];
//    _backImageViwe.backgroundColor = [UIColor redColor];
    
    [_backImageViwe.layer setMasksToBounds:YES];
    [_backImageViwe.layer setCornerRadius:_backImageViwe.frame.size.width/2];
    
    [SRImageManager avatarImageFromOSS:[Model_User loadFromUserDefaults].avatar_path];
    
    //读取个人与小组的关系
    [SRNet_Manager requestNetWithDic:[SRNet_Manager getGroupRelationshipDic:group_user]
                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                NSArray *relAry = jsonDic;
                                if (relAry) {
                                    _relationship = [[Model_Group_User objectArrayWithKeyValuesArray:relAry] objectAtIndex:0];
                                }
                                [self reloadButtonStatusSetting];
                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                
                            }];
    //读取小组全部的关系
    [SRNet_Manager requestNetWithDic:[SRNet_Manager getAllRelationFromGroupDic:self.group]
                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                if (jsonDic) {
                                    _relationArray = (NSMutableArray *)[Model_Group_User objectArrayWithKeyValuesArray:jsonDic];
                                    [self.peopleCollectionView reloadData];
                                    [SVProgressHUD showSuccessWithStatus:@"读取数据成功"];
                                } else {
                                    [SVProgressHUD showSuccessWithStatus:@"未找到相关数据"];
                                }
                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                
                            }];
    
}

- (void)reloadButtonStatusSetting {
    
    if (1 == _relationship.message_warn.intValue) {
        [self.chatTipButton setTitleColor:AgreeBlue forState:UIControlStateNormal];
        [self.chatTipLabel setText:@"已开启"];
    } else {
        [self.chatTipButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.chatTipLabel setText:@"已关闭"];
    }
    
    if (1 == _relationship.party_warn.intValue) {
        [self.partyTipButton setTitleColor:AgreeBlue forState:UIControlStateNormal];
        [self.partyTipLabel setText:@"已开启"];
    } else {
        [self.partyTipButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.partyTipLabel setText:@"已关闭"];
    }
    
    if (1 == _relationship.public_phone.intValue) {
        [self.phoneButton setTitleColor:AgreeBlue forState:UIControlStateNormal];
        [self.phoneLabel setText:@"已公开"];
    } else {
        [self.phoneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.phoneLabel setText:@"未公开"];
    }
}

- (IBAction)pressedTheCodeButton:(UIButton *)sender {
    Model_Group *theGroup = [[Model_Group alloc] init];
    theGroup.pk_group = self.group.pk_group;

    [SRNet_Manager requestNetWithDic:[SRNet_Manager generationCodeByGroupDic:theGroup]
                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                if (jsonDic) {
                                    if ([jsonDic isKindOfClass:[NSString class]]) {
                                        [self.codeButton setTitle:jsonDic forState:UIControlStateNormal];
                                        [self.codeRemarkLabel setText:@""];
                                    } else {
                                        NSArray *codeObjArray = [Model_Group_Code objectArrayWithKeyValuesArray:jsonDic];
                                        for (Model_Group_Code *theCodeObj in codeObjArray) {
                                            if (1 != [theCodeObj.code_status intValue]) {
                                                //                        [self.codeLabel setText:theCodeObj.pk_group_code];
                                                [self.codeButton setTitle:theCodeObj.pk_group_code forState:UIControlStateNormal];
                                                [self.codeRemarkLabel setText:@""];
                                            }
                                        }
                                    }
                                }
                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                
                            }];
    
}
- (IBAction)pressedTheExitButton:(id)sender {
    UIAlertView *warnImageAlert = [[UIAlertView alloc] initWithTitle:@"警告"
                                                             message:@"是否确认要退出小组?"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@"确认", nil];
    [warnImageAlert show];
}

- (IBAction)pressedThePartyButton:(UIButton *)sender {
    if (1 == _relationship.party_warn.intValue) {
        [_relationship setParty_warn:[NSNumber numberWithInt:0]];
    } else {
        [_relationship setParty_warn:[NSNumber numberWithInt:1]];
    }
    [self reloadButtonStatusSetting];
    
    _saveForQuit = true;
}

- (IBAction)pressedTheChatButton:(UIButton *)sender {
    if (1 == _relationship.message_warn.intValue) {
        [_relationship setMessage_warn:[NSNumber numberWithInt:0]];
    } else {
        [_relationship setMessage_warn:[NSNumber numberWithInt:1]];
    }
    [self reloadButtonStatusSetting];
    
    _saveForQuit = true;
}

- (IBAction)pressedThePhoneButton:(UIButton *)sender {
    if (1 == _relationship.public_phone.intValue) {
        [_relationship setPublic_phone:[NSNumber numberWithInt:0]];
    } else {
        [_relationship setPublic_phone:[NSNumber numberWithInt:1]];
    }
    [self reloadButtonStatusSetting];
    
    _saveForQuit = true;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_relationArray) {
        return _relationArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GroupPeopleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GroupPeopleCell" forIndexPath:indexPath];
    
    
    Model_Group_User *relation = [_relationArray objectAtIndex:indexPath.row];
    [cell initWithGroupUser:relation];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Model_Group_User *relation = [_relationArray objectAtIndex:indexPath.row];
    
    if (![relation.fk_user isEqual:[Model_User loadFromUserDefaults].pk_user]) {
        Model_User *chooseUser = [[Model_User alloc] init];
        chooseUser.pk_user = relation.fk_user;
        chooseUser.nickname = relation.nickname;
        chooseUser.avatar_path = relation.avatar_path;
        [_accountView loadWithUser:chooseUser withGroup:self.group];
        [_accountView show];
    }
}

- (IBAction)tapSaveButton:(id)sender {
    _saveForQuit = NO;
    
    [SRNet_Manager requestNetWithDic:[SRNet_Manager updateGroupRelationShip:_relationship]
                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                [self updateGroupRelationShipDone:jsonDic];
                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                
                            }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (0 == buttonIndex) {
        //取消发送
    } else {
        //确认发送
        _relationship.status = @0;
        _saveForQuit = YES;
        [SRNet_Manager requestNetWithDic:[SRNet_Manager updateGroupRelationShip:_relationship]
                                complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                    [self updateGroupRelationShipDone:jsonDic];
                                } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                    
                                }];
    }
}

- (IBAction)tapBackButton:(id)sender {
    if (_saveForQuit) {
        //资料已更改
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"小组信息已更改" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存退出" otherButtonTitles:@"不保存退出", nil];
        [sheet showInView:self.view];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
  
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //退出界面选择
    if (0 == buttonIndex) {
        //保存退出
        _saveForQuit = NO;
        [SRNet_Manager requestNetWithDic:[SRNet_Manager updateGroupRelationShip:_relationship]
                                complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                    [self updateGroupRelationShipDone:jsonDic];
                                } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                    
                                }];
        [self.navigationController popViewControllerAnimated:YES];
    } else if (1 == buttonIndex) {
        //直接退出
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        return;
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

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}


@end
