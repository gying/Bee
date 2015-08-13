//
//  CodeInputViewController.h
//  Agree
//
//  Created by Agree on 15/8/12.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeInputViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIView *inputTipView1;
@property (weak, nonatomic) IBOutlet UIView *inputTipView2;
@property (weak, nonatomic) IBOutlet UIView *inputTipView3;
@property (weak, nonatomic) IBOutlet UIView *inputTipView4;

@property (weak, nonatomic) IBOutlet UILabel *inputLabel1;
@property (weak, nonatomic) IBOutlet UILabel *inputLabel2;
@property (weak, nonatomic) IBOutlet UILabel *inputLabel3;
@property (weak, nonatomic) IBOutlet UILabel *inputLabel4;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

@end
