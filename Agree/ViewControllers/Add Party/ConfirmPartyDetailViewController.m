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
#import "GroupDetailViewController.h"
#import "ChooseLoctaionViewController.h"
#import "ChooseDateViewController.h"
#import "SRTool.h"

@interface ConfirmPartyDetailViewController ()<UITextFieldDelegate, UITextViewDelegate> {
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
    
    self.remarkTextView.textAlignment = NSTextAlignmentCenter;
    
    self.imRichButton.tag = 1;
    self.aaButton.tag = 2;
    self.payFirstButton.tag = 3;
    
    
    self.payFirstDoneButton.tag = 4;
    
    
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
    if ([self.doneButton.titleLabel.text isEqualToString:@"关闭"]) {
        //关闭键盘
        [self.remarkTextView resignFirstResponder];
        [self.doneButton setTitle:@"完成" forState:UIControlStateNormal];
    } else {
        //完成聚会
        //开始建立聚会
        self.party.pk_party = [[NSUUID UUID] UUIDString];
        self.party.fk_user = [Model_User loadFromUserDefaults].pk_user;
        self.party.name = self.partyNameTextField.text;
        self.party.remark = self.remarkTextView.text;
        self.party.pay_type = [NSNumber numberWithInt:_payType];
        
        switch (_payType) {
            case 1: {
                //请客
            }
                break;
                
            case 2: {
                //AA
            }
                break;
                
            case 3: {
                //预付
                //预付的默认收款人为自己
                self.party.pay_fk_user = self.party.fk_user;
            }
                break;
                
            default: {
                //未指定
            }
                break;
        }

        [SVProgressHUD show];
        
        
        [SRNet_Manager requestNetWithDic:[SRNet_Manager addScheduleDic:self.party]
                                complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                    if (self.isGroupParty) {
                                        GroupDetailViewController *rootController = [self.navigationController.viewControllers objectAtIndex:1];
                                        rootController.partyLoadingAgain = TRUE;
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self.navigationController popToViewController:rootController animated:YES];
                                        });
                                    } else {
//                                        ScheduleTableViewController *rootController = [self.navigationController.viewControllers objectAtIndex:0];
//                                        rootController.loadAgain = true;
                                        
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [self.navigationController popToRootViewControllerAnimated:YES];
                                        });
                                    }
                                    [SVProgressHUD dismiss];
                                } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                    
                                }];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.remarkTextView.text isEqualToString:@"请输入聚会的备注信息"]) {
        self.remarkTextView.text = nil;
    }
    
    self.doneButton.enabled = YES;
    [self.doneButton setTitle:@"关闭" forState:UIControlStateNormal];

}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (0 == textView.text.length) {
        [self.remarkTextView setText:@"请输入聚会的备注信息"];
        [self.doneButton setTitle:@"完成" forState:UIControlStateNormal];
//        self.doneButton.enabled = NO;
    }
    else if(textView.text.length > 0 ) {
        [self.doneButton setTitle:@"完成" forState:UIControlStateNormal];
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
    switch (sender.tag) {
        case 0: {
            //未指定
        }
            break;
        case 1: {
            //请客
            if (1 == _payType) {
                //取消
                _payType = 0;
                [self.imRichButton setSelected:NO];
                [self.payTypeLabel setText:@"支付类型"];
            } else {
                [self.payTypeLabel setText:@"请客"];
                [self.imRichButton setSelected:YES];
                [self.aaButton setSelected:NO];
                [self.payFirstButton setSelected:NO];
                _payType = (int)sender.tag;
            }
            
        }
            break;
            
        case 2: {
            //AA后付
            if (2 == _payType) {
                //取消
                _payType = 0;
                [self.aaButton setSelected:NO];
                [self.payTypeLabel setText:@"支付类型"];
            } else {
                [self.payTypeLabel setText:@"AA制"];
                [self.imRichButton setSelected:NO];
                [self.aaButton setSelected:YES];
                [self.payFirstButton setSelected:NO];
                _payType = (int)sender.tag;
            }
        }
            break;
            
        case 3: {
            //预支付
            if (3 == _payType) {
                //取消
                _payType = 0;
                [self.payFirstButton setSelected:NO];
                [self.payTypeLabel setText:@"支付类型"];
                //取消预支付
                self.party.pay_amount = nil;
            } else {
                [self.payTypeLabel setText:@"预付费"];
                [self.imRichButton setSelected:NO];
                [self.aaButton setSelected:NO];
                [self.payFirstButton setSelected:YES];
                _payType = (int)sender.tag;
                
                //显示预支付页面
                [self.payFirstView setHidden:NO];
                [self.payFirstMoneyTextField becomeFirstResponder];
            }
        }
            break;
            
        case 4: {
            //预支付完成按钮
            if (0 != self.payFirstMoneyTextField.text.length) {
                [self.payFirstView setHidden:YES];
                [self.payFirstMoneyTextField resignFirstResponder];
                
                self.party.pay_amount = [NSNumber numberWithFloat:[self.payFirstMoneyTextField.text floatValue]];
                [self.payTypeLabel setText:[NSString stringWithFormat:@"预付费金额: %@", self.payFirstMoneyTextField.text]];
//                [self.payTypeLabel setText:@"AAA"];
                
                self.payFirstMoneyTextField.text = nil;
            } else {
                //输入金额为空
                [SRTool showSRAlertViewWithTitle:@"提示"
                                         message:@"预付费的钱可不能为空哦~"
                               cancelButtonTitle:@"好的"
                                otherButtonTitle:nil
                           tapCancelButtonHandle:^(NSString *msgString) {
                                    
                           } tapOtherButtonHandle:^(NSString *msgString) {
                    
                                }];
            }
        }
            break;
            
        default:
            break;
    }
}

//返回上一页
- (IBAction)tapBackButton:(id)sender {
    if (self.isGroupParty) {
//        UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
//        [self.navigationController popToViewController:viewController animated:YES];
        
        for (UIViewController *subController in self.navigationController.viewControllers) {
            
            if ([subController isKindOfClass:[GroupDetailViewController class]]) {
                [self.navigationController popToViewController:subController animated:YES];
                break;
            }
        }
        
        
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
    
    NSLog(@"返回日程界面");
    
}
//改变时间
- (IBAction)changeDate:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
    ChooseDateViewController *childController = [sb instantiateViewControllerWithIdentifier:@"chooseDate"];
    childController.fromRoot = YES;
    childController.party = self.party;
    [self.navigationController showViewController:childController sender:self];
    [childController.tnextButton setTitle:@"完成修改" forState:UIControlStateNormal];

    NSLog(@"返回到选择时间界面");
}
//改变地址
- (IBAction)changeAddress:(id)sender {

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
    ChooseLoctaionViewController *childController = [sb instantiateViewControllerWithIdentifier:@"chooseLocation"];
    childController.party = self.party;
    childController.fromRoot = YES;
    [self.navigationController showViewController:childController sender:self];
        NSLog(@"返回到选择地址界面");
    
    [childController.lnextButton setTitle:@"完成修改" forState:UIControlStateNormal];

}



//键盘回收
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.remarkTextView resignFirstResponder];
    [self.partyNameTextField resignFirstResponder];
    
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
