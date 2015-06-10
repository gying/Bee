//
//  SRKeyboard.m
//  Agree
//
//  Created by G4ddle on 15/5/8.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "SRKeyboard.h"

//屏幕宽度
#define WIDTH_SCREEN [UIScreen mainScreen].applicationFrame.size.width
//屏幕高度
#define HEIGHT_SCREEN [UIScreen mainScreen].applicationFrame.size.height

#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]

@implementation SRKeyboard {
    CGRect _keyboardRect;
    UIView *_moveView;
    CGPoint _initPoint;
}

//初始化键盘界面
-(void)textViewShowView:(UIViewController *)viewController customKeyboardDelegate:(id)delegate withMoveView: (UIView *)moveView
{
    _moveView = moveView;
    self.mViewController =viewController;
    self.mDelegate =delegate;
    
    //BACKVIEW
    self.mBackView =[[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-45, WIDTH_SCREEN, 45)];
    self.mBackView.backgroundColor =[UIColor colorWithWhite:0.1 alpha:1.0];
    [self.mViewController.view addSubview:self.mBackView];
    
    //TEXTVIEW
    self.mTextView =[[UITextView alloc]initWithFrame:CGRectMake(53, 9, WIDTH_SCREEN-70, 27)];
    [self.mTextView.layer setCornerRadius:2.5];
    [self.mTextView setFont:[UIFont systemFontOfSize:18.0]];
    self.mTextView.delegate = self;
    self.mTextView.text = @"";
    self.mTextView.textContainer.lineBreakMode = NSLineBreakByClipping;
    self.mTextView.returnKeyType = UIReturnKeySend;
    self.mTextView.layoutManager.allowsNonContiguousLayout = NO;
    self.mTextView.contentInset = UIEdgeInsetsMake(3, 0, 0, 0);
    [self.mBackView addSubview:self.mTextView];
    
    //选择照片的IMAGE
    self.sendPicImg =[[UIImageView alloc]initWithFrame:CGRectMake(15, 13, 20, 20)];
    self.sendPicImg.image =[UIImage imageNamed:@"agree_send_picture.pdf"];
    [self.mBackView addSubview:self.sendPicImg];
    
    //选择照片的BUTTON
    self.mImageBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.mImageBtn setTitle:@"" forState:UIControlStateNormal];
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
        [self.mTextView setText:@""];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initTextViewFrame];
        });
        
        
        //        [self.mTextView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    return YES;
}

- (void)forImage {
    [self.mDelegate imageBtnClick];
}

- (void)hideView {
    [self.mTextView resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification*)notification //键盘出现
{
        _keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
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

            if (0 == _initPoint.x) {
                _initPoint = self.mViewController.view.center;
            }
            self.mViewController.view.center = CGPointMake(_initPoint.x, _initPoint.y - _keyboardRect.size.height);
        } completion:^(BOOL finished) {
            
        }];
}

- (void)keyboardWillHide:(NSNotification *)notification //键盘下落
{
        [UIView animateWithDuration:0.3 animations:^{
            self.mHiddeView.alpha =0.0f;
            
            
            self.mViewController.view.center = _initPoint;
            _initPoint.x = 0;
            _initPoint.y = 0;
            
            self.mBackView.frame = CGRectMake(0, HEIGHT_SCREEN-25, WIDTH_SCREEN, 45);
            self.mTextView.frame = CGRectMake(53, 9, WIDTH_SCREEN-70, 27);
            
            
            
        } completion:^(BOOL finished) {
            [self.mHiddeView removeFromSuperview];
            self.mHiddeView =nil;
            self.mTextView.text =@""; //键盘消失时，恢复TextView内容
        }];
        self.mImageBtn.hidden = NO;
        self.sendPicImg.hidden = NO;
        
}
- (void)textViewDidChange:(UITextView *)textView {
    
}


- (void)textDidChanged:(NSNotification *)notif //监听文字改变 换行时要更改输入框的位置
{


    

    [UIView animateWithDuration:0.3 animations:^{

        CGSize tvcontentSize = self.mTextView.contentSize;
        if (tvcontentSize.height > 140) {
            return;
        }
        
        CGRect selfFrame = self.mBackView.frame;
        CGFloat selfHeight = self.mTextView.frame.origin.y*2  + tvcontentSize.height;
        CGFloat selfOriginY = selfFrame.origin.y - (selfHeight - selfFrame.size.height);
        
        selfFrame.origin.y = selfOriginY;
        selfFrame.size.height = selfHeight;
        
        self.mBackView.frame = selfFrame;
        //     self.mTextView.frame =CGRectMake(10, 9, WIDTH_SCREEN-70+45, tvcontentSize.height);
        self.mTextView.frame = CGRectMake(10, 9, WIDTH_SCREEN-70+45, selfFrame.size.height -19);
        
        
        
        
        self.mImageBtn.hidden = YES;
        self.sendPicImg.hidden = YES;
    }];
    
}


- (void)initTextViewFrame {
    CGRect textFrame=[[self.mTextView layoutManager]usedRectForTextContainer:[self.mTextView textContainer]];
    CGSize contentSize = textFrame.size;
    //如果超过最大空间则直接返回
    contentSize.height =30;

    
    CGRect selfFrame = self.mBackView.frame;
    CGFloat selfHeight = self.mTextView.frame.origin.y * 2  + contentSize.height;
    
    
    CGFloat selfOriginY = selfFrame.origin.y - (selfHeight - selfFrame.size.height);
    selfFrame.origin.y = selfOriginY;
    selfFrame.size.height = selfHeight;
    self.mBackView.frame = selfFrame;
    

    self.mTextView.frame =CGRectMake(10, 9, WIDTH_SCREEN-70+45, selfHeight-18);
    
//    self.mTextView.contentInset = self.mTextView.contentInset.bottom;
//    self.mTextView.contentIn
//    [self.mTextView setContentInset:self.mTextView.contentInset.bottom];
//    [self.mTextView setContentOffset:CGPointMake(self.mTextView.contentInset.left, self.mTextView.contentInset.bottom)];
//    self.mTextView.scrollIndicatorInsets.bottom = self.mTextView.contentInset.bottom;
    [self.mTextView scrollRangeToVisible:self.mTextView.selectedRange];
    
}

- (void)dealloc //移除通知
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

@end
