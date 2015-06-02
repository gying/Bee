//
//  ScheduleTableViewController.h
//  SRAgree
//
//  Created by G4ddle on 14/12/16.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleTableViewController : UITableViewController

@property BOOL loadAgain;
@property BOOL dataChange;

- (void)refresh: (id)sender;

@end
