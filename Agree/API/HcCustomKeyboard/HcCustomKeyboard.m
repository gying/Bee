//
//  HcCustomKeyboard.m
//  Custom
//
//  Created by 黄诚 on 14/12/18.
//  Copyright (c) 2014年 huangcheng. All rights reserved.
//

#import "HcCustomKeyboard.h"
#import <UIKit/UIKit.h>
#import "GroupDetailViewController.h"
#import "UserChatViewController.h"

//屏幕宽度
#define WIDTH_SCREEN [UIScreen mainScreen].applicationFrame.size.width
//屏幕高度
#define HEIGHT_SCREEN [UIScreen mainScreen].applicationFrame.size.height

#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]


@implementation HcCustomKeyboard {
    CGRect _keyboardRect;
    CGPoint _initPoint;
    BOOL _isInitPoint;
    UIView *_moveView;
}
@synthesize mDelegate;

static HcCustomKeyboard *customKeyboard = nil;

+(HcCustomKeyboard *)customKeyboard
{
    @synchronized(self)
    {
        if (customKeyboard == nil)
        {
            customKeyboard = [[HcCustomKeyboard alloc] init];
        }
        return customKeyboard;
    }
}
+(id)allocWithZone:(struct _NSZone *)zone //确保使用者alloc时 返回的对象也是实例本身
{
    @synchronized(self)
    {
        if (customKeyboard == nil)
        {
            customKeyboard = [super allocWithZone:zone];
        }
        return customKeyboard;
    }
}
+(id)copyWithZone:(struct _NSZone *)zone //确保使用者copy时 返回的对象也是实例本身
{
    return customKeyboard;
}

-(void)textViewShowView:(UIViewController *)viewController customKeyboardDelegate:(id)delegate withMoveView: (UIView *)moveView
{
    _moveView = moveView;
    self.mViewController =viewController;
    self.mDelegate =delegate;
    self.isTop = YES;//初始化的时候设为NO
 
    _isInitPoint = false;
    
    self.mBackView =[[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-45, WIDTH_SCREEN, 45)];
//    NSLog(@"%p",self.mBackView);
    self.mBackView.backgroundColor =[UIColor colorWithWhite:0.1 alpha:1.0];
    [self.mViewController.view addSubview:self.mBackView];
    
//    self.mSecondaryBackView =[[UIView alloc]initWithFrame:CGRectMake(80, 10, WIDTH_SCREEN-50-100, 30)];
//    self.mSecondaryBackView.backgroundColor =[UIColor darkGrayColor];
//    [self.mBackView addSubview:self.mSecondaryBackView];
    
    self.mTextView =[[UITextView alloc]initWithFrame:CGRectMake(53, 10, WIDTH_SCREEN-70, 27)];
    self.mTextView.backgroundColor =[UIColor whiteColor];
    [self.mTextView.layer setCornerRadius:3.0];
    [self.mTextView setFont:[UIFont systemFontOfSize:14.0]];
    self.mTextView.delegate = self;
    self.mTextView.text = @"";
    self.mTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.mTextView.returnKeyType = UIReturnKeySend;
    [self.mBackView addSubview:self.mTextView];
    
    self.sendPicImg =[[UIImageView alloc]initWithFrame:CGRectMake(15, 13, 20, 20)];
    self.sendPicImg.image =[UIImage imageNamed:@"agree_send_picture.pdf"];
    [self.mBackView addSubview:self.sendPicImg];
    
//    self.mTalkBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [self.mTalkBtn setTitle:@"发送" forState:UIControlStateNormal];
//    [self.mTalkBtn.titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:14.0f]];
//    [self.mTalkBtn addTarget:self action:@selector(forTalk) forControlEvents:UIControlEventTouchUpInside];
//    self.mTalkBtn.frame =CGRectMake(WIDTH_SCREEN - 55, 0, 50, 50);
//    [self.mTalkBtn setTintColor:AgreeBlue];
//    [self.mBackView addSubview:self.mTalkBtn];
    
    self.mImageBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.mImageBtn setTitle:@"" forState:UIControlStateNormal];
//    [self.mImageBtn setBackgroundImage:[UIImage imageNamed:@"agree_send_picture.pdf"] forState:UIControlStateNormal];
    
    [self.mImageBtn addTarget:self action:@selector(forImage) forControlEvents:UIControlEventTouchUpInside];
    self.mImageBtn.frame =CGRectMake(0, 0, 50, 50);
    [self.mImageBtn setTintColor:AgreeBlue];
    [self.mBackView addSubview:self.mImageBtn];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.mDelegate talkBtnClick:textView];
        //输入文字不缩回键盘
        [textView setText:nil];
//        [self.mTextView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.mTextView resignFirstResponder];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.mTextView.text = nil;
    
    if (0 == self.mTextView.text.length) {
        [self.mTalkBtn setEnabled:NO];
        [self.mTalkBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    } else {
        [self.mTalkBtn setEnabled:YES];
        [self.mTalkBtn setTitleColor:AgreeBlue forState:UIControlStateNormal];
    }
    
    return YES;
}


