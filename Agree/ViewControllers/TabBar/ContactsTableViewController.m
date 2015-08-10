//
//  ContactsTableViewController.m
//  Agree
//
//  Created by G4ddle on 15/3/16.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "ContactsTableViewController.h"

#import "SRNet_Manager.h"
#import "MJExtension.h"
#import <SVProgressHUD.h>
#import "ContactsTableViewCell.h"
#import "SRAccountView.h"
#import "UserChatViewController.h"
#import "AppDelegate.h"

#import "EaseMob.h"
#import "SRMoveArray.h"
#import <MJRefresh.h>
#import "SRImageManager.h"

#import "PartyDetailViewController.h"

#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]
@interface ContactsTableViewController (){
    NSMutableArray *_friendArray;
    SRAccountView *_accountView;
    NSInteger _selectIndex;
    BOOL _isfirstLoad;
    
    BOOL _intoMessage;
    Model_User *_intoUser;
    
    UIView * _backView;
    UILabel * _textLabel;
}

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backView];

    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.accountView = [[SRAccountView alloc] init];
    self.accountView.rootController = self;
    
    [self.updateView.layer setCornerRadius:self.updateView.frame.size.height/2];
    [self.updateView.layer setMasksToBounds:YES];
    
    _isfirstLoad = TRUE;
    [self reloadTipView:_friendArray.count];
    [self loadDataFromNet];
    
    
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh:)];
}

-(void)backView
{
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_backView];
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height - 180, 100, 40)];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.text = @"请添加好友";
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.textColor = AgreeBlue;
    [_backView addSubview:_textLabel];
}

- (void)reloadTipView: (NSInteger)aryCount {
    if (0 == aryCount) {
        [_backView setHidden:NO];
        
    }else {
        [_backView setHidden:YES];
    }
}

- (void)refresh:(id)sender {
    _isfirstLoad = TRUE;
    [self loadDataFromNet];

}

- (void)loadDataFromNet {
    Model_User *sendUser = [[Model_User alloc] init];
    [sendUser setPk_user:[Model_User loadFromUserDefaults].pk_user];
    
    [SRNet_Manager requestNetWithDic:[SRNet_Manager getFriendListDic:sendUser]
                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                if (jsonDic) {
                                    //        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                                    NSMutableArray *tempArray = (NSMutableArray *)[Model_User objectArrayWithKeyValuesArray:jsonDic];
                                    
                                    _friendArray = nil;
                                    _friendArray = [[NSMutableArray alloc] init];
                                    
                                    for (Model_User *user in tempArray) {  //循环标记用户未读取的信息
                                        EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:user.pk_user.stringValue conversationType:eConversationTypeChat];
                                        user.chat_update = [NSNumber numberWithLong:conversation.unreadMessagesCount];
                                        
                                        if (0 != user.chat_update.integerValue) {
                                            [_friendArray insertObject:user atIndex:0];
                                        } else {
                                            [_friendArray addObject:user];
                                        }
                                        [self reloadTipView:_friendArray.count];
                                    }
                                    
                                } else {
                                    _friendArray = nil;
                                    _friendArray = [[NSMutableArray alloc] init];
                                }
                                
                                [self.tableView reloadData];
                                [self reloadTipView:_friendArray.count];
                                [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"contact_update"];
                                [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"relation_update"];
                                self.navigationController.tabBarItem.badgeValue = nil;
                                [self.tableView.header endRefreshing];
                                _isfirstLoad = FALSE;
                                
                                if (_intoMessage) {
                                    //        UserChatViewController *childController = [[UserChatViewController alloc] init];
                                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
                                    UserChatViewController *childController = [sb instantiateViewControllerWithIdentifier:@"UserChatView"];
                                    
                                    Model_User *sendUser;
                                    for (Model_User *user in _friendArray) {
                                        if ([user.pk_user isEqualToNumber:_intoUser.pk_user]) {
                                            sendUser = user;
                                        }
                                    }
                                    if (sendUser) {
                                        sendUser.chat_update = 0;
                                        [self.tableView reloadData];
                                        childController.user = sendUser;
                                        [self.navigationController pushViewController:childController animated:YES];
                                    }
                                }
                                
                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                
                            }];
}

- (void)viewDidAppear:(BOOL)animated {
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"contact_update"] isEqualToNumber:@0] || ![[[NSUserDefaults standardUserDefaults] objectForKey:@"relation_update"] isEqualToNumber:@0]) {
        //信息有更新
        
        if (!_isfirstLoad) {
            [self loadDataFromNet];
        }
    }
    
    [self.navigationController.tabBarItem setBadgeValue:nil];
    
    NSNumber *updateValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"relation_update"];
    if ([updateValue isEqual:@0]) {
        [self.updateView setHidden:YES];
    } else {
        [self.updateView setHidden:NO];
    }
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate setContactsDelegate:self];
    [super viewDidAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate setContactsDelegate:nil];
    [super viewWillDisappear:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (_friendArray) {
        return _friendArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsCell" forIndexPath:indexPath];
    
    if (nil == cell) {
        cell = [[ContactsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:@"ContactsCell"];
    }
    Model_User *user = [_friendArray objectAtIndex:indexPath.row];
    [cell initWithUser:user];
    [cell setTopViewController:self];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击好友开启私聊
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectIndex = indexPath.row;
    return indexPath;
}

- (void)reloadTableViewAndUnreadData {
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:_friendArray];
    _friendArray = nil;
    _friendArray = [[NSMutableArray alloc] init];
    
    for (Model_User *user in tempArray) {  //循环标记用户未读取的信息
        EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:user.pk_user.stringValue conversationType:eConversationTypeChat];
        user.chat_update = [NSNumber numberWithLong:conversation.unreadMessagesCount];
        
        if (0 != user.chat_update.integerValue) {
            [_friendArray insertObject:user atIndex:0];
        } else {
            [_friendArray addObject:user];
        }
    }
    [self.tableView reloadData];
}

- (void)intoMessage: (Model_User *)user {
    _intoUser = user;
    _intoMessage = YES;
    if (_friendArray) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
        UserChatViewController *childController = [sb instantiateViewControllerWithIdentifier:@"UserChatView"];
        
        Model_User *sendUser;
        for (Model_User *user in _friendArray) {
            if ([user.pk_user isEqualToNumber:_intoUser.pk_user]) {
                sendUser = user;
            }
        }
        if (sendUser) {
            sendUser.chat_update = 0;
            [self.tableView reloadData];
            childController.user = sendUser;
            [self.navigationController pushViewController:childController animated:YES];
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([@"GotoUserChat" isEqualToString:segue.identifier]) {
        //清空用户聊天的更新资料
        Model_User *user = [_friendArray objectAtIndex:_selectIndex];
        user.chat_update = 0;
        [self.tableView reloadData];
        
        UserChatViewController *childController = segue.destinationViewController;
//        [childController setRootController:self];
        childController.user = user;
    }
}


@end
