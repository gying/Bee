//
//  GroupProfilesTableViewController.h
//  Agree
//
//  Created by G4ddle on 15/8/12.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Model_Group.h"

@interface GroupProfilesTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UIButton *coverButton;

@property (nonatomic, strong)Model_Group *group;

@end
