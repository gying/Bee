//
//  PartyDetailViewController.h
//  Agree
//
//  Created by G4ddle on 15/1/26.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_Party.h"

@protocol SRPartyDetailDelegate <NSObject>

@required
- (void)DetailChange: (Model_Party *)party;
- (void)cancelParty: (Model_Party *)party;

@end

@interface PartyDetailViewController : UIViewController

@property (nonatomic, strong)Model_Party *party;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;


@property (weak, nonatomic) IBOutlet UILabel *inNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *outNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *unkownLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *locationMapView;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;

@property (nonatomic, strong)id<SRPartyDetailDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapConHeight;
@property (weak, nonatomic) IBOutlet UIButton *cancelPartyButton;

@end
