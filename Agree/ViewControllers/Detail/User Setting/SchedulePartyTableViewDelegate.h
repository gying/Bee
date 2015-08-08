//
//  CreatedPartyTableViewDelegate.h
//  Agree
//
//  Created by Agree on 15/7/16.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Model_Group.h"
#import "SRNet_Manager.h"
#import "ScheduleViewController.h"




@interface SchedulePartyTableViewDelegate : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray *schAry;
@property (nonatomic, strong)Model_Group *group;
@property (nonatomic, strong)ScheduleViewController *rootController;
- (void)loadPartyData;

@end
