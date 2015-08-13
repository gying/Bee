//
//  ScheduleViewController.m
//  Agree
//
//  Created by Agree on 15/8/6.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "ScheduleViewController.h"

#import "CD_Party.h"

#import "HistoryPartyTableViewDelegate.h"

#import "PartyDetailViewController.h"
#import "SchedulePartyTableViewDelegate.h"
#import <MJRefresh.h>

#import "AppDelegate.h"



#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]
@interface ScheduleViewController ()<UITabBarDelegate,UIScrollViewDelegate, SRPartyDetailDelegate> {
    NSDictionary *norDic;
    NSDictionary *selDic;
    
    SchedulePartyTableViewDelegate *_scheduleDelegate;
    HistoryPartyTableViewDelegate *_historyPartyDelegate;
    
    BOOL _firstLoadingDone;
}


@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTabbar];
    
    _scheduleDelegate = [[SchedulePartyTableViewDelegate alloc] init];
    _scheduleDelegate.rootController = self;
    self.myScheduleTableView.delegate = _scheduleDelegate;
    self.myScheduleTableView.dataSource = _scheduleDelegate;
    [_scheduleDelegate loadPartyData];
    
    _historyPartyDelegate = [[HistoryPartyTableViewDelegate alloc] init];
    _historyPartyDelegate.rootController = self;
    self.historyPartyTableView.delegate = _historyPartyDelegate;
    self.historyPartyTableView.dataSource = _historyPartyDelegate;
    [_historyPartyDelegate loadPartyData];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.myScheduleTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:_scheduleDelegate
                                                                         refreshingAction:@selector(loadPartyData)];
    
    
    self.historyPartyTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:_historyPartyDelegate
                                                                         refreshingAction:@selector(loadPartyData)];
    
    self.textLabel1.backgroundColor = [UIColor clearColor];
    self.textLabel1.text = @"请添加日程";
    self.textLabel1.textColor = AgreeBlue;
    self.textLabel1.textAlignment = NSTextAlignmentCenter;
    self.textLabel1.font = [UIFont systemFontOfSize:14];
    
    
    self.textLabel2.backgroundColor = [UIColor clearColor];
    self.textLabel2.text = @"暂无历史聚会";
    self.textLabel2.textColor = AgreeBlue;
    self.textLabel2.textAlignment = NSTextAlignmentCenter;
    self.textLabel2.font = [UIFont systemFontOfSize:14];
    
    
    if (0 != _scheduleDelegate.schAry.count) {
        NSLog(@"当没有创建的聚会时");
        self.backView1.hidden = YES;
    }
    
    if (0 != _historyPartyDelegate.schAry.count) {
        NSLog(@"当没有历史聚会时");
        self.backView2.hidden = YES;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    //设置当前视图控制器为根控制器
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.topRootViewController = self;
    [self.navigationController.tabBarItem setBadgeValue:nil];
    
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
        [_scheduleDelegate loadPartyData];
        self.loadAgain = false;
    }
    [super viewDidAppear:YES];
}



- (void)setupTabbar {
    norDic = [NSDictionary dictionaryWithObjectsAndKeys:
              [UIColor grayColor],
              NSForegroundColorAttributeName,
              [UIFont fontWithName:@"STHeitiSC-Light" size:12.0f],
              NSFontAttributeName,
              nil];
    
    selDic = [NSDictionary dictionaryWithObjectsAndKeys:
              self.view.tintColor,
              NSForegroundColorAttributeName,
              [UIFont fontWithName:@"STHeitiSC-Light" size:12.0f],
              NSFontAttributeName,
              nil];
    
    [self.mySchedule setTitleTextAttributes:norDic forState:UIControlStateNormal];
    [self.mySchedule setTitleTextAttributes:selDic forState:UIControlStateSelected];
    
    [self.historyParty setTitleTextAttributes:norDic forState:UIControlStateNormal];
    [self.historyParty setTitleTextAttributes:selDic forState:UIControlStateSelected];
    
    self.myPartyScrollView.delegate = self;
    self.myPartyTabBar.delegate = self;
    
    self.myPartyScrollView.showsHorizontalScrollIndicator = NO;
    self.myPartyScrollView.showsVerticalScrollIndicator = NO;
    
    self.myPartyScrollView.bounces = NO;
    
    [self.myPartyTabBar setSelectedItem:self.mySchedule];
    [self.selectLineWidth setConstant:[[UIScreen mainScreen] bounds].size.width/2];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [self.myPartyScrollView setContentOffset:CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) * (item.tag - 1), 0) animated:YES];
    if (1 == item.tag) {
        //点击创建的聚会
        [self.selectConLeft setConstant:0];
    } else if (2 == item.tag) {
        //点击历史聚会
        [self.selectConLeft setConstant:[[UIScreen mainScreen] bounds].size.width/2];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (0.0 == scrollView.contentOffset.x) {
        
        [self.selectConLeft setConstant:0];
        
        if (0 == _scheduleDelegate.schAry.count) {
            self.backView1.hidden = NO;
        }else{
            self.backView1.hidden = YES;
        }

        
        //群聊界面
        [self.myPartyTabBar setSelectedItem:self.mySchedule];
    }else if (CGRectGetWidth([UIScreen mainScreen].bounds) == scrollView.contentOffset.x){
        
        [self.myPartyTabBar setSelectedItem:self.historyParty];
        
        [self.selectConLeft setConstant:[[UIScreen mainScreen] bounds].size.width/2];
        
        if (0 == _historyPartyDelegate.schAry.count) {
            self.backView2.hidden = NO;
        }else{
            self.backView2.hidden = YES;
        }
        
    }
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.scrollViewWidth.constant = CGRectGetWidth([UIScreen mainScreen].bounds) * 2;
    self.view1Width.constant = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.view2Width.constant = CGRectGetWidth([UIScreen mainScreen].bounds);
    
}

