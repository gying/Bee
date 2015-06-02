//
//  GroupChatTableViewController.h
//  Agree
//
//  Created by G4ddle on 15/1/19.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_Group.h"
#import "GroupDetailViewController.h"

@interface GroupChatTableViewController : UITableViewController

@property (nonatomic, strong)NSMutableArray *chatArray;
@property (nonatomic, strong)Model_Group *group;
@property (nonatomic, strong)UITableView *chatTableView;
@property (nonatomic, strong)GroupDetailViewController *rootController;

- (void)loadChatData;
//- (void)loadChatFromNet;
//- (void)setkeyBoard: (UIViewController *)viewController;


@end
