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





@interface ChoosefriendsViewController ()<SRNetManagerDelegate,UITableViewDelegate>

{
    NSInteger _selectIndex;
    NSMutableArray *_friendArray;
    SRNet_Manager *_netManager;
    
//    ChoosefriendsTableViewCell *cell;
}

@end

@implementation ChoosefriendsViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"选择好友"];
    [self loadDataFromNet];
    
//    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    
//    [self.choosefriendsTableview setEditing:YES];
    
    [self.choosefriendsTableview setEditing:YES];
    
    
    
    
    
    
    
    
}

- (void)loadDataFromNet
{
    if (!_netManager) {
        _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
    }
    Model_User *sendUser = [[Model_User alloc] init];
    [sendUser setPk_user:[Model_User loadFromUserDefaults].pk_user];
    [_netManager getFriendList:sendUser];
}

#pragma mark - ChooseFriendsTableView的代理

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

    ;
    
    
    
    return cell;
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 3;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"1111");
//    
//    ChoosefriendsTableViewCell *cell = (ChoosefriendsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//   
//    
//    cell.selected = !cell.selected;
//
//////    if (1 == cell.tag) {
//////        cell.tag = 0;
//////        cell.selected = false;
//////    }else {
//////        cell.tag = 1;
//////        cell.selected = YES;
//////    }
////    
////    cell.selected = !cell.selected;
//
////    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
////        cell.accessoryType = UITableViewCellAccessoryNone;
////    } else {
////        cell.accessoryType = UITableViewCellAccessoryCheckmark;
////    }
//
//    
//}

- (void)interfaceReturnDataSuccess:(id)jsonDic with:(int)interfaceType
{
    switch (interfaceType) {
        case kGetFriendList: {
            if (jsonDic) {
                _friendArray = (NSMutableArray *)[Model_User objectArrayWithKeyValuesArray:jsonDic];
            } else {
                _friendArray = nil;
                _friendArray = [[NSMutableArray alloc] init];
            }
        }
            break;
        default:
            break;
    }
    [SVProgressHUD dismiss];
    [self.choosefriendsTableview reloadData];
    
}
- (void)interfaceReturnDataError:(int)interfaceType
{
    [SVProgressHUD showErrorWithStatus:@"网络错误"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
