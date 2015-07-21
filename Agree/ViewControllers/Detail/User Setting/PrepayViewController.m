//
//  PrepayViewController.m
//  Agree
//
//  Created by Agree on 15/7/20.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "PrepayViewController.h"

@interface PrepayViewController ()

@end

@implementation PrepayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)TapBackButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.payTextField resignFirstResponder];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.payTextField becomeFirstResponder];
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
