//
//  ContactsTableViewController.h
//  Agree
//
//  Created by G4ddle on 15/3/16.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRAccountView.h"


@interface ContactsTableViewController : UITableViewController

- (void)loadDataFromNet;
- (void)reloadTableViewAndUnreadData;
- (void)intoMessage: (Model_User *)user;

@property (weak, nonatomic) IBOutlet UIView *updateView;

@property (nonatomic, strong)SRAccountView *accountView;
@end
