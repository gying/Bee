//
//  GroupHistroyPartyTableViewController.m
//  Agree
//
//  Created by Agree on 15/8/10.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "GroupHistroyPartyTableViewDelegate.h"
#import "Model_Party.h"
#import "GroupPartyTableViewCell.h"
#import "MJExtension.h"
#import <MJRefresh.h>

#import "AllPartyTableViewCell.h"

@interface GroupHistroyPartyTableViewDelegate ()

@end

@implementation GroupHistroyPartyTableViewDelegate


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
    self.rootController.chooseRow = (int)indexPath.row;
    return indexPath;
}

#pragma mark - 业务逻辑
- (void)loadPartyData {
    Model_Group_User *sendRelation = [[Model_Group_User alloc] init];
    sendRelation.fk_group = self.rootController.group.pk_group;
    sendRelation.fk_user = [Model_User loadFromUserDefaults].pk_user;

    [SRNet_Manager requestNetWithDic:[SRNet_Manager getGroupPartyHistroy:sendRelation]
                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                if (jsonDic) {
                                    self.schAry = (NSMutableArray *)[Model_Party objectArrayWithKeyValuesArray:jsonDic];
                                    [self.rootController reloadTipView:self.schAry.count withType:1];
                                    [self.rootController.myGroupHistroyPartyTableView reloadData];
                                    
                                    
                                    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"party_update"];
                                } else {
                                    [self.schAry removeAllObjects];
                                    [self.rootController.myGroupHistroyPartyTableView reloadData];
                                }
                                
                                [self.rootController.myGroupHistroyPartyTableView.header endRefreshing];
                            }
                             failure:^(NSError *error, NSURLSessionDataTask *task) {
                                 [self.rootController.myGroupHistroyPartyTableView.header endRefreshing];
                             }];
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