- (void)forTalk {
    if (self.isTop ==NO) {
        [self.mTextView becomeFirstResponder];
    } else {
        [mDelegate talkBtnClick:self.mTextView];
        
        if (self.mTextView.text.length==0) {
            NSLog(@"内容为空");
        } else {
            [self.mTextView resignFirstResponder];
        }
    }
}

- (void)forImage {
    [mDelegate imageBtnClick];
}

- (void)hideView {
    [self.mTextView resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification*)notification //键盘出现
{
    
    if (self.isDone) {
        self.isTop = NO;
        _keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        //    NSLog(@"%f-%f",_keyboardRect.origin.y,_keyboardRect.size.height);
        
        if (!self.mHiddeView)
        {
            self.mHiddeView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,WIDTH_SCREEN,HEIGHT_SCREEN)];
            self.mHiddeView.backgroundColor =[UIColor blackColor];
            self.mHiddeView.alpha =0.0f;
            [self.mViewController.view addSubview:self.mHiddeView];
            
            UIButton *hideBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
            hideBtn.backgroundColor =[UIColor clearColor];
            hideBtn.frame = self.mHiddeView.frame;
            [hideBtn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
            [self.mHiddeView addSubview:hideBtn];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.mHiddeView.alpha =0.1f;
            
            [self.mViewController.view bringSubviewToFront:self.mBackView];
            
            if (_moveView) {
                if (!_isInitPoint) {
                    _initPoint = _moveView.center;
                    _isInitPoint = true;
                }
                
                _moveView.center = CGPointMake(_initPoint.x, _initPoint.y - _keyboardRect.size.height);
                self.mBackView.frame =CGRectMake(0, HEIGHT_SCREEN-_keyboardRect.size.height-25, WIDTH_SCREEN, 45);
            } else {
                if (!_isInitPoint) {
                    _initPoint = self.mViewController.view.center;
                    _isInitPoint = true;
                }
                self.mViewController.view.center = CGPointMake(_initPoint.x, _initPoint.y - _keyboardRect.size.height);
                //            self.mBackView.frame =CGRectMake(0, HEIGHT_SCREEN-_keyboardRect.size.height-25, WIDTH_SCREEN, 45);
            }
        } completion:^(BOOL finished) {
            
        }];
    }
}
- (void)keyboardWillHide:(NSNotification *)notification //键盘下落
{
    if (self.isDone) {
        self.isTop = NO;
        [UIView animateWithDuration:0.3 animations:^{
            //        self.mBackView.frame=CGRectMake(0, HEIGHT_SCREEN-25, WIDTH_SCREEN, 45);
            self.mHiddeView.alpha =0.0f;
            
            if (_moveView) {
                self.mBackView.frame=CGRectMake(0, HEIGHT_SCREEN-25, WIDTH_SCREEN, 45);
                self.mTextView.frame = CGRectMake(53, 10, WIDTH_SCREEN-70, 27);
                _moveView.center = _initPoint;
            } else {
                self.mBackView.frame=CGRectMake(0, HEIGHT_SCREEN-25, WIDTH_SCREEN, 45);
                self.mTextView.frame = CGRectMake(53, 10, WIDTH_SCREEN-70, 27);
                self.mViewController.view.center = _initPoint;
            }
        } completion:^(BOOL finished) {
            [self.mHiddeView removeFromSuperview];
            self.mHiddeView =nil;
            self.mTextView.text =@""; //键盘消失时，恢复TextView内容
        }];
        self.mImageBtn.hidden = NO;
        self.sendPicImg.hidden = NO;
        
        [self.mTalkBtn setEnabled:YES];
        [self.mTalkBtn setTitleColor:AgreeBlue forState:UIControlStateNormal];
    }
}
- (void)textDidChanged:(NSNotification *)notif //监听文字改变 换行时要更改输入框的位置
{
    if (0 == self.mTextView.text.length) {
        [self.mTalkBtn setEnabled:NO];
        [self.mTalkBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    } else {
        [self.mTalkBtn setEnabled:YES];
        [self.mTalkBtn setTitleColor:AgreeBlue forState:UIControlStateNormal];
    }
    
    //内容位置
    CGSize contentSize = self.mTextView.contentSize;
    //如果超过最大空间则直接返回
    if (contentSize.height > 140){
        return;
    }
    
    CGRect selfFrame = self.mBackView.frame;
    CGFloat selfHeight = self.mTextView.frame.origin.y * 2 - 2 + contentSize.height - (((int)contentSize.height%32)*6);
    NSLog(@"%d", (int)contentSize.height%32);
    NSLog(@"%d", (((int)contentSize.height%32)*5));
    NSLog(@"%f", selfHeight);
    CGFloat selfOriginY = selfFrame.origin.y - (selfHeight - selfFrame.size.height);
    selfFrame.origin.y = selfOriginY;
    selfFrame.size.height = selfHeight;
    self.mBackView.frame = selfFrame;
    
//    53, 10, WIDTH_SCREEN-110, 27
    self.mTextView.frame =CGRectMake(10, 10, WIDTH_SCREEN-70+45, selfHeight-25);
    
    self.mImageBtn.hidden = YES;
    self.sendPicImg.hidden = YES;

}

- (void)dealloc //移除通知
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

@end
