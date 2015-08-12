//
//  CreatedPartyTableViewDelegate.m
//  Agree
//
//  Created by Agree on 15/7/16.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "SchedulePartyTableViewDelegate.h"
#import "Model_Party.h"
#import "GroupPartyTableViewCell.h"
#import "MJExtension.h"
#import <MJRefresh.h>

#import "AllPartyTableViewCell.h"


@implementation SchedulePartyTableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Model_Party *theParty = [self.schAry objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"ALLSCHEDULECELL";
    
    AllPartyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[AllPartyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell initWithParty:theParty];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.schAry.count) {
        return self.schAry.count;
    }
    return 0;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    self.myPartyVC.chooseRow = (int)indexPath.row;
    self.rootController.chooseRow = (int)indexPath.row;
    return indexPath;
}

#pragma mark - 业务逻辑
- (void)loadPartyData {
    Model_User *user = [[Model_User alloc] init];
    user.pk_user = [Model_User loadFromUserDefaults].pk_user;
    [SRNet_Manager requestNetWithDic:[SRNet_Manager getAllScheduleByUserDic:user]
                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                if (jsonDic) {
                                    self.schAry = (NSMutableArray *)[Model_Party objectArrayWithKeyValuesArray:jsonDic];
                                    [self.rootController reloadTipView:self.schAry.count withType:1];
                                    [self.rootController.myScheduleTableView reloadData];

                                    
                                    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"party_update"];
                                } else {
                                    [self.schAry removeAllObjects];
                                    [self.rootController.myScheduleTableView reloadData];
                                }
                                
                                [self.rootController.myScheduleTableView.header endRefreshing];
                            }
                             failure:^(NSError *error, NSURLSessionDataTask *task) {
                                 [self.rootController.myScheduleTableView.header endRefreshing];
                             }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //设置分组的标签区域高度为0
    return 0.00001f;
    
}

@end