- (void)reloadTipView: (NSInteger)aryCount withType:(int)inttype {
    //1 创建的聚会
    //2 聚会的历史记录
    
    if (0 == aryCount) {
        switch (inttype) {
            case 1: {
                [self.backView1 setHidden:NO];
            }
                break;
            case 2: {
                [self.backView2 setHidden:NO];
            }
                break;
            default:
                break;
        }
    }else {
        switch (inttype) {
            case 1: {
                [self.backView1 setHidden:YES];
            }
                break;
            case 2: {
                [self.backView2 setHidden:YES];
            }
                break;
            default:
                break;
        }
        [self.backView2 setHidden:YES];
    }
}

- (void)detailChange:(Model_Party *)party with:(int)type {
    switch (type) {
        case 1: {
            //日程
            for (Model_Party *theParty in _scheduleDelegate.schAry) {
                if ([theParty.pk_party isEqualToString:party.pk_party]) {
                    theParty.relationship = party.relationship;
                }
            }
            [self.myScheduleTableView reloadData];
        }
            break;
        case 2: {
            //历史聚会
            for (Model_Party *theParty in _historyPartyDelegate.schAry) {
                if ([theParty.pk_party isEqualToString:party.pk_party]) {
                    theParty.relationship = party.relationship;
                }
            }
            [self.historyPartyTableView reloadData];
        }
            break;
        default:
            break;
    }
}

- (void)cancelParty:(Model_Party *)party with:(int)type {
    Model_Party *cancelParty;
    switch (type) {
        case 1: {
            //日程
            cancelParty = nil;
            for (Model_Party *theParty in _scheduleDelegate.schAry) {
                if ([theParty.pk_party isEqualToString:party.pk_party]) {
                    cancelParty = theParty;
                }
            }
            
            if (cancelParty) {
                [_scheduleDelegate.schAry removeObject:cancelParty];
                [self reloadTipView:_scheduleDelegate.schAry.count withType:1];
                [self.myScheduleTableView reloadData];
            }
        }
            break;
        case 2: {
            //历史聚会
            cancelParty = nil;
            for (Model_Party *theParty in _historyPartyDelegate.schAry) {
                if ([theParty.pk_party isEqualToString:party.pk_party]) {
                    cancelParty = theParty;
                }
            }
            
            if (cancelParty) {
                [_historyPartyDelegate.schAry removeObject:cancelParty];
                [self reloadTipView:_historyPartyDelegate.schAry.count withType:2];
                [self.historyPartyTableView reloadData];
            }
        }
            break;
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //1 日程
    //2 历史聚会
    //intoType
    if ([@"PartyDetail" isEqualToString:segue.identifier]) {
        PartyDetailViewController *childController = (PartyDetailViewController *)segue.destinationViewController;
        childController.party = [_scheduleDelegate.schAry objectAtIndex:self.chooseRow];
        childController.intoType = 1;
        childController.delegate = self;
        
    }else if ([@"HistoryParty" isEqualToString:segue.identifier]) {
        PartyDetailViewController *childController = (PartyDetailViewController *)segue.destinationViewController;
        childController.party = [_historyPartyDelegate.schAry objectAtIndex:self.chooseRow];
        childController.intoType = 2;
        childController.delegate = self;
    }
}

@end
