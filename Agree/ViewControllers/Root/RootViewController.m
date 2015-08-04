//
//  RootViewController.m
//  Agree
//
//  Created by Agree on 15/8/4.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loginRegView.hidden = NO;
    self.loginView.hidden = YES;
    self.regView.hidden = YES;
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *file = [bundle pathForResource:@"beagree_test" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:file];
    
    self.moviePlayer =[[MPMoviePlayerController alloc] initWithContentURL:url];
    
    [self.moviePlayer setScalingMode:MPMovieScalingModeAspectFill];
    self.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    [self.moviePlayer setRepeatMode:MPMovieRepeatModeOne];
    [self.moviePlayer prepareToPlay];
    [self.moviePlayer]
    [self.moviePlayer.view setFrame:self.view.bounds];  // player的尺寸
//    [self.view addSubview: self.moviePlayer.view];
    [self.view insertSubview:self.moviePlayer.view atIndex:0];
    
    self.moviePlayer.shouldAutoplay=YES;
    
//    UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, 260, 100)];
//    [logoLabel setTextColor:[UIColor whiteColor]];
//    [logoLabel setText:@"必聚"];
//    [logoLabel setTextAlignment:NSTextAlignmentCenter];
//    [logoLabel setFont:[UIFont systemFontOfSize:80]];
//    [self.view addSubview:logoLabel];
    

}
- (IBAction)loginButton:(id)sender {
    
    NSLog(@"登陆");
    self.loginRegView.hidden = YES;
    self.loginView.hidden = NO;
}
- (IBAction)regButton:(id)sender {
    
    NSLog(@"注册");
    self.loginRegView.hidden=YES;
    self.regView.hidden=NO;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ((self.loginRegView.hidden = YES)) {
        self.loginRegView.hidden = NO;
        self.loginView.hidden = YES;
        self.regView.hidden = YES;
    }
}





















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
