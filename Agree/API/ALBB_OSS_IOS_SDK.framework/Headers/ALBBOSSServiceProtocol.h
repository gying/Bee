//
//  ALBBOSSServiceProtocol.h
//  OSS_SDK
//
//  Created by 郭天 on 15/3/20.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSSBucket.h"
#import "OSSData.h"
#import "OSSFile.h"
#import "OSSClient.h"
#import "OSSFederationToken.h"

@protocol ALBBOSSServiceProtocol <NSObject>

/*!
 @method
 @abstract 需要用户实现的加签block，参数依次为http request method、md5、content type、date、xoss和resource
 */
- (void)setGenerateToken:(NSString *(^)(NSString *, NSString *, NSString *, NSString *, NSString *, NSString *))token;

/*!
 @method
 @abstract 设置host id
 */
- (void)setGlobalDefaultBucketHostId:(NSString *)hostId;

/*!
 @method
 @abstract 设置Access Control List
 */
- (void)setGlobalDefaultBucketAcl:(AccessControlList)access;

/*!
 @method
 @abstract 设置获取临时凭证的回调
 */
- (void)setFederationTokenGetter:(OSSFederationToken *(^)())tokenGetter;

/*!
 @method
 @abstract 设置加签字符串计算方式
 */
- (void)setAuthenticationType:(AuthenticationType)typeOfTokenGenerator;

/*!
 @method
 @abstract 获取bucket实例
 */
- (OSSBucket *)getBucket:(NSString *)bucketName;

/*!
 @method
 @abstract 获取OSSData实例
 */
- (OSSData *)getOSSDataWithBucket:(OSSBucket *)bucket key:(NSString *)key;

/*!
 @method
 @abstract 获取OSSFile实例
 */
- (OSSFile *)getOSSFileWithBucket:(OSSBucket *)bucket key:(NSString *)key;

/*!
 @method
 @abstract 获取OSSMeta实例
 */
- (OSSMeta *)getOSSMetaWithBucket:(OSSBucket *)bucket key:(NSString *)key;

/*!
 @property
 @abstract 设置自定义时间
 */
- (void)setCustomStandardTimeWithEpochSec:(NSInteger)timeInterval;

@end
