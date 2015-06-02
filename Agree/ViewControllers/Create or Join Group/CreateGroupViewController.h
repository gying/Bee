//
//  CreateGroupViewController.h
//  SRAgree
//
//  Created by G4ddle on 14/12/16.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateGroupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *groupNameTextField;

@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (weak, nonatomic) IBOutlet UITextField *codeInputTextField;
@property (weak, nonatomic) IBOutlet UIButton *groupCoverButton;
@property (weak, nonatomic) IBOutlet UIImageView *groupCoverImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *recodeButton;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UILabel *publicPhoneLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *publicPhoneSeg;

@end
