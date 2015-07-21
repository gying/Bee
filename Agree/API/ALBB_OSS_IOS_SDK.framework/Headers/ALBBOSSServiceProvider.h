//
//  ALBBOSSService.h
//  OSS_SDK
//
//  Created by 郭天 on 15/3/18.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALBBOSSServiceProtocol.h"

@interface ALBBOSSServiceProvider : NSObject<ALBBOSSServiceProtocol>

/*!
 @property
 @abstract 记录用户设置时间和本机时间差
 */
@property (nonatomic) NSTimeInterval calibrateTime;

/*!
 @method
 @abstract 获取oss service单例
 */
+ (ALBBOSSServiceProvider *)getService;

@end
