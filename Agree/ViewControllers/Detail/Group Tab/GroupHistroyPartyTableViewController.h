//
//  GroupHistroyPartyTableViewController.h
//  Agree
//
//  Created by Agree on 15/8/10.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "Model_Group.h"
#import "SRNet_Manager.h"
#import "ScheduleViewController.h"
#import "GroupHistroyPartyViewController.h"
@interface GroupHistroyPartyTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray *schAry;
@property (nonatomic, strong)Model_Group *group;
@property (nonatomic, strong)GroupHistroyPartyViewController *rootController;
- (void)loadPartyData;

@end
