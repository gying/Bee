//
//  HistoryPartyTableViewDelegate.m
//  Agree
//
//  Created by Agree on 15/7/16.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "HistoryPartyTableViewDelegate.h"

#import "Model_Party.h"
#import "GroupPartyTableViewCell.h"

#import "MJExtension.h"
#import <MJRefresh.h>


@implementation HistoryPartyTableViewDelegate
{
    SRNet_Manager *_netManager;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Model_Party *theParty = [self.schAry objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"HISTORYPATYCELL";
    
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


- (void)loadPartyData {
    
    [self loadAllScheduleData];
    
}

#pragma mark - 业务逻辑
- (void)loadAllScheduleData {
    if (!_netManager) {
        _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
    }
    
    
    Model_User *user = [[Model_User alloc] init];
    user.pk_user = [Model_User loadFromUserDefaults].pk_user;
    [_netManager getPartyHistoryByUser:user];
    
}

- (void)interfaceReturnDataSuccess:(id)jsonDic with:(int)interfaceType {
    
    switch (interfaceType) {
        case kGetPartyHistory: {
            if (jsonDic) {
                self.schAry = (NSMutableArray *)[Model_Party objectArrayWithKeyValuesArray:jsonDic];
                [self.myPartyVC.historyPartyTableView reloadData];
                
                
            } else {
                
                [self.schAry removeAllObjects];
                [self.myPartyVC.historyPartyTableView reloadData];
                
            }
            
            [self.myPartyVC.historyPartyTableView.header endRefreshing];
        }
            break;
        default:
            break;
    }
}

- (void)interfaceReturnDataError:(int)interfaceType {
    
}


@end
