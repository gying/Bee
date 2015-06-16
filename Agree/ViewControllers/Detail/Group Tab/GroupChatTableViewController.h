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
@property (nonatomic, strong)NSMutableArray *mchatArray;

//初始加载消息页数以及条数
@property (nonatomic, assign)    int page;
@property (nonatomic , assign)     int pageSize;



@property (nonatomic, strong)Model_Group *group;
@property (nonatomic, strong)UITableView *chatTableView;
@property (nonatomic, strong)GroupDetailViewController *rootController;

@property (nonatomic, strong)UITableViewCell * longTapCell;


@property (nonatomic, strong)Model_Group_User*user;



- (void)loadChatData;
//- (void)loadChatFromNet;
//- (void)setkeyBoard: (UIViewController *)viewController;
- (void)subChatArray;


@end
