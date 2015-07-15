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

//地址BUTTON
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
//时间BUTTON
@property (weak, nonatomic) IBOutlet UIButton *dateButton;

@property (weak, nonatomic) IBOutlet UITextField *partyNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;


@property (weak, nonatomic) IBOutlet UIView *payFirstView;
@property (weak, nonatomic) IBOutlet UITextField *payFirstMoneyTextField;
@property (weak, nonatomic) IBOutlet UIButton *payFirstDoneButton;


@property (weak, nonatomic) IBOutlet UIButton *imRichButton;
@property (weak, nonatomic) IBOutlet UIButton *aaButton;
@property (weak, nonatomic) IBOutlet UIButton *payFirstButton;

- (void)reloadView;






@end
