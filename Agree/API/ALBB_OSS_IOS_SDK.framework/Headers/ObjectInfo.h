//
//  ALBBObjectInfo.h
//  OSS_IOS_SDK_Demo
//
//  Created by 郭天 on 15/4/4.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectInfo : NSObject

@property (nonatomic) NSString *objectKey;

@property (nonatomic) NSString *lastModified;

@property (nonatomic) NSString *Etag;

@property (nonatomic) NSString *type;

@property (nonatomic) long long size;

@end
