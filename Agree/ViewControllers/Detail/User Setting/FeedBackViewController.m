//
//  FeedBackViewController.m
//  Agree
//
//  Created by G4ddle on 15/4/5.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "FeedBackViewController.h"
#import "SRNet_Manager.h"

#import <SVProgressHUD.h>

@interface FeedBackViewController ()<SRNetManagerDelegate> {
    SRNet_Manager *_netManager;
}

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.feedBackTextView becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tapFeedBackButton:(id)sender {
    if (!_netManager) {
        _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
    }
    
    Model_Feedback *feedback = [[Model_Feedback alloc] init];
    [feedback setContent:self.feedBackTextView.text];
    [feedback setFk_user:[Model_User loadFromUserDefaults].pk_user];
    [feedback setDate:[NSDate date]];
    [_netManager feedBackMessage:feedback];
}

- (void)interfaceReturnDataSuccess:(id)jsonDic with:(int)interfaceType {
    
    switch (interfaceType) {
        case kFeedBackMessage: {    //反馈信息
            [SVProgressHUD showSuccessWithStatus:@"反馈成功"];
            //    [self.navigationController popToViewController:self animated:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
            break;
            
        default:
            break;
    }
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
