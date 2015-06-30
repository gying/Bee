//
//  RootPhoneRegViewController.m
//  Agree
//
//  Created by Agree on 15/6/30.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "RootPhoneRegViewController.h"

@interface RootPhoneRegViewController ()<UINavigationControllerDelegate,UITextFieldDelegate>

@end

@implementation RootPhoneRegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.sendButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark -- 发送验证码
//发送验证码方法
-(void)send
{
    NSLog(@"发送验证码");
    self.numberLable.text = @"请输入验证码";
    self.numberTextfield.placeholder = @"请输入验证码";
    if ((self.numberTextfield.text = nil)) {
        UIAlertView * ntfnil = [[UIAlertView alloc]initWithTitle:@"手机号码不能为空" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [ntfnil show];
        
    }
}

#pragma mark -- 文本框字体限制
//字体限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (self.numberTextfield == textField)
    {
        if ([toBeString length] > 20) {
            textField.text = [toBeString substringToIndex:20];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数不能输入了" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

//键盘回收
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.numberTextfield resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)close:(id)sender {
    
        [self dismissViewControllerAnimated:YES completion:nil];
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
