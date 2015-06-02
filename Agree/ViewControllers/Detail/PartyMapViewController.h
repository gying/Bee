//
//  PartyMapViewController.h
//  Agree
//
//  Created by G4ddle on 15/4/4.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_Party.h"

@interface PartyMapViewController : UIViewController

@property (nonatomic, strong)Model_Party *party;

@property (nonatomic, strong)NSMutableArray *availableMaps;

@end
