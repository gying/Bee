//
//  GroupPeopleTableViewCell.h
//  Agree
//
//  Created by Agree on 15/8/7.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_Group_User.h"

@interface GroupPeopleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UILabel *role;

- (void)initWithUser: (Model_Group_User *)user;

@end
