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
#import "ProgressHUD.h"
#import "GroupPartyTableViewCell.h"
#import "AppDelegate.h"


@interface GroupPartyTableViewController () <SRNetManagerDelegate> {
    SRNet_Manager *_netManager;
}

@end

@implementation GroupPartyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)reloadPartyData {
    [self.partyTableView reloadData];
}

- (void)loadPartyData {
    if (!_netManager) {
        _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
    }
    [_netManager getScheduleByGroupID:self.group.pk_group withUserID:[Model_User loadFromUserDefaults].pk_user withRelID:self.group.pk_group_user];
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

- (void)interfaceReturnDataSuccess:(id)jsonDic with:(int)interfaceType {
    
    switch (interfaceType) {
        case kGetScheduleByGroupID: {
            if (jsonDic) {
                self.partyArray = (NSMutableArray *)[Model_Party objectArrayWithKeyValuesArray:jsonDic];
                [self.partyTableView reloadData];
                [ProgressHUD showSuccess:@"读取数据成功"];
            } else {
                [ProgressHUD showSuccess:@"未找到相关数据"];
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)interfaceReturnDataError:(int)interfaceType {
    [ProgressHUD showError:@"网络错误"];
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

- (void)DetailChange:(Model_Party *)party {
    for (Model_Party *theParty in self.partyArray) {
        if ([theParty.pk_party isEqualToString:party.pk_party]) {
            theParty.relationship = party.relationship;
        }
    }
    [self.partyTableView reloadData];
}

- (void)cancelParty:(Model_Party *)party {
    Model_Party *cancelParty;
    for (Model_Party *theParty in self.partyArray) {
        if ([theParty.pk_party isEqualToString:party.pk_party]) {
            cancelParty = theParty;
        }
    }
    [self.partyArray removeObject:cancelParty];
    [self.partyTableView reloadData];
}


@end
