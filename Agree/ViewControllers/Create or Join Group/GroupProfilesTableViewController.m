//
//  GroupProfilesTableViewController.m
//  Agree
//
//  Created by G4ddle on 15/8/12.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "GroupProfilesTableViewController.h"
#import "UIButton+WebCache.h"
#import "SRImageManager.h"
#import <EaseMob.h>
#import "Model_Group_User.h"
#import "Model_User.h"
#import "SRNet_Manager.h"
#import "GroupViewController.h"
#import <SVProgressHUD.h>

@interface GroupProfilesTableViewController () {
    NSArray *_profilesAry;
    BOOL _pubilcationPhone;
}

@end

@implementation GroupProfilesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.coverButton.layer.cornerRadius = 3.0f;
    
    if (self.group) {
        //下载图片
        NSURL *imageUrl = [SRImageManager groupFrontCoverImageImageFromOSS:self.group.avatar_path];
        [self.coverButton sd_setBackgroundImageWithURL:imageUrl forState:UIControlStateNormal];
        
        [self.groupName setText:self.group.name];
    }
    
    
    _profilesAry = @[@[@"人数", @"介绍"], @[@"是否公开手机号"], @[@"加入小组"]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return _profilesAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSArray *itemsAry = [_profilesAry objectAtIndex:section];
    return itemsAry.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return @"小组资料";
        }
            break;
        case 1: {
            return @"个人信息";
        }
            break;
        case 2: {
            return @"操作";
        }
            break;
        default:
            return nil;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupProfilesCell" forIndexPath:indexPath];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GroupProfilesCell"];
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
    NSArray *itemsAry = [_profilesAry objectAtIndex:indexPath.section];
    cell.textLabel.text = [itemsAry objectAtIndex:indexPath.row];
    
    if (1 == indexPath.section) {
        //个人信息操作
        //这里暂时只有一行,直接操作
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 1: {
            //个人信息操作
            //这里暂时只有一行,直接操作
            UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
            
            if (UITableViewCellAccessoryCheckmark != selectedCell.accessoryType) {
                [selectedCell setAccessoryType:UITableViewCellAccessoryCheckmark];
                _pubilcationPhone = YES;
            } else {
                [selectedCell setAccessoryType:UITableViewCellAccessoryNone];
                _pubilcationPhone = NO;
            }
        }
            break;
        case 2: {
            //是否加入小组操作
            //这里暂时只有一行,直接操作
            
            [self joinGroupRelation];
            
        }
            break;
        default:
            break;
    }
}

- (void)joinGroupRelation {
    [[EaseMob sharedInstance].chatManager asyncJoinPublicGroup:self.group.em_id completion:^(EMGroup *group, EMError *error) {
        if (!error || [error.description isEqualToString:@"Group has already joined."]) {
            //将创建者加入关系
            Model_Group_User *group_user = [[Model_Group_User alloc] init];
            [group_user setFk_group:self.group.pk_group];
            [group_user setFk_user:[Model_User loadFromUserDefaults].pk_user];
            //1.创建者 2.普通成员
            [group_user setRole:[NSNumber numberWithInt:2]];
            if (_pubilcationPhone) {
                [group_user setPublic_phone:@1];
            } else {
                [group_user setPublic_phone:@0];
            }
            [SRNet_Manager requestNetWithDic:[SRNet_Manager joinGroupDic:group_user]
                                    complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                        //这里需要调用根控制器的刷新方法,以刷新加入内容
                                        //这里默认根目录为全部小组页面,并对根控制器进行直接获取
                                        GroupViewController *rootController = [self.navigationController.viewControllers objectAtIndex:0];
                                        [rootController loadUserGroupRelationship];
                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                        [SVProgressHUD showSuccessWithStatus:@"加入小组成功"];
                                    } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                        
                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                        [SVProgressHUD showErrorWithStatus:@"加入小组失败"];
                                    }];
        }
    } onQueue:nil];
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
