//
//  GroupHistroyTableViewController.h
//  Agree
//
//  Created by Agree on 15/8/8.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>


#import "Model_Group.h"

#import "SRNet_Manager.h"


@interface GroupHistroyTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property BOOL loadAgain;
@property (nonatomic, strong)NSMutableArray *schAry;
@property (nonatomic, strong)Model_Group *group;


- (void)loadPartyData;
- (void)refresh: (id)sender;

@end
