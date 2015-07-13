//
//  ConfirmPartyDetailViewController.m
//  SRAgree
//
//  Created by G4ddle on 14/12/16.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import "ConfirmPartyDetailViewController.h"
#import "SRNet_Manager.h"
#import "MJExtension.h"
#import <SVProgressHUD.h>
#import "ScheduleTableViewController.h"
#import "GroupDetailViewController.h"
#import "ChooseLoctaionViewController.h"
#import "ChooseDateViewController.h"

@interface ConfirmPartyDetailViewController ()<SRNetManagerDelegate, UITextFieldDelegate, UITextViewDelegate> {
    SRNet_Manager *_netManager;
    BOOL _feedBack;
}

@end

@implementation ConfirmPartyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    _feedBack = TRUE;
    //设置地址文本
    if (self.party.location) {
        [self.addressButton setTitle:[NSString stringWithFormat:@"地址: %@", self.party.location] forState:UIControlStateNormal];
    } else {
        [self.addressButton setTitle:@"未选择地址" forState:UIControlStateNormal];
        self.party.location = @"未选择地址";
    }
    
    
    //设置时间文本
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年M月d日 EEEE aa hh:mm"];
    [self.dateButton setTitle:[dateFormatter stringFromDate:self.party.begin_time] forState:UIControlStateNormal];
    
    [self.partyNameTextField setDelegate:self];
    [self.remarkTextView setDelegate:self];
    
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

- (void)reloadView {
    //设置地址文本
    if (self.party.location) {
        [self.addressButton setTitle:[NSString stringWithFormat:@"地址: %@", self.party.location] forState:UIControlStateNormal];
    } else {
        [self.addressButton setTitle:@"未选择地址" forState:UIControlStateNormal];
        self.party.location = @"未选择地址";
    }
    
    
    //设置时间文本
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年M月d日 EEEE aa hh:mm"];
    [self.dateButton setTitle:[dateFormatter stringFromDate:self.party.begin_time] forState:UIControlStateNormal];
    

 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pressedTheDoneButton:(id)sender {
    [self.doneButton setEnabled:NO];
    self.party.pk_party = [[NSUUID UUID] UUIDString];
    self.party.fk_user = [Model_User loadFromUserDefaults].pk_user;
    self.party.name = self.partyNameTextField.text;
    self.party.remark = self.remarkTextView.text;
    
    if (!_netManager) {
        _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
    }
    [_netManager addSchedule:self.party];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.remarkTextView.text = nil;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (0 == textView.text.length) {
        [self.remarkTextView setText:@"请输入聚会的备注信息"];
    }
    return YES;
}

- (IBAction)textFieldEditingChanger:(UITextField *)sender {
    if (sender.text.length > 0 ) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.party.name = textField.text;

    return YES;
}

- (IBAction)pressedTheFeedbackButton:(id)sender {
    if (_feedBack) {
        self.feedBackLabel.text = @"关闭";
        _feedBack = FALSE;
    } else {
        self.feedBackLabel.text = @"开启";
        _feedBack = TRUE;
    }
}

-(void)interfaceReturnDataSuccess:(NSMutableDictionary *)jsonDic with:(int)interfaceType {
    switch (interfaceType) {
        case kAddSchedule: {
            if (self.isGroupParty) {
                GroupDetailViewController *rootController = [self.navigationController.viewControllers objectAtIndex:1];
                rootController.partyLoadingAgain = TRUE;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popToViewController:rootController animated:YES];
                });
            } else {
                ScheduleTableViewController *rootController = [self.navigationController.viewControllers objectAtIndex:0];
                rootController.loadAgain = true;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
        }
            break;
            
        default:
            break;
    }
    
    [SVProgressHUD dismiss];
}

- (void)interfaceReturnDataError:(int)interfaceType {
    [SVProgressHUD dismiss];
}
//返回上一页
- (IBAction)tapBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//改变时间
- (IBAction)changeDate:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
    ChooseDateViewController *childController = [sb instantiateViewControllerWithIdentifier:@"chooseDate"];
    childController.fromRoot = YES;
    childController.party = self.party;
    [self.navigationController showViewController:childController sender:self];
    

    NSLog(@"返回到选择时间界面");
}
//改变地址
- (IBAction)changeAddress:(id)sender {

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
    ChooseLoctaionViewController *childController = [sb instantiateViewControllerWithIdentifier:@"chooseLocation"];
    childController.fromRoot = YES;
    [self.navigationController showViewController:childController sender:self];
        NSLog(@"返回到选择地址界面");
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
