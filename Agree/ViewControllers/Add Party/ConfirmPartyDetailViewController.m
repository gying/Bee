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

@interface ConfirmPartyDetailViewController ()<SRNetManagerDelegate, UITextFieldDelegate, UITextViewDelegate> {
    SRNet_Manager *_netManager;
    int _payType;
}

@end

@implementation ConfirmPartyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _payType = 0;
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
    self.party.pay_type = [NSNumber numberWithInt:_payType];
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

- (IBAction)tapPayButton:(UIButton *)sender {
    switch (_payType) {
        case 0: {
            //未指定
            _payType = 1;
            self.payLabel.text = @"我请客";
        }
            break;
        case 1: {
            //请客
            _payType = 2;
            self.payLabel.text = @"AA制";
        }
            break;
        case 2: {
            //AA后付
            _payType = 3;
            self.payLabel.text = @"预先支付";
        }
            break;
        case 3: {
            //预支付
            _payType = 0;
            self.payLabel.text = @"你猜";
        }
            break;
        default:
            break;
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
- (IBAction)tapBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
