//
//  SRKeyboard.h
//  Agree
//
//  Created by G4ddle on 15/5/8.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SRKeyboardDelegate <NSObject>

@required
- (void)talkBtnClick:(UITextView *)textViewGet;
- (void)imageBtnClick;

@end

@interface SRKeyboard : NSObject <UITextViewDelegate>


@property (nonatomic,assign) id<SRKeyboardDelegate>mDelegate;
@property (nonatomic,strong)UIViewController *mViewController;
@property (nonatomic,strong)UIView *mBackView;
@property (nonatomic,strong)UITextView * mTextView;

@property (nonatomic,strong)UIImageView *sendPicImg;
@property (nonatomic,strong)UIButton *mImageBtn;

@property (nonatomic,strong)UIView *mHiddeView;

-(void)textViewShowView:(UIViewController *)viewController customKeyboardDelegate:(id)delegate withMoveView: (UIView *)moveView;


@end
