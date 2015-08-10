//
//  MJPhotoToolbar.m
//  FingerNews
//
//  Created by mj on 13-9-24.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoToolbar.h"
#import "MJPhoto.h"
#import <SVProgressHUD.h>
//#import "MBProgressHUD+Add.h"
#import "SRTool.h"

@interface MJPhotoToolbar()
{
    // 显示页码
    UILabel *_indexLabel;
    UIButton *_saveImageBtn;
    UIButton *_delImageBtn;
}
@end

@implementation MJPhotoToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (_photos.count > 1) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont boldSystemFontOfSize:20];
        _indexLabel.frame = self.bounds;
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_indexLabel];
    }
    
    // 保存图片按钮
    CGFloat btnWidth = self.bounds.size.height;
    _saveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveImageBtn.frame = CGRectMake(20, 0, btnWidth, btnWidth);
    _saveImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_saveImageBtn setImage:[UIImage imageNamed:@"agree_image_save.pdf"] forState:UIControlStateNormal];
    [_saveImageBtn setImage:[UIImage imageNamed:@"agree_image_save.pdf"] forState:UIControlStateHighlighted];
    [_saveImageBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveImageBtn];
    
    //删除
    _delImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _delImageBtn.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - btnWidth, 0, btnWidth, btnWidth);
    _delImageBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_delImageBtn setImage:[UIImage imageNamed:@"agree_image_remove.pdf"] forState:UIControlStateNormal];
    [_delImageBtn setImage:[UIImage imageNamed:@"agree_image_remove.pdf"] forState:UIControlStateHighlighted];
    [_delImageBtn addTarget:self action:@selector(delImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_delImageBtn];
}

- (void)saveImage {
    [SRTool showSRAlertViewWithTitle:@"提示"
                             message:@"真的要把图片保存到自己的手机相册中吗?"
                   cancelButtonTitle:@"不,我再想想"
                    otherButtonTitle:@"是的"
               tapCancelButtonHandle:^(NSString *msgString) {
                   
               } tapOtherButtonHandle:^(NSString *msgString) {
                   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                       MJPhoto *photo = _photos[_currentPhotoIndex];
                       UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                   });
               }];
    
}

- (void)delImage {
    //图片删除确认警告框
    [SRTool showSRAlertViewWithTitle:@"提示"
                             message:@"真的要把这张图片删掉?"
                   cancelButtonTitle:@"不,我再想想"
                    otherButtonTitle:@"是的"
               tapCancelButtonHandle:^(NSString *msgString) {
                   
               } tapOtherButtonHandle:^(NSString *msgString) {
                   [self.delegate hide];
                   dispatch_async(dispatch_get_main_queue(), ^{
                       MJPhoto *photo = _photos[_currentPhotoIndex];
                       [photo.delegate deletePhoto:_currentPhotoIndex];
                   });
               }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    } else {
        MJPhoto *photo = _photos[_currentPhotoIndex];
        photo.save = YES;
        _saveImageBtn.enabled = NO;
        [SVProgressHUD showSuccessWithStatus:@"成功保存到相册"];
    }
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex {
    _currentPhotoIndex = currentPhotoIndex;
    
    // 更新页码
    _indexLabel.text = [NSString stringWithFormat:@"%d / %d", (int)_currentPhotoIndex + 1, (int)_photos.count];
    
    MJPhoto *photo = _photos[_currentPhotoIndex];
    // 按钮
//    _saveImageBtn.enabled = photo.image != nil && !photo.save;
    _saveImageBtn.enabled = YES;
    
    
    if (!photo.delegate) {
        _delImageBtn.enabled = NO;
    } else {
        _delImageBtn.enabled = YES;
    }
}

@end
