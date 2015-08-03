//
//  ContectsTableViewCell.h
//  Agree
//
//  Created by G4ddle on 15/3/19.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_User.h"
#import "ContactsTableViewController.h"

@interface ContactsTableViewCell : UITableViewCell<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

- (void)initWithUser: (Model_User *)user;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UILabel *surplusLabel;
@property (weak, nonatomic) IBOutlet UILabel *overdraftLabel;


@property (weak, nonatomic)ContactsTableViewController *topViewController;

@end
