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



@interface MyPartyViewController ()<UITabBarDelegate,UIScrollViewDelegate>
{
    NSMutableArray *_scheduleArray;
    NSDictionary *norDic;
    NSDictionary *selDic;
    
    CreatedPartyTableViewDelegate *_createdPartyDelegate;
    
    HistoryPartyTableViewDelegate *_historyPartyDelegate;
    

    

}

@end

@implementation MyPartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scheduleArray = [CD_Party getPartyFromCDForSchedule];
    
    _createdPartyDelegate = [[CreatedPartyTableViewDelegate alloc] init];
    _createdPartyDelegate.schAry = _scheduleArray;
    self.createdPartyTableView.delegate = _createdPartyDelegate;
    self.createdPartyTableView.dataSource = _createdPartyDelegate;
    
    _historyPartyDelegate = [[HistoryPartyTableViewDelegate alloc] init];
    _historyPartyDelegate.schAry = _scheduleArray;
    self.historyPartyTableView.delegate = _historyPartyDelegate;
    self.historyPartyTableView.dataSource = _historyPartyDelegate;

    
    
    
    // Do any additional setup after loading the view.
    self.myPartyScrollView.delegate = self;
    self.myPartyTabBar.delegate = self;
    
    
    
    self.myPartyScrollView.showsHorizontalScrollIndicator = NO;
    self.myPartyScrollView.showsVerticalScrollIndicator = NO;

    self.myPartyScrollView.bounces = NO;
    
    
    
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
    
    [self.myPartyTabBar setSelectedItem:self.createdParty];
    
    [self.createdParty setTitleTextAttributes:norDic forState:UIControlStateNormal];
    [self.createdParty setTitleTextAttributes:selDic forState:UIControlStateSelected];
    
    [self.historyParty setTitleTextAttributes:norDic forState:UIControlStateNormal];
    [self.historyParty setTitleTextAttributes:selDic forState:UIControlStateSelected];
    

    [self.selectLineWidth setConstant:[[UIScreen mainScreen] bounds].size.width/2];
    
    
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
        
        //群聊界面
        [self.myPartyTabBar setSelectedItem:self.createdParty];
    }else if (CGRectGetWidth([UIScreen mainScreen].bounds) == scrollView.contentOffset.x){
        
        [self.myPartyTabBar setSelectedItem:self.historyParty];
        
        [self.selectConLeft setConstant:[[UIScreen mainScreen] bounds].size.width/2];

    }
    
    NSLog(@"%f",scrollView.contentOffset.x);
    

    
    
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    self.scrollViewWidth.constant = CGRectGetWidth([UIScreen mainScreen].bounds) * 2;
    self.view1Width.constant = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.view2Width.constant = CGRectGetWidth([UIScreen mainScreen].bounds);

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
