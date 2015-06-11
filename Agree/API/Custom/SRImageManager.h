//
//  SRImageManager.h
//  Agree
//
//  Created by G4ddle on 15/1/22.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//建立代理协议
@protocol SRImageManagerDelegate <NSObject>

@optional

//- (void)imageUpladDone;
- (void)imageUpladError;

- (void)imageDelDone;
- (void)imageDelError;

- (void)imageUploadDoneWithFieldID: (NSString *)fieldID;

@end

@interface SRImageManager : NSObject

//以建立代理协议的模式初始化
- (id)initWithDelegate: (id<SRImageManagerDelegate>)delegate;

+ (UIImage *)getSubImage:(UIImage *)image withRect:(CGRect)rect;


- (BOOL)updateImageToTXY: (UIImage *)image;

@property (nonatomic, weak)id<SRImageManagerDelegate> delegate;


//获取原始图片
+ (NSURL *)originalImageFromTXYFieldID: (NSString *)fieldID;
//小组封面
+ (NSURL *)groupFrontCoverImageFromTXYFieldID: (NSString *)fieldID;
//相册缩略图
+ (NSURL *)albumThumbnailImageFromTXYFieldID: (NSString *)fieldID;
//头像
+ (NSURL *)avatarImageFromTXYFieldID: (NSString *)fieldID;
//头像小图
+ (NSURL *)miniAvatarImageFromTXYFieldID: (NSString *)fieldID;
@end
