//
//  ChoosefriendsViewController.h
//  Agree
//
//  Created by Agree on 15/6/9.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRAccountView.h"

#import "JoinUserViewController.h"



@interface ChoosefriendsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *choosefriendsTableview;

@property (nonatomic, strong)SRAccountView *accountView;

@property (nonatomic, strong)NSMutableArray *choosePeopleArray;

@property (nonatomic, weak)JoinUserViewController *rootController;

@end
