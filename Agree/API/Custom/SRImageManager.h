//
//  SRImageManager.h
//  Agree
//
//  Created by G4ddle on 15/1/22.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ALBB_OSS_IOS_SDK/OSSBucket.h>
#import <ALBB_OSS_IOS_SDK/OSSData.h>

#define kAvatar             @"avatar"
#define kMiniAvatar         @"mini-avatar"
#define kAlbumThumbnail     @"album-thumbnail"
#define kGroupFrontCover    @"group-front-cover"


@interface SRImageManager : NSObject

+ (UIImage *)getSubImage:(UIImage *)image withRect:(CGRect)rect;


#pragma mark - OSS图片处理
+ (NSURL *)originalImageFromOSS: (NSString *)imagePath;
+ (NSURL *)avatarImageFromOSS: (NSString *)imagePath;
+ (NSURL *)miniAvatarImageFromOSS: (NSString *)imagePath;
+ (NSURL *)albumThumbnailImageFromOSS: (NSString *)imagePath;
+ (NSURL *)groupFrontCoverImageImageFromOSS: (NSString *)imagePath;


+ (OSSData *)initImageOSSData: (UIImage *)uploadImage withKey: (NSString *)keyString;

@end
