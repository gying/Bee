//
//  MyPartyViewController.m
//  Agree
//
//  Created by Agree on 15/7/15.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "MyPartyViewController.h"
#import "CD_Party.h"

#import "CreatedPartyTableViewDelegate.h"

#import "HistoryPartyTableViewDelegate.h"
#import "CreatedPartyDetailViewController.h"
#import "HistoryPartyDetailViewController.h"

#import <MJRefresh.h>

#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]


@interface MyPartyViewController ()<UITabBarDelegate,UIScrollViewDelegate> {
    NSDictionary *norDic;
    NSDictionary *selDic;
    
    CreatedPartyTableViewDelegate *_createdPartyDelegate;
    HistoryPartyTableViewDelegate *_historyPartyDelegate;
}

@end

@implementation MyPartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTabbar];
    
    _createdPartyDelegate = [[CreatedPartyTableViewDelegate alloc] init];
    _createdPartyDelegate.myPartyVC = self;
    self.createdPartyTableView.delegate = _createdPartyDelegate;
    self.createdPartyTableView.dataSource = _createdPartyDelegate;
    [_createdPartyDelegate loadPartyData];
    
    _historyPartyDelegate = [[HistoryPartyTableViewDelegate alloc] init];
    _historyPartyDelegate.myPartyVC = self;
    self.historyPartyTableView.delegate = _historyPartyDelegate;
    self.historyPartyTableView.dataSource = _historyPartyDelegate;
    [_historyPartyDelegate loadPartyData];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.createdPartyTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:_createdPartyDelegate
                                                                         refreshingAction:@selector(loadPartyData)];
    
    
    self.historyPartyTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:_historyPartyDelegate
                                                                         refreshingAction:@selector(loadPartyData)];
    
    self.textLabel1.backgroundColor = [UIColor clearColor];
    self.textLabel1.text = @"请添加创建的聚会";
    self.textLabel1.textColor = AgreeBlue;
    self.textLabel1.textAlignment = NSTextAlignmentCenter;
    self.textLabel1.font = [UIFont systemFontOfSize:14];
    
    
    self.textLabel2.backgroundColor = [UIColor clearColor];
    self.textLabel2.text = @"请添加历史聚会";
    self.textLabel2.textColor = AgreeBlue;
    self.textLabel2.textAlignment = NSTextAlignmentCenter;
    self.textLabel2.font = [UIFont systemFontOfSize:14];
    
    
    if (0 != _createdPartyDelegate.schAry.count) {
        NSLog(@"当没有创建的聚会时");
        self.backView1.hidden = YES;
    }
    
    if (0 != _historyPartyDelegate.schAry.count) {
        NSLog(@"当没有历史聚会时");
        self.backView2.hidden = YES;
    }
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
    
    [self.createdParty setTitleTextAttributes:norDic forState:UIControlStateNormal];
    [self.createdParty setTitleTextAttributes:selDic forState:UIControlStateSelected];
    
    [self.historyParty setTitleTextAttributes:norDic forState:UIControlStateNormal];
    [self.historyParty setTitleTextAttributes:selDic forState:UIControlStateSelected];
    
    self.myPartyScrollView.delegate = self;
    self.myPartyTabBar.delegate = self;
    
    self.myPartyScrollView.showsHorizontalScrollIndicator = NO;
    self.myPartyScrollView.showsVerticalScrollIndicator = NO;
    
    self.myPartyScrollView.bounces = NO;
    
    [self.myPartyTabBar setSelectedItem:self.createdParty];
    [self.selectLineWidth setConstant:[[UIScreen mainScreen] bounds].size.width/2];

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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pressedBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (0.0 == scrollView.contentOffset.x) {
        
        [self.selectConLeft setConstant:0];
        
        if (0 == _createdPartyDelegate.schAry.count) {
            self.backView1.hidden = NO;
        }else{
            self.backView1.hidden = YES;
        }
        
        

        
        //群聊界面
        [self.myPartyTabBar setSelectedItem:self.createdParty];
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

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([@"GOTOCREATEDPARTY" isEqualToString:segue.identifier]) {
        CreatedPartyDetailViewController *childController = (CreatedPartyDetailViewController *)segue.destinationViewController;
        childController.party = [_createdPartyDelegate.schAry objectAtIndex:self.chooseRow];
        
    }else if ([@"HISTORYPARTY" isEqualToString:segue.identifier])
    {
        HistoryPartyDetailViewController *childController = (HistoryPartyDetailViewController *)segue.destinationViewController;
        childController.party = [_historyPartyDelegate.schAry objectAtIndex:self.chooseRow];
    }
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
