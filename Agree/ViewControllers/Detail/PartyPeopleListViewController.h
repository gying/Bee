//
//  PartyPeopleListViewController.h
//  Agree
//
//  Created by G4ddle on 15/2/25.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartyPeopleListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *inButton;
@property (weak, nonatomic) IBOutlet UIButton *unknowButton;
@property (weak, nonatomic) IBOutlet UIButton *outButton;
@property (weak, nonatomic) IBOutlet UILabel *inLabel;
@property (weak, nonatomic) IBOutlet UILabel *unknowLabel;
@property (weak, nonatomic) IBOutlet UILabel *outLabel;
@property (weak, nonatomic) IBOutlet UITableView *peoplesTableview;
@property (weak, nonatomic) IBOutlet UIView *backView;


@property int showStatus;

@property (nonatomic, strong)NSArray *relationArray;
@property BOOL isCreator;

@end

