//
//  CreatedPartyDetailViewController.h
//  Agree
//
//  Created by Agree on 15/7/17.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Model_Party.h"

#import <EventKit/EventKit.h>

//@protocol SRPartyDetailDelegate <NSObject>
//
//@required
//- (void)detailChange: (Model_Party *)party;
//- (void)cancelParty: (Model_Party *)party;
//
//@end


@interface CreatedPartyDetailViewController : UIViewController
@property (nonatomic, strong)Model_Party *party;
//@property (nonatomic, strong)id<SRPartyDetailDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *inNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *outNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *unkownLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *locationMapView;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UIButton *cheakButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapConHeight;
@property (weak, nonatomic) IBOutlet UIButton *cancelPartyButton;
@property (weak, nonatomic) IBOutlet UILabel *payType;

@property (weak, nonatomic) IBOutlet UIView *payDoneView;
@property (weak, nonatomic) IBOutlet UILabel *moneyDone;
@property (weak, nonatomic) IBOutlet UILabel *moneyAmount;






@end
