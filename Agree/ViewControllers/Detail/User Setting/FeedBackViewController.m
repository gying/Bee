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

@interface FeedBackViewController () <UIAlertViewDelegate>
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

    Model_Feedback *feedback = [[Model_Feedback alloc] init];
    [feedback setContent:self.feedBackTextView.text];
    [feedback setFk_user:[Model_User loadFromUserDefaults].pk_user];
    [feedback setDate:[NSDate date]];
    
    [SRNet_Manager requestNetWithDic:[SRNet_Manager feedBackMessageDic:feedback]
                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                [SVProgressHUD dismiss];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    //        [self.feedBackTextView resignFirstResponder];
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                });
                                
                                UIAlertView *feedBackAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"感谢您的反馈,我们将会努力做的更好." delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                
                                [feedBackAlert show];
                                
                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                
                            }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
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
