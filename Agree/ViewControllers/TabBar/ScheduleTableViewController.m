//
//  ScheduleTableViewController.m
//  SRAgree
//
//  Created by G4ddle on 14/12/16.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import "ScheduleTableViewController.h"
#import "ProgressHUD.h"
#import "SRNet_Manager.h"
#import "MJExtension.h"
#import "PartyDetailViewController.h"
#import "AllPartyTableViewCell.h"
#import "AppDelegate.h"

@interface ScheduleTableViewController ()<SRNetManagerDelegate, SRPartyDetailDelegate> {
    NSMutableArray *_scheduleArray;
    SRNet_Manager *_netManager;
    NSIndexPath *_chooseIndexPath;
    //第一次读取的标识
    BOOL _firstLoadingDone;
    UIRefreshControl *_refreshControl;
}

@end

@implementation ScheduleTableViewController

- (void)viewDidLoad {
    self.loadAgain = false;
    self.dataChange = false;
    [self loadAllScheduleData];
    [super viewDidLoad];
    
    
    NSAttributedString *refString = [[NSAttributedString alloc] initWithString:@"松手刷新日程"];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [_refreshControl setAttributedTitle: refString];
    [_refreshControl setAlpha:0.3];
    [self.tableView addSubview:_refreshControl];
}

- (void)refresh: (id)sender {
    //开始刷新
    self.loadAgain = false;
    self.dataChange = false;
    [self loadAllScheduleData];
}

- (void)loadAllScheduleData {
    if (!_netManager) {
        _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
    }
    [self clearUpdate];
    
    Model_User *user = [[Model_User alloc] init];
    user.pk_user = [Model_User loadFromUserDefaults].pk_user;
    [_netManager getAllScheduleByUser:user];

}

- (void)clearUpdate {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.groupDelegate cleanAllPartyUpdate];
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
    
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.loadAgain) {
        [self loadAllScheduleData];
        self.loadAgain = false;
    }
    
    if (self.dataChange) {
        [self.tableView reloadData];
    }
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

- (void)DetailChange:(Model_Party *)party {
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
    [self.tableView reloadData];
}

- (void)interfaceReturnDataSuccess:(id)jsonDic with:(int)interfaceType {
    switch (interfaceType) {
        case kGetAllScheduleByUser: {
            if (jsonDic) {
                _scheduleArray = (NSMutableArray *)[Model_Party objectArrayWithKeyValuesArray:jsonDic];
                
                
                [self.tableView reloadData];
                [ProgressHUD showSuccess:@"读取数据成功"];
                [_refreshControl endRefreshing];
            } else {
                [ProgressHUD showSuccess:@"未找到相关数据"];
            }
            //在成功读取了所有聚会后,将聚会提示设置为0
            [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"party_update"];
        }
            break;
            
        default:
            break;
    }
}

- (void)interfaceReturnDataError:(int)interfaceType{
    [ProgressHUD showError:@"网络错误"];
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([@"PartyDetail"  isEqual: segue.identifier]) {
        //读取小组详情数据并赋值小组数据
        PartyDetailViewController *controller = (PartyDetailViewController *)segue.destinationViewController;
        controller.party = [_scheduleArray objectAtIndex:_chooseIndexPath.row];
//        self.dataChange = TRUE;
        controller.delegate = self;
    }
}


@end
