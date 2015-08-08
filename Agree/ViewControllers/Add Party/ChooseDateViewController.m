//
//  ChooseDateViewController.m
//  SRAgree
//
//  Created by G4ddle on 14/12/16.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import "ChooseDateViewController.h"
#import "ConfirmPartyDetailViewController.h"
#import "ChooseLoctaionViewController.h"
#import "SRTool.h"



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
    
    //设置从选择时间返回来得默认时间
    if (self.party.begin_time) {
        [self.datePicker setDate:self.party.begin_time];
        [self.calendar setCurrentDateSelected:self.party.begin_time];
    } else {
        [self.datePicker setDate:[NSDate dateWithTimeIntervalSinceNow:60*60*2] animated:TRUE];
    }
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (!_chooseDate) {
        _chooseDate = [NSDate dateWithTimeIntervalSinceNow:60*60*2];
    }
    if ([[self buildDate] timeIntervalSinceDate:[NSDate date]] <= 60*60*2) {
        //聚会未超过两个小时,显示警告        
        [SRTool showSRAlertViewWithTitle:@"提示"
                                 message:@"聚会的开始时间必须是在当前时间的三个小时后哦~"
                       cancelButtonTitle:@"好的"
                        otherButtonTitle:nil
                         tapCancelButton:^(NSString *msgString) {
                             
                         } tapOtherButton:^(NSString *msgString) {
                             
                         }];
        
        
        return NO;
    }
    

    if (self.fromRoot) {
        ConfirmPartyDetailViewController *rootController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
        
        rootController.party.begin_time = _chooseDate;
        [rootController reloadView];
        
        [self.navigationController popViewControllerAnimated:YES];

        return NO;
    }
    
    
    return YES;
    
}

- (NSDate *)buildDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [_chooseDate dateByAddingTimeInterval:24*60*60];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@" HH:mm"];
    
    NSString *dataTimeString = [[NSString alloc] initWithFormat:@"%@%@", [dateFormatter stringFromDate:_chooseDate], [timeFormatter stringFromDate:self.datePicker.date]];
    
    NSDateFormatter *dateTimeFormatter = [[NSDateFormatter alloc] init];
    [dateTimeFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateTimeFormatter dateFromString:dataTimeString];

}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    _chooseDate = [self buildDate];
    self.party.begin_time = _chooseDate;
    
    ConfirmPartyDetailViewController *controller = (ConfirmPartyDetailViewController *)segue.destinationViewController;
    controller.party = self.party;
    controller.isGroupParty = self.isGroupParty;

    NSLog(@"更新选择时间后跳转页面!");
}


@end
