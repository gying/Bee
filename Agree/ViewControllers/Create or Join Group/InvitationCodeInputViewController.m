//
//  InvitationCodeInputViewController.m
//  Agree
//
//  Created by G4ddle on 15/8/12.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "InvitationCodeInputViewController.h"
#import "Model_Group_Code.h"
#import "SRNet_Manager.h"
#import <SVProgressHUD.h>
#import "Model_Group.h"
#import "MJExtension.h"
#import "GroupProfilesTableViewController.h"

@interface InvitationCodeInputViewController () <UITextFieldDelegate>{
    //用于计数到当前更新到哪一位
    int _inputCount;
    NSString *_inputCode;
    
    Model_Group *_selectedGroup;
}

@end

@implementation InvitationCodeInputViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.numberTextField.delegate = self;
    [self.numberTextField becomeFirstResponder];
    [self.numberTextField setHidden:YES];
    
    
    //初始化时将数字Label全部设置隐藏
    self.inputLabel1.hidden = YES;
    self.inputLabel2.hidden = YES;
    self.inputLabel3.hidden = YES;
    self.inputLabel4.hidden = YES;
    //将计数标识为第一位
    _inputCount = 1;
    
    [self setTipViewColor:self.inputTipView1];
    
    _inputCode = [[NSString alloc] init];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (0 == string.length) {
        //如果字符长度为0,表示为删除
        switch (_inputCount) {
            case 1: {
                //在第一位删除,不进行任何处理
            }
                break;
            case 2: {
                self.inputTipView1.hidden = NO;
                self.inputLabel1.text = nil;
                self.inputLabel1.hidden = YES;
                //计数减少一位
                _inputCount--;
                [self cancelTipViewColor:self.inputTipView2];
                [self setTipViewColor:self.inputTipView1];
                
                _inputCode = [_inputCode substringWithRange:NSMakeRange(0, _inputCode.length - 1)];
                
            }
                break;
            case 3: {
                self.inputTipView2.hidden = NO;
                self.inputLabel2.text = nil;
                self.inputLabel2.hidden = YES;
                //计数减少一位
                _inputCount--;
                [self cancelTipViewColor:self.inputTipView3];
                [self setTipViewColor:self.inputTipView2];
                
                _inputCode = [_inputCode substringWithRange:NSMakeRange(0, _inputCode.length - 1)];
                
            }
                break;
            case 4: {
                self.inputTipView3.hidden = NO;
                self.inputLabel3.text = nil;
                self.inputLabel3.hidden = YES;
                //计数减少一位
                _inputCount--;
                [self cancelTipViewColor:self.inputTipView4];
                [self setTipViewColor:self.inputTipView3];
                
                _inputCode = [_inputCode substringWithRange:NSMakeRange(0, _inputCode.length - 1)];
            }
                break;
                
            case 5: {
                self.inputTipView4.hidden = NO;
                self.inputLabel4.text = nil;
                self.inputLabel4.hidden = YES;
                //计数减少一位
                _inputCount--;
                //                [self cancelTipViewColor:self.inputTipView4];
                [self setTipViewColor:self.inputTipView4];
                
                _inputCode = [_inputCode substringWithRange:NSMakeRange(0, _inputCode.length - 1)];
            }
                break;
            default:
                break;
        }
        
        
    } else {
        //进行输入操作
        switch (_inputCount) {
            case 1: {
                self.inputTipView1.hidden = YES;
                self.inputLabel1.text = string;
                self.inputLabel1.hidden = NO;
                //计数增加一位
                _inputCount++;
                
                [self setTipViewColor:self.inputTipView2];
                _inputCode = [_inputCode stringByAppendingString:string];
            }
                break;
            case 2: {
                self.inputTipView2.hidden = YES;
                self.inputLabel2.text = string;
                self.inputLabel2.hidden = NO;
                //计数增加一位
                _inputCount++;
                
                [self setTipViewColor:self.inputTipView3];
                _inputCode = [_inputCode stringByAppendingString:string];
                
            }
                break;
            case 3: {
                self.inputTipView3.hidden = YES;
                self.inputLabel3.text = string;
                self.inputLabel3.hidden = NO;
                //计数增加一位
                _inputCount++;
                
                [self setTipViewColor:self.inputTipView4];
                _inputCode = [_inputCode stringByAppendingString:string];
                
            }
                break;
            case 4: {
                self.inputTipView4.hidden = YES;
                self.inputLabel4.text = string;
                self.inputLabel4.hidden = NO;
                //计数增加一位
                //计数为5 代表第4位已经输入完毕
                _inputCount++;
                _inputCode = [_inputCode stringByAppendingString:string];
                _inputCode = @"N0A3";
                
                //已经满足四位条件,在此时判断验证码是否正确,如果正确,开始下一个流程.
                Model_Group_Code *newCode = [[Model_Group_Code alloc] init];
                newCode.pk_group_code = _inputCode;
                [SRNet_Manager requestNetWithDic:[SRNet_Manager joinTheGroupByCodeDic:newCode]
                                        complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                            if (jsonDic) {
                                                [SVProgressHUD showSuccessWithStatus:@"找到小组"];
                                                
                                                _selectedGroup = [[Model_Group objectArrayWithKeyValuesArray:jsonDic] firstObject];
                                                
                                                
                                                [self performSegueWithIdentifier:@"GoToGroupDetail" sender:self];
                                                
                                            } else {
                                                [SVProgressHUD showSuccessWithStatus:@"未找到相关数据"];
                                                //未找到小组的相关数据
//                                                [self.remarkLabel setText:@"未找到小组信息,请再次确认输入"];
//                                                [self.codeInputTextField becomeFirstResponder];
                                                
                                                
//                                                [self performSegueWithIdentifier:@"GoToGroupDetail" sender:self];
                                                
                                            }
                                        } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                            
                                        }];
                
            }
                break;
            default:
                break;
        }
    }
    
    return YES;
}

- (void)setTipViewColor: (UIView *)tipView {
    //更改提示块的颜色
    tipView.backgroundColor = self.view.tintColor;
}

- (void)cancelTipViewColor: (UIView *)tipView {
    //取消提示块的颜色
    tipView.backgroundColor = [UIColor lightGrayColor];
}
- (IBAction)tapBackButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([@"GoToGroupDetail" isEqualToString:segue.identifier]) {
        //找到小组,进入加入小组操作页面
        GroupProfilesTableViewController *childController = segue.destinationViewController;
        childController.group = _selectedGroup;
    }
}


@end
