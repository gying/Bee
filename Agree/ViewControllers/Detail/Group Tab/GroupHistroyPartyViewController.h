//
//  GroupHistroyPartyViewController.h
//  Agree
//
//  Created by Agree on 15/8/10.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_Group.h"

@interface GroupHistroyPartyViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *backView1;
@property (weak, nonatomic) IBOutlet UITableView *myGroupHistroyPartyTableView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel1;

@property int chooseRow;
@property BOOL loadAgain;

@property (nonatomic, retain)Model_Group *group;

- (void)reloadTipView: (NSInteger)aryCount withType:(int)inttype;

@end
