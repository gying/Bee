//
//  GroupPeopleTableViewDelegate.h
//  Agree
//
//  Created by Agree on 15/8/7.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GroupDetailViewController.h"

@interface GroupPeopleTableViewDelegate : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray *relationshipAry;
@property (nonatomic, strong)GroupDetailViewController *rootController;

- (void)loadPeopleDataWithGroup: (Model_Group *)group;

@end
