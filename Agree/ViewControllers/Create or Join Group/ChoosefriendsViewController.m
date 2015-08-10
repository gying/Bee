//
//  ChoosefriendsViewController.m
//  Agree
//
//  Created by Agree on 15/6/9.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "ChoosefriendsViewController.h"
#import "SRNet_Manager.h"
#import "MJExtension.h"
#import <SVProgressHUD.h>



#import "ChoosefriendsTableViewCell.h"
#import "SRAccountView.h"
#import "UserChatViewController.h"
#import "AppDelegate.h"
#import "EaseMob.h"
#import "SRMoveArray.h"





@interface ChoosefriendsViewController ()<UITableViewDelegate> {
    NSInteger _selectIndex;
    NSMutableArray *_friendArray;
}

@end

@implementation ChoosefriendsViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"选择好友"];
    [self loadDataFromNet];
}

- (void)loadDataFromNet {
    Model_User *sendUser = [[Model_User alloc] init];
    [sendUser setPk_user:[Model_User loadFromUserDefaults].pk_user];
    
    [SRNet_Manager requestNetWithDic:[SRNet_Manager getFriendListDic:sendUser]
                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                if (jsonDic) {
                                    _friendArray = (NSMutableArray *)[Model_User objectArrayWithKeyValuesArray:jsonDic];
                                } else {
                                    _friendArray = nil;
                                    _friendArray = [[NSMutableArray alloc] init];
                                }
                                
                                [SVProgressHUD dismiss];
                                [self.choosefriendsTableview reloadData];
                                
                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                
                            }];
}

#pragma mark - ChooseFriendsTableView的协议方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (_friendArray) {
        return _friendArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChoosefriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseFriends" forIndexPath:indexPath];
    
    if (nil == cell) {
        cell = [[ChoosefriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:@"ChooseFriends"];
    }
    Model_User *user = [_friendArray objectAtIndex:indexPath.row];
    [cell initWithUser:user];
    
    if ([self checkPeopleExist:user]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //选中的cell对象
    ChoosefriendsTableViewCell *cell = (ChoosefriendsTableViewCell *)[self.choosefriendsTableview cellForRowAtIndexPath:indexPath];
   
    Model_User *chooseUser = [_friendArray objectAtIndex:indexPath.row];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        //选定加入备选数组
        [self addPeopleToAry:chooseUser];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        //取消选定,从备选数组中删除
        [self removePeopleFromAry:chooseUser];
    }
    
    //如丝般顺滑
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 用户备选数组的操作方法

//添加用户进入备选数组
- (void)addPeopleToAry: (Model_User *) user {
    if (!self.choosePeopleArray) {
        self.choosePeopleArray = [[NSMutableArray alloc] init];
    }
    [self.choosePeopleArray addObject:user];
}

//将用户从备选数组中删除
- (void)removePeopleFromAry: (Model_User *) user {
    if (!self.choosePeopleArray) {
        return;
    }
    Model_User *delUser ;
    for (Model_User *chooseUser in self.choosePeopleArray) {
        if ([user.pk_user isEqual:chooseUser.pk_user]) {
            
            delUser = chooseUser;
        }
    }
    [self.choosePeopleArray removeObject:delUser];
}

//循环遍历,查看用户是否存在于数组中
- (BOOL)checkPeopleExist: (Model_User *) user {
    if (!self.choosePeopleArray) {
        return FALSE;
    }
    for (Model_User *chooseUser in self.choosePeopleArray) {
        if ([user.pk_user isEqual:chooseUser.pk_user]) {
            return TRUE;
        }
    }
    return FALSE;
}

//界面将要退出的时候,对父控制器进行被备选数组的赋值
- (void)viewWillDisappear:(BOOL)animated {
    self.rootController.choosePeopleArray = self.choosePeopleArray;
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tapBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)tapDoneButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
