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

- (void)imageUpladDone;
- (void)imageUpladError;

- (void)imageDelDone;
- (void)imageDelError;

- (void)imageUploadDoneWithFieldID: (NSString *)fieldID;

@end

@interface SRImageManager : NSObject

//以建立代理协议的模式初始化
- (id)initWithDelegate: (id<SRImageManagerDelegate>)delegate;

//上传头像信息
- (NSString *)updateAvatarImageToBucket: (UIImage *)image;
- (NSString *)updateImageToBucket: (UIImage *)image;

+ (UIImage *)getSubImage:(UIImage *)image withRect:(CGRect)rect;

- (NSString *)updateGroupCoverToBucket: (UIImage *)image;
- (void)delImage:(NSString *)imageName;


- (BOOL)updateImageToTXY: (UIImage *)image;

@property (nonatomic, weak)id<SRImageManagerDelegate> delegate;


//获取原始图片
+ (NSString *)originalImageFromTXYFieldID: (NSString *)fieldID;

@end
