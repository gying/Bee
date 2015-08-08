//
//  ScheduleTableViewController.m
//  SRAgree
//
//  Created by G4ddle on 14/12/16.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import "ScheduleTableViewController.h"
#import <SVProgressHUD.h>
#import "SRNet_Manager.h"
#import "MJExtension.h"
#import "PartyDetailViewController.h"
#import "AllPartyTableViewCell.h"
#import "AppDelegate.h"
#import "CD_Party.h"
#import <MJRefresh.h>

#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]
@interface ScheduleTableViewController ()<SRPartyDetailDelegate> {
    NSMutableArray *_scheduleArray;
    NSIndexPath *_chooseIndexPath;
    //第一次读取的标识
    BOOL _firstLoadingDone;
    UIView * _backView;
    UILabel * _textLabel;
    
    
}

@end

@implementation ScheduleTableViewController

#pragma mark - 界面操作
- (void)viewDidLoad {
    
    [self backView];

    self.loadAgain = false;
    _scheduleArray = [CD_Party getPartyFromCDForSchedule];
    [self reloadTipView:_scheduleArray.count];
    [self loadAllScheduleData];
    [super viewDidLoad];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh:)];
    

}

- (void)loadPartyData {
    
}

- (void)detailChange:(Model_Party *)party with:(int)type {

}

- (void)cancelParty:(Model_Party *)party with:(int)type {
    
}


-(void)backView
{
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_backView];
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height - 180, 100, 40)];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.text = @"请添加日程";
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

- (void)viewWillAppear:(BOOL)animated {
    if (_firstLoadingDone) {
        NSNumber *pn = [[NSUserDefaults standardUserDefaults] objectForKey:@"party_update"];
        if (pn && pn.intValue != 0) {
            self.loadAgain = TRUE;
        }
        
    }else {
        _firstLoadingDone = TRUE;
    }
    [super viewWillAppear:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.loadAgain) {
        [self loadAllScheduleData];
        self.loadAgain = false;
    }
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (_scheduleArray) {
        return _scheduleArray.count;
    }
    return 0;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Model_Party *theParty = [_scheduleArray objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"ALLSCHEDULECELL";
    
    AllPartyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[AllPartyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell initWithParty:theParty];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _chooseIndexPath = indexPath;
    return indexPath;
}

#pragma mark - 聚会详情代理
- (void)detailChange:(Model_Party *)party {
    for (Model_Party *theParty in _scheduleArray) {
        if ([theParty.pk_party isEqualToString:party.pk_party]) {
            theParty.relationship = party.relationship;
        }
    }

    [self.tableView reloadData];
}

- (void)cancelParty:(Model_Party *)party {
    Model_Party *cancelParty;
    for (Model_Party *theParty in _scheduleArray) {
        if ([theParty.pk_party isEqualToString:party.pk_party]) {
            cancelParty = theParty;
        }
    }
    [_scheduleArray removeObject:cancelParty];
    [self reloadTipView:_scheduleArray.count];
    [self.tableView reloadData];
}


#pragma mark - 业务逻辑
- (void)loadAllScheduleData {
    [self clearUpdate];
    
    Model_User *user = [[Model_User alloc] init];
    user.pk_user = [Model_User loadFromUserDefaults].pk_user;
    
    [SRNet_Manager requestNetWithDic:[SRNet_Manager getAllScheduleByUserDic:user]
                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                if (jsonDic) {
                                    for (Model_Party *party in _scheduleArray) {
                                        [CD_Party removePartyFromCD:party];
                                    }
                                    
                                    _scheduleArray = (NSMutableArray *)[Model_Party objectArrayWithKeyValuesArray:jsonDic];
                                    [self reloadTipView:_scheduleArray.count];
                                    for (Model_Party *party in _scheduleArray) {
                                        [CD_Party savePartyToCD:party];
                                    }
                                    
                                    //                [self.tableView reloadData];
                                    
                                } else {
                                    if (_scheduleArray) {
                                        for (Model_Party *party in _scheduleArray) {
                                            [CD_Party removePartyFromCD:party];
                                        }
                                        [_scheduleArray removeAllObjects];
                                        [self reloadTipView:_scheduleArray.count];
                                    }
                                }
                                [self.tableView reloadData];
                                [self.tableView.header endRefreshing];
                                //在成功读取了所有聚会后,将聚会提示设置为0
                                [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"party_update"];
                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                
                            }];
    
}

- (void)clearUpdate {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.groupDelegate cleanAllPartyUpdate];
}

- (void)refresh: (id)sender {
    //开始刷新
    self.loadAgain = false;
    [self loadAllScheduleData];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([@"PartyDetail"  isEqual: segue.identifier]) {
        //读取小组详情数据并赋值小组数据
        
        [self.tableView deselectRowAtIndexPath:_chooseIndexPath animated:YES];
        PartyDetailViewController *controller = (PartyDetailViewController *)segue.destinationViewController;
        controller.party = [_scheduleArray objectAtIndex:_chooseIndexPath.row];
//        self.dataChange = TRUE;
        controller.delegate = self;
    }
}


@end
