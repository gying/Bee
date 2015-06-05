//
//  ChooseDateViewController.m
//  SRAgree
//
//  Created by G4ddle on 14/12/16.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import "ChooseDateViewController.h"
#import "ConfirmPartyDetailViewController.h"

@interface ChooseDateViewController () {
    NSDate *_chooseDate;
    NSString *_dateString;
}

@end

@implementation ChooseDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.calendar = [[JTCalendar alloc] init];
    
    
    self.calendarMenuView = [[JTCalendarMenuView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
    self.calendarContentView = [[JTCalendarContentView alloc] initWithFrame:CGRectMake(0, 108, self.view.frame.size.width, self.view.frame.size.height - 108 - 162 - 100)];
    [self.view addSubview:self.calendarContentView];
    [self.view addSubview:self.calendarMenuView];
    
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.calendar reloadData]; // （必须要在这里调用）Must be call in viewDidAppear
}

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date {
    return NO;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date {
    _chooseDate = date;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (!_chooseDate) {
        _chooseDate = [NSDate date];
    }
    
    [_chooseDate dateByAddingTimeInterval:24*60*60];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@" HH:mm"];
    
    NSString *dataTimeString = [[NSString alloc] initWithFormat:@"%@%@", [dateFormatter stringFromDate:_chooseDate], [timeFormatter stringFromDate:self.datePicker.date]];
    
    NSDateFormatter *dateTimeFormatter = [[NSDateFormatter alloc] init];
    [dateTimeFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    _chooseDate = [dateTimeFormatter dateFromString:dataTimeString];
    self.party.begin_time = _chooseDate;
    
    ConfirmPartyDetailViewController *controller = (ConfirmPartyDetailViewController *)segue.destinationViewController;
    controller.party = self.party;
    controller.isGroupParty = self.isGroupParty;
}


@end