//
//  PeopleListTableViewCell.h
//  Agree
//
//  Created by G4ddle on 15/2/26.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_User.h"

@interface PeopleListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UISwitch *tapSwitch;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;


- (void)initWithUser: (Model_User *)user withShowStatus: (int)showStatus isCreator: (BOOL) isCreator ;

@end
