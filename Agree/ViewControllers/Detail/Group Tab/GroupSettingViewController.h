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
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UILabel *codeRemarkLabel;


@property (weak, nonatomic) IBOutlet UIButton *partyTipButton;
@property (weak, nonatomic) IBOutlet UILabel *partyTipLabel;

@property (weak, nonatomic) IBOutlet UIButton *chatTipButton;
@property (weak, nonatomic) IBOutlet UILabel *chatTipLabel;

@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UIButton *quitButton;
@property (weak, nonatomic) IBOutlet UICollectionView *peopleCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (nonatomic, strong)GroupDetailViewController *rootController;

@end
