//
//  GroupPeopleTableViewDelegate.m
//  Agree
//
//  Created by Agree on 15/8/7.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "GroupPeopleTableViewDelegate.h"
#import "GroupPeopleTableViewCell.h"
#import "SRNet_Manager.h"
#import <SVProgressHUD.h>
#import "Model_User.h"

#import "MJExtension.h"

@implementation GroupPeopleTableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (0 == section) {
        return 1;
    } else {
        if (self.relationshipAry) {
            return self.relationshipAry.count;
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.section) {
        //用户设置
        
        static NSString *kCellIdentifier = @"GroupSettingCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        }
        return cell;
    } else {
        //成员
        static NSString *kCellIdentifier = @"GroupPeopleCell";
        GroupPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
        if (nil == cell) {
            cell = [[GroupPeopleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        }
        Model_Group_User *relation = [self.relationshipAry objectAtIndex:indexPath.row];
        [cell initWithUser:relation];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.section) {
        //如果点击的是小组设置按钮
        
        
    } else {
        //点击的是小组成员
        Model_Group_User *relation = [self.relationshipAry objectAtIndex:indexPath.row];

        if (relation) {
            if (![[Model_User loadFromUserDefaults].pk_user isEqualToNumber:relation.fk_user]) {
                //点选的不是自己
                [self.rootController.accountView show];
                Model_User *sendUser = [[Model_User alloc] init];
                sendUser.pk_user = relation.fk_user;
                sendUser.nickname = relation.nickname;
                sendUser.avatar_path = relation.avatar_path;
                [self.rootController.accountView loadWithUser:sendUser withGroup:self.rootController.group];
            }
        }
    }
}

- (void)loadPeopleDataWithGroup: (Model_Group *)group {
    //读取小组全部的关系
    [SRNet_Manager requestNetWithDic:[SRNet_Manager getAllRelationFromGroupDic:group]
                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                if (jsonDic) {
                                    [SVProgressHUD dismiss];
                                    self.relationshipAry = (NSMutableArray *)[Model_Group_User objectArrayWithKeyValuesArray:jsonDic];
                                    [self.rootController.peopleTableView reloadData];
                                    
                                } else {
                                    
                                }
                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                
                            }];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        //设置
        return @"小组";
    } else {
        return @"成员";
    }
}

@end
