//
//  ChooseDateViewController.h
//  SRAgree
//
//  Created by G4ddle on 14/12/16.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_Party.h"
#import "JTCalendar.h"

@interface ChooseDateViewController : UIViewController <JTCalendarDataSource>

@property (nonatomic, strong)Model_Party *party;

@property (strong, nonatomic)JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic)JTCalendarContentView *calendarContentView;

@property (strong, nonatomic) JTCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *tnextButton;

@property BOOL isGroupParty;

@property BOOL fromRoot;

@end
