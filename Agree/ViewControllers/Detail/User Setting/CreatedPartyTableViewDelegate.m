//
//  CreatedPartyTableViewDelegate.m
//  Agree
//
//  Created by Agree on 15/7/16.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "CreatedPartyTableViewDelegate.h"
#import "Model_Party.h"
#import "GroupPartyTableViewCell.h"
#import "MJExtension.h"
#import <MJRefresh.h>

#import "CreatedPartyDetailViewController.h"


@implementation CreatedPartyTableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Model_Party *theParty = [self.schAry objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"CREATEDPARTYCEll";
    
    GroupPartyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[GroupPartyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell initWithParty:theParty];
    return cell;
};

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.schAry.count) {
        return self.schAry.count;
    }
    return 0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.myPartyVC.chooseRow = (int)indexPath.row;
    return indexPath;
}

#pragma mark - 业务逻辑
- (void)loadPartyData {
    Model_User *user = [[Model_User alloc] init];
    user.pk_user = [Model_User loadFromUserDefaults].pk_user;
    [SRNet_Manager requestNetWithDic:[SRNet_Manager getCreatedPartyByUserDic:user]
                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                if (jsonDic) {
                                    self.schAry = (NSMutableArray *)[Model_Party objectArrayWithKeyValuesArray:jsonDic];
                                    [self.myPartyVC.createdPartyTableView reloadData];
                                } else {
                                    [self.schAry removeAllObjects];
                                    [self.myPartyVC.createdPartyTableView reloadData];
                                }
                                
                                [self.myPartyVC.createdPartyTableView.header endRefreshing];
                            }
                             failure:^(NSError *error, NSURLSessionDataTask *task) {
                                 [self.myPartyVC.createdPartyTableView.header endRefreshing];
                             }];
}

@end
