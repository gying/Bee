//
//  ConfirmPartyDetailViewController.h
//  SRAgree
//
//  Created by G4ddle on 14/12/16.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_Party.h"

@interface ConfirmPartyDetailViewController : UIViewController

@property (nonatomic, strong)Model_Party *party;

@property BOOL isGroupParty;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UITextField *partyNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end
