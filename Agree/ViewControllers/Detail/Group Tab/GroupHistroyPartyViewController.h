//
//  GroupHistroyPartyViewController.h
//  Agree
//
//  Created by Agree on 15/8/10.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupHistroyPartyViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *backView1;
@property (weak, nonatomic) IBOutlet UITableView *myGroupHistroyPartyTableView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel1;



@property int chooseRow;

- (void)reloadTipView: (NSInteger)aryCount withType:(int)inttype;

@property BOOL loadAgain;

@end
