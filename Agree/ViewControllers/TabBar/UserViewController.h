//
//  UserViewController.h
//  Agree
//
//  Created by G4ddle on 15/2/14.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutUsViewController.h"
#import "FeedBackViewController.h"


@interface UserViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITableView *settingTableVIew;
@property (weak, nonatomic) IBOutlet UIView *upView;



- (void)resetAvatar;

@end
