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

#import "MJExtension.h"

@implementation GroupPeopleTableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.relationshipAry) {
        return self.relationshipAry.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellIdentifier = @"PEOPLECELL";
    GroupPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    if (nil == cell) {
        cell = [[GroupPeopleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }

    Model_Group_User *relation = [self.relationshipAry objectAtIndex:indexPath.row];
    [cell initWithUser:relation];
    
    
    return cell;
    
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

@end
