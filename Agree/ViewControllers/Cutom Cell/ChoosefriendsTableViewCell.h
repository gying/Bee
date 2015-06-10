//
//  ChoosefriendsTableViewCell.h
//  Agree
//
//  Created by Agree on 15/6/9.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_User.h"


#import "ChoosefriendsViewController.h"
@interface ChoosefriendsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *avataButton;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property ( weak , nonatomic)ChoosefriendsViewController * topViewController;


- (void)initWithUser: (Model_User *)user;



@end
