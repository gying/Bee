//
//  ScheduleTableViewController.h
//  SRAgree
//
//  Created by G4ddle on 14/12/16.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#import "Model_Group.h"

#import "SRNet_Manager.h"

#import "MyPartyViewController.h"



@interface ScheduleTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property BOOL loadAgain;
@property (nonatomic, strong)NSMutableArray *schAry;
@property (nonatomic, strong)Model_Group *group;
@property (nonatomic,strong)MyPartyViewController * myPartyVC;

- (void)loadPartyData;
- (void)refresh: (id)sender;

@end
