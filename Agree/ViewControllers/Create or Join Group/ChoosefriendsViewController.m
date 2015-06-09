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

#import "ContactsTableViewCell.h"

#import "SRAccountView.h"

#import "UserChatViewController.h"

#import "AppDelegate.h"

#import "EaseMob.h"


#import "SRMoveArray.h"





@interface ChoosefriendsViewController ()<SRNetManagerDelegate>

{
    NSInteger _selectIndex;
    NSMutableArray *_friendArray;
    SRNet_Manager *_netManager;
}

@end

@implementation ChoosefriendsViewController




- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor yellowColor];
    
    [self setTitle:@"选择好友"];
    [self loadDataFromNet];
    
    
    
    
    
}

- (void)loadDataFromNet {
    if (!_netManager) {
        _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
    }
    
    Model_User *sendUser = [[Model_User alloc] init];
    [sendUser setPk_user:[Model_User loadFromUserDefaults].pk_user];
    [_netManager getFriendList:sendUser];
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
//    [cell setTopViewController:self];
    

    
    return cell;
    
    

}

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    _selectIndex = indexPath.row;
//    return indexPath;
//}







- (void)interfaceReturnDataSuccess:(id)jsonDic with:(int)interfaceType {
    
 
    switch (interfaceType) {
        case kGetFriendList: {
            if (jsonDic) {
                //        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
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

- (void)interfaceReturnDataError:(int)interfaceType {
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
