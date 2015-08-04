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
#import "ContactsDetailTableViewController.h"


#import <MessageUI/MFMessageComposeViewController.h>


@interface AddressBookTableViewCell : UITableViewCell<MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressBookNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property ( strong, nonatomic )ContactsDetailTableViewController * contactsDetailTableVC;

- (void)initWithPeople: (People *)adPeople;


@end
