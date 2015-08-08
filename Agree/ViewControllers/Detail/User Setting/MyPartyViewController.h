//
//  MyPartyViewController.h
//  Agree
//
//  Created by Agree on 15/7/15.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyPartyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITabBar *myPartyTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *createdParty;
@property (weak, nonatomic) IBOutlet UITabBarItem *historyParty;
@property (weak, nonatomic) IBOutlet UIScrollView *myPartyScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectLineWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectConLeft;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2Width;


@property (weak, nonatomic) IBOutlet UITableView *createdPartyTableView;
@property (weak, nonatomic) IBOutlet UITableView *historyPartyTableView;

@property int chooseRow;


@property (weak, nonatomic) IBOutlet UIView *backView1;

@property (weak, nonatomic) IBOutlet UIView *backView2;

@property (weak, nonatomic) IBOutlet UILabel *textLabel1;

@property (weak, nonatomic) IBOutlet UILabel *textLabel2;

- (void)reloadTipView: (NSInteger)aryCount withType:(int)inttype;





@end



