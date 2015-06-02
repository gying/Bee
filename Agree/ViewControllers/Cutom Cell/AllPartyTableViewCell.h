//
//  AllPartyTableViewCell.h
//  Agree
//
//  Created by G4ddle on 15/2/23.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_Party.h"

@interface AllPartyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyAdreessLabel;
@property (weak, nonatomic) IBOutlet UILabel *inLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleCountLabel;
@property (weak, nonatomic) IBOutlet UIView *statusView;

- (void)initWithParty: (Model_Party *)party;

@end
