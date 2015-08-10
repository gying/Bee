//
//  PrepayViewController.h
//  Agree
//
//  Created by Agree on 15/7/20.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SRPayDelegate <NSObject>

@required
- (void)inputAmount: (NSNumber *)amount;

@end

@interface PrepayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *payTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property id<SRPayDelegate> delegate;

@end
