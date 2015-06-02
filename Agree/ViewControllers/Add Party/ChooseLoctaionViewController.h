//
//  ChooseLoctaionViewController.h
//  SRAgree
//
//  Created by G4ddle on 14/12/16.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_Group.h"


@interface ChooseLoctaionViewController : UIViewController

@property (nonatomic, strong)Model_Group *chooseGroup;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property BOOL isGroupParty;
@property (weak, nonatomic) IBOutlet UIView *mapView;

@end
