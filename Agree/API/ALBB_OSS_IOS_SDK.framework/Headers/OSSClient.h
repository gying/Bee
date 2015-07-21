//
//  OSSClient.h
//  OSSDemo
//
//  Created by 郭天 on 14/11/3.
//  Copyright (c) 2014年 郭 天. All rights reserved.
//

/*!
 @header OSSClient.h
 @abstract Created by 郭天 on 14/11/3.
 */
#import <Foundation/Foundation.h>
#import "OSSData.h"
#import "OSSFile.h"
#import "OSSMeta.h"
#import "OSSFederationToken.h"

//#define OSS_LOGER 1

/*!
 @class
 @abstract 实现初始化函数、单例模式和对加签block的回调函数
 */
@interface OSSClient : NSObject
/*!
 @property
 @abstract 设置Access Control List
 */
@property (nonatomic)AccessControlList globalDefaultBucketAcl;
/*!
 @property
 @abstract 设置host id
 */
@property (nonatomic, strong)NSString *globalDefaultBucketHostId;
/*!
 @property
 @abstract 需要用户实现的加签block，参数依次为http request method、md5、content type、date、xoss和resource
 */
@property (nonatomic, strong)NSString * (^generateToken)(NSString *, NSString *, NSString *, NSString *, NSString *, NSString *);
/*!
 @property
 @abstract 用来存放各种各种异步操作线程
 */
@property (strong, nonatomic) NSOperationQueue* queue;
/*!
 @property
 @abstract 自定义user agent
 */
@property (strong, nonatomic)NSString *myAgent;

/*!
 @property
 @abstract 设置加签字符串计算方式
 */
@property (nonatomic) AuthenticationType authenticationType;
/*!
 @method
 @abstract 设置临时凭证，AK， SK， TempToken
 */
- (void)setOrUpdateFederationTokenWithTempAK:(NSString *)tempAK tempSK:(NSString *)tempSK securityToken:(NSString *)securityToken;
/*!
 @method
 @abstract 检查federationToken
 */
- (void)checkFederationToken;
/*!
 @method
 @abstract 设置获取临时凭证的回调
 */
- (void)setFederationTokenGetter:(OSSFederationToken *(^)())tokenGetter;

/*!
 @method
 @abstract 获取用户设置的临时token回调
 */
- (OSSFederationToken *(^)())getFederationTokenGetter;

/*!
 @method
 @abstract 缓存federationToken变量
 */
@property (nonatomic, strong) OSSFederationToken *federationToken;
/*!
 @property 
 @abstract 放在http header中的临时token
 */
@property (nonatomic, copy) NSString *tempToken;

/*!
 @property
 @abstract 获取federation token的回调
 */
@property (nonatomic, strong) OSSFederationToken *(^federationTokenGetter)();

/*!
 @method
 @abstract 实现单例模式
 */
+ (OSSClient *)sharedInstanceManage;

@end
