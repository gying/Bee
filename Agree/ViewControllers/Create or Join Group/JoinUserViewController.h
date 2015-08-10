//
//  JoinUserViewController.h
//  SRAgree
//
//  Created by G4ddle on 14/12/16.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_Group.h"
#import "Model_Group_User.h"
#import "SRNet_Manager.h"

@interface JoinUserViewController : UIViewController

@property (nonatomic, strong)Model_Group *theGroup;
@property (nonatomic, strong)UIImage *groupCover;
@property (weak, nonatomic) IBOutlet UITextField *groupNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *groupCoverButton;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@property (nonatomic, strong)NSMutableArray *choosePeopleArray;

@end
