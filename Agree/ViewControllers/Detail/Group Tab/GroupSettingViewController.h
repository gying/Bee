//
//  GroupSettingViewController.h
//  Agree
//
//  Created by G4ddle on 15/1/26.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_Group.h"
#import "GroupDetailViewController.h"

@interface GroupSettingViewController : UIViewController

@property (nonatomic, strong)Model_Group *group;



@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, strong)GroupDetailViewController *rootController;






@property (weak, nonatomic) IBOutlet UITableView *groupSettingTableView;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (weak, nonatomic) IBOutlet UIButton *inButton;
@end
