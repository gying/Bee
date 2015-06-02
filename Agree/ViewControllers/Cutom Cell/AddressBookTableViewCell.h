//
//  AddressBookTableViewCell.h
//  Agree
//
//  Created by G4ddle on 15/3/20.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "People.h"
#import "SRNet_Manager.h"


@interface AddressBookTableViewCell : UITableViewCell <SRNetManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressBookNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

- (void)initWithPeople: (People *)adPeople;


@end
