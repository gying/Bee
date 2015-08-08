//
//  GroupHistroyTableViewController.m
//  Agree
//
//  Created by Agree on 15/8/8.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "GroupHistroyTableViewController.h"
#import <SVProgressHUD.h>
#import "SRNet_Manager.h"
#import "MJExtension.h"
#import "PartyDetailViewController.h"
#import "AllPartyTableViewCell.h"
#import "AppDelegate.h"
#import "CD_Party.h"
#import <MJRefresh.h>

#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]
@interface GroupHistroyTableViewController ()<SRPartyDetailDelegate> {
    NSMutableArray *_HistroyArray;
    NSIndexPath *_chooseIndexPath;
    //第一次读取的标识
    BOOL _firstLoadingDone;
    UIView * _backView;
    UILabel * _textLabel;
    
    
}

@end

@implementation GroupHistroyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backView];
    
    self.loadAgain = false;
    _HistroyArray = [CD_Party getPartyFromCDForSchedule];
    [self reloadTipView:_HistroyArray.count];
    [self loadAllScheduleData];
    [super viewDidLoad];
    
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh:)];


}

-(void)backView
{
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_backView];
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height - 180, 100, 40)];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.text = @"暂无日程";
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


- (void)loadAllScheduleData {
    [self clearUpdate];
    
    Model_User *user = [[Model_User alloc] init];
    user.pk_user = [Model_User loadFromUserDefaults].pk_user;
    
    [SRNet_Manager requestNetWithDic:[SRNet_Manager getAllScheduleByUserDic:user]
                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                if (jsonDic) {
                                    for (Model_Party *party in _HistroyArray) {
                                        [CD_Party removePartyFromCD:party];
                                    }
                                    
                                    _HistroyArray = (NSMutableArray *)[Model_Party objectArrayWithKeyValuesArray:jsonDic];
                                    [self reloadTipView:_HistroyArray.count];
                                    for (Model_Party *party in _HistroyArray) {
                                        [CD_Party savePartyToCD:party];
                                    }
                                    
                                    //                [self.tableView reloadData];
                                    
                                } else {
                                    if (_HistroyArray) {
                                        for (Model_Party *party in _HistroyArray) {
                                            [CD_Party removePartyFromCD:party];
                                        }
                                        [_HistroyArray removeAllObjects];
                                        [self reloadTipView:_HistroyArray.count];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([@"PartyDetail"  isEqual: segue.identifier]) {
        //读取小组详情数据并赋值小组数据
        
        [self.tableView deselectRowAtIndexPath:_chooseIndexPath animated:YES];
        PartyDetailViewController *controller = (PartyDetailViewController *)segue.destinationViewController;
        controller.party = [_HistroyArray objectAtIndex:_chooseIndexPath.row];
        //        self.dataChange = TRUE;
        controller.delegate = self;
    }
}

- (IBAction)tapBackButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (_HistroyArray) {
        return _HistroyArray.count;
    }
    return 0;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Model_Party *theParty = [_HistroyArray objectAtIndex:indexPath.row];
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
    for (Model_Party *theParty in _HistroyArray) {
        if ([theParty.pk_party isEqualToString:party.pk_party]) {
            theParty.relationship = party.relationship;
        }
    }
    
    [self.tableView reloadData];
}


- (void)cancelParty:(Model_Party *)party {
    Model_Party *cancelParty;
    for (Model_Party *theParty in _HistroyArray) {
        if ([theParty.pk_party isEqualToString:party.pk_party]) {
            cancelParty = theParty;
        }
    }
    [_HistroyArray removeObject:cancelParty];
    [self reloadTipView:_HistroyArray.count];
    [self.tableView reloadData];
}

- (void)refresh: (id)sender {
    //开始刷新
    self.loadAgain = false;
    [self loadAllScheduleData];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
