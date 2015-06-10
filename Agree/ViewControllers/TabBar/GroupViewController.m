//
//  GroupViewController.m
//  Agree
//
//  Created by G4ddle on 15/2/14.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "GroupViewController.h"
#import "GroupCollectionViewCell.h"
#import <SVProgressHUD.h>
#import "MJExtension.h"
#import "GroupDetailViewController.h"
#import "SRTool.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"








#import "EaseMob.h"

@interface GroupViewController () <UICollectionViewDelegate, UICollectionViewDataSource, SRNetManagerDelegate, UITextFieldDelegate, IChatManagerDelegate> {
    SRNet_Manager *_netManager;
//    NSArray *_groupAry;
    NSUInteger _chooseIndexPath;
    
    GroupChatTableViewController * GCTC;
    
    
}


@end

@implementation GroupViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!_netManager) {
        _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
    }
    [self loadUserGroupRelationship];
    
//    CGRect wRect = [[UIScreen mainScreen] bounds];
    [self.codeInputTextField setDelegate:self];
    
    //在程序的代理中进行注册
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate setGroupDelegate:self];
    
    
    //注册代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    if ([Model_User loadFromUserDefaults].pk_user) {
        //开始自动登录
        //自动设置并判断登录
        BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
        if (!isAutoLogin) {
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[Model_User loadFromUserDefaults].pk_user.stringValue
                                                                password:@"paopian"
                                                              completion:^(NSDictionary *loginInfo, EMError *error) {
                                                                  if (!error) {
                                                                      //设置自动登录
                                                                      //登录成功
                                                                      [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                                                                  }
                                                              } onQueue:nil];
        }
    }
    
//    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
}

/*!
 @method
 @brief 用户自动登录完成后的回调
 @discussion
 @param loginInfo 登录的用户信息
 @param error     错误信息
 @result
 */
- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error; {
}


- (void)viewWillAppear:(BOOL)animated {
    [self refreshUpdateInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.codeView setHidden:YES];
    
    [self pressedTheRecodeButton:nil];
    [self.codeInputTextField setText:nil];
    [self.codeInputTextField resignFirstResponder];
}

- (void)refreshUpdateInfo {
    if (self.dataChange) {
        [self.groupCollectionView reloadData];
        self.dataChange = FALSE;
    }
}

- (void)cleanAllPartyUpdate {
    for (Model_Group *group in self.groupAry) {
        [group setParty_update:@0];
    }
    self.dataChange = TRUE;
    [self refreshUpdateInfo];
}

- (void)addGroupChatUpdateStatus: (NSString *)em_id {
    for (Model_Group *group in self.groupAry) {
        if ([em_id isEqualToString:group.em_id]) {
            group.chat_update = [NSNumber numberWithInt:(group.chat_update.intValue + 1)];
            self.dataChange = TRUE;
        }
    }
    [self refreshUpdateInfo];
}

- (void)addGroupPartyUpdateStatus: (NSNumber *)pk_group {
    for (Model_Group *group in self.groupAry) {
        if ([pk_group isEqualToNumber:group.pk_group]) {
            group.party_update = [NSNumber numberWithInt:(group.party_update.intValue + 1)];
            self.dataChange = TRUE;
        }
    }
    [self refreshUpdateInfo];
}

- (void)loadUserGroupRelationship {
    Model_User *user = [[Model_User alloc] init];
    user.pk_user = [Model_User loadFromUserDefaults].pk_user;
    
    [_netManager getUserGroups:user];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.groupAry) {
        return self.groupAry.count + 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GroupCollectionCell" forIndexPath:indexPath];
    if (indexPath.row == self.groupAry.count) {
        //最后一条信息
        //添加聚会按钮
        [cell initAddView];
    } else {
        
        
        Model_Group *theGroup = [self.groupAry objectAtIndex:indexPath.row];
        
        EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:theGroup.em_id isGroup:YES];
        [theGroup setChat_update:[NSNumber numberWithInteger:conversation.unreadMessagesCount]];
        [cell initCellWithGroup:theGroup];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionFooter){
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerView;
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float widthFloat = ([[UIScreen mainScreen] bounds].size.width - 3)/2;
    return CGSizeMake(widthFloat, widthFloat);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _chooseIndexPath = indexPath.row;
    return TRUE;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (_chooseIndexPath == self.groupAry.count) {
        //新建页面
        [self performSegueWithIdentifier:@"CreateGroup" sender:self];
        _chooseIndexPath = 0;
        return NO;
    }
    if ([identifier isEqualToString:@"CreateGroup"]) {
        if (!self.codeView.hidden) {
            //正在输入邀请码
            self.codeView.hidden = YES;
            [self.codeInputTextField resignFirstResponder];
            [self.createButton setTitle:@"新建" forState:UIControlStateNormal];
            return NO;
        } else {
            return YES;
        }
    }
    
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //进入小组详情
    if ([@"GroupDetail"  isEqual: segue.identifier]) {
        //读取小组详情数据并赋值小组数据
        GroupDetailViewController *controller = (GroupDetailViewController *)segue.destinationViewController;
        controller.group = [self.groupAry objectAtIndex:_chooseIndexPath];
    }
}

