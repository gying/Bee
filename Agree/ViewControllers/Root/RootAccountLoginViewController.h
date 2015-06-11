//
//  RootAccountLoginViewController.h
//  Agree
//
//  Created by G4ddle on 15/4/5.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_User.h"


#import "WXApiObject.h"
@protocol RootAccountRegViewController <NSObject>

- (void) sendAuthRequest;

@end
@interface RootAccountLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (nonatomic, strong)Model_User *userInfo;

@property (nonatomic, assign) id<RootAccountRegViewController,NSObject> delegate;

- (void)popToRootController;





@end
