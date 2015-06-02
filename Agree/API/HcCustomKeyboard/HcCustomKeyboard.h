//
//  HcCustomKeyboard.h
//  Custom
//
//  Created by 黄诚 on 14/12/18.
//  Copyright (c) 2014年 huangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol HcCustomKeyboardDelegate <NSObject>

@required
- (void)talkBtnClick:(UITextView *)textViewGet;
- (void)imageBtnClick;

@end

@interface HcCustomKeyboard : NSObject<UITextViewDelegate>

@property (nonatomic,assign) id<HcCustomKeyboardDelegate>mDelegate;
@property (nonatomic,strong)UIView *mBackView;
@property (nonatomic,strong)UIView *mTopHideView;
@property (nonatomic,strong)UITextView * mTextView;
@property (nonatomic,strong)UIView *mHiddeView;
@property (nonatomic,strong)UIViewController *mViewController;
@property (nonatomic,strong)UIView *mSecondaryBackView;
@property (nonatomic,strong)UIButton *mTalkBtn;
@property (nonatomic,strong)UIButton *mImageBtn;
@property (nonatomic,strong)UIImageView *sendPicImg;
@property (nonatomic) BOOL isTop;//用来判断评论按钮的位置
@property BOOL isDone; //用来判断是否界面已完成读取,以免产生错位

+(HcCustomKeyboard *)customKeyboard;

//-(void)textViewShowView:(UIViewController *)viewController customKeyboardDelegate:(id)delegate;

-(void)textViewShowView:(UIViewController *)viewController customKeyboardDelegate:(id)delegate withMoveView: (UIView *)moveView;

@end