- (IBAction)pressedCodeButton:(id)sender {
    if (self.codeView.hidden) {
        self.codeView.hidden = NO;
        [self.codeInputTextField becomeFirstResponder];
        [self.createButton setTitle:@"关闭" forState:UIControlStateNormal];
    } else {
        self.codeView.hidden = YES;
        [self.createButton setTitle:@"新建" forState:UIControlStateNormal];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //验证码输入界面
    if (!_netManager) {
        _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
    }
    Model_Group_Code *newCode = [[Model_Group_Code alloc] init];
    newCode.pk_group_code = textField.text;
    [_netManager joinTheGroupByCode:newCode];
    
    [textField resignFirstResponder];

    return YES;
}
- (IBAction)pressedCodeBackButton:(id)sender {
    [self.codeInputTextField resignFirstResponder];
    [self.codeView setHidden:YES];
    [self.createButton setTitle:@"新建" forState:UIControlStateNormal];
}

- (void)joinGroupRelation {
    [[EaseMob sharedInstance].chatManager asyncJoinPublicGroup:self.joinGroup.em_id completion:^(EMGroup *group, EMError *error) {
        if (!error || [error.description isEqualToString:@"Group has already joined."]) {
            //将创建者加入关系
            Model_Group_User *group_user = [[Model_Group_User alloc] init];
            [group_user setFk_group:self.joinGroup.pk_group];
            [group_user setFk_user:[Model_User loadFromUserDefaults].pk_user];
            //1.创建者 2.普通成员
            [group_user setRole:[NSNumber numberWithInt:2]];
            if (self.needPublicPhone) {
                [group_user setPublic_phone:@1];
            } else {
                [group_user setPublic_phone:@0];
            }
            
            [_netManager joinGroup:group_user];
        }
    } onQueue:nil];
    
    [self.codeView setHidden:YES];
    [self.createButton setTitle:@"新建" forState:UIControlStateNormal];
}


- (IBAction)pressedTheJoinButton:(id)sender {
    if (0 == self.publicPhoneSeg.selectedSegmentIndex) {
        //公开
        self.needPublicPhone = YES;
    } else {
        //不公开
        self.needPublicPhone = NO;
    }
    [self joinGroupRelation];
}


//新建小组BUTTON
- (IBAction)pressedTheRecodeButton:(id)sender {
    //重新输入验证码
    [self.groupNameLabel setText:@""];
    [self.groupCoverImageView setImage:nil];
    
    [self.groupCoverImageView setHidden:YES];
    [self.groupNameLabel setHidden:YES];
    [self.recodeButton setHidden:YES];
    [self.joinButton setHidden:YES];
    [self.publicPhoneLabel setHidden:YES];
    [self.publicPhoneSeg setHidden:YES];
    
    [self.codeInputTextField setHidden:NO];
//    [self.groupCoverButton setHidden:NO];
    [self.remarkLabel setHidden:NO];
    
#pragma mark 小组图像点击BUTTON位置（稍后删除）
    

    NSLog(@"小组图像点击BUTTON");
    NSLog(@"新建小组点击BUTTON");
    
//    //聊天信息切换到最底层显示
//    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:messages.count-1  inSection:0];
//    [self tableViewIsScrollToBottom:YES withAnimated:NO];
//    
//    [self.userChatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    
//    [_conversation markAllMessagesAsRead:YES];
    

    
    
    
    
    



    
    
    if (sender) {
        [self.codeInputTextField becomeFirstResponder];
    }
}

#pragma mark - Net Manager Delegate
- (void)interfaceReturnDataError:(int)interfaceType {
    [SVProgressHUD showErrorWithStatus:@"网络错误"];
}

- (void)interfaceReturnDataSuccess:(id)jsonDic with:(int)interfaceType {
    
    switch (interfaceType) {
        case kJoinGroup: {  //加入小组
            [self loadUserGroupRelationship];
        }
            break;
            
        case kJoinTheGroupByCode: { //输入小组验证码
            if (jsonDic) {
                [SVProgressHUD showSuccessWithStatus:@"找到小组"];
                self.joinGroup = [[Model_Group objectArrayWithKeyValuesArray:jsonDic] firstObject];
                
                //显示要加入的小组
                [self.groupCoverImageView setHidden:NO];
                [self.groupNameLabel setHidden:NO];
                [self.recodeButton setHidden:NO];
                [self.joinButton setHidden:NO];
                [self.publicPhoneLabel setHidden:NO];
                [self.publicPhoneSeg setHidden:NO];
                
                [self.codeInputTextField setHidden:YES];
                //            [self.groupCoverButton setHidden:YES];
                [self.remarkLabel setHidden:YES];
                
                [self.groupNameLabel setText:_joinGroup.name];
                [self.groupCoverImageView setImageWithURL:[SRTool imageUrlFromPath:_joinGroup.avatar_path]];
            } else {
                [SVProgressHUD showSuccessWithStatus:@"未找到相关数据"];
                //未找到小组的相关数据
                [self.remarkLabel setText:@"未找到小组信息,请再次确认输入"];
                [self.codeInputTextField becomeFirstResponder];
            }
        }
            break;
            
        case kGetUserGroups: {  //读取用户的小组
            if (jsonDic) {
                self.groupAry = [Model_Group objectArrayWithKeyValuesArray:jsonDic];
                [self.groupCollectionView reloadData];
                [SVProgressHUD showSuccessWithStatus:@"读取数据成功"];
            } else {
                //没有加入的小组信息
                [SVProgressHUD showSuccessWithStatus:@"没有小组信息"];
            }
            
        }
            break;
            
        default:
            break;
    }
}

- (void)intoChatView {
    [self.navigationController.tabBarController setSelectedIndex:2];
}



@end
