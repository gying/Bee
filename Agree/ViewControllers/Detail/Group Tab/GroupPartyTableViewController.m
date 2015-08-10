//
//  GroupPartyTableViewController.m
//  Agree
//
//  Created by G4ddle on 15/1/24.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "GroupPartyTableViewController.h"
#import "SRNet_Manager.h"
#import "MJExtension.h"
#import <SVProgressHUD.h>
#import "GroupPartyTableViewCell.h"
#import "AppDelegate.h"
#import "CD_Party.h"
#import <MJRefresh.h>



@interface GroupPartyTableViewController ()


@end

@implementation GroupPartyTableViewController



- (void)reloadPartyData {
    [self.partyTableView reloadData];
}

- (void)reloadTipView: (NSInteger)aryCount {
    if (0 == aryCount) {
        [self.delegate.backView2 setHidden:NO];
        
    }else {
        [self.delegate.backView2 setHidden:YES];
    }
}

- (void)loadPartyData {
    self.partyArray = [CD_Party getPartyFromCDByGroup:self.group];
    [self reloadTipView:self.partyArray.count];
    [self.partyTableView reloadData];

    [SRNet_Manager requestNetWithDic:[SRNet_Manager getScheduleByGroupIDDic:self.group.pk_group
                                                                 withUserID:[Model_User loadFromUserDefaults].pk_user
                                                                  withRelID:self.group.pk_group_user]
                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                if (jsonDic) {
                                    //                [SVProgressHUD showSuccessWithStatus:@"读取数据成功"];
                                    [CD_Party removePartyFromCDByGroup:self.group];
                                    self.partyArray = (NSMutableArray *)[Model_Party objectArrayWithKeyValuesArray:jsonDic];
                                    [self reloadTipView:self.partyArray.count];
                                    [self.partyTableView reloadData];
                                    
                                    for (Model_Party *party in self.partyArray) {
                                        [CD_Party savePartyToCD:party];
                                    }
                                } else {
                                    [CD_Party removePartyFromCDByGroup:self.group];
                                    [self.partyArray removeAllObjects];
                                    [self.partyTableView reloadData];
                                    
                                }
                                [self.partyTableView.header endRefreshing];
                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                
                            }];
    
    [self.group setParty_update:@0];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.groupDelegate setDataChange:TRUE];
    
    
    
    



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.partyArray) {
        return self.partyArray.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"GroupScheduleCell";
    GroupPartyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    if (nil == cell) {
        cell = [[GroupPartyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    Model_Party *party = [self.partyArray objectAtIndex:indexPath.row];
    [cell initWithParty:party];
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.delegate.chooseParty = [self.partyArray objectAtIndex:indexPath.row];
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.partyTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)detailChange:(Model_Party *)party with:(int)type {
    for (Model_Party *theParty in self.partyArray) {
        if ([theParty.pk_party isEqualToString:party.pk_party]) {
            theParty.relationship = party.relationship;
        }
    }
    [self.partyTableView reloadData];
}

- (void)cancelParty:(Model_Party *)party with:(int)type {
    Model_Party *cancelParty;
    for (Model_Party *theParty in self.partyArray) {
        if ([theParty.pk_party isEqualToString:party.pk_party]) {
            cancelParty = theParty;
        }
    }
    [self.partyArray removeObject:cancelParty];
    //
    [self reloadTipView:self.partyArray.count];
    [self.partyTableView reloadData];
}



@end
