//
//  GroupPartyTableViewController.h
//  Agree
//
//  Created by G4ddle on 15/1/24.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_Group.h"
#import "GroupDetailViewController.h"
#import "PartyDetailViewController.h"

@interface GroupPartyTableViewController : UITableViewController <SRPartyDetailDelegate>



@property (nonatomic, strong)NSMutableArray *partyArray;
@property (nonatomic, strong)UITableView *partyTableView;
@property (nonatomic, strong)Model_Group *group;
@property (nonatomic, weak)GroupDetailViewController *delegate;

- (void)loadPartyData;
- (void)reloadPartyData;
@end
