//
//  UserChatViewController.h
//  Agree
//
//  Created by G4ddle on 15/3/24.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_User.h"
#import "ContactsTableViewController.h"
#import "SRAccountView.h"


@interface UserChatViewController : UIViewController

@property (nonatomic, strong)Model_User *user;
@property (weak, nonatomic) IBOutlet UITableView *userChatTableView;
//@property (nonatomic, weak)ContactsTableViewController *rootController;

@property (nonatomic, strong)SRAccountView *accountView;

//@property (nonatomic , strong )UserChatTableViewCell *cell;

@end
