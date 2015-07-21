//
//  OSSArgs.h
//  OSS_IOS_SDK
//
//  Created by 郭天 on 14/11/7.
//  Copyright (c) 2014年 郭 天. All rights reserved.
//

/*!
 @header OSSArgs.h
 @abstract Created by 郭天 on 14/11/7.
 */
#import <Foundation/Foundation.h>

typedef enum {
    PRIVATE,
    PUBLIC_READ,
    PUBLIC_READ_WRITE
} AccessControlList;

typedef enum {
    FEDERATION_TOKEN,
    ORIGIN_AKSK
} AuthenticationType;
/*!
 @constant
 @abstract content type 索引字段
 */
extern NSString * const HTTP_HEADER_FIELD_CONTENT_TYPE;
/*!
 @constant
 @abstract content length 索引字段
 */
extern NSString * const HTTP_HEADER_FIELD_CONTENT_LENGTH;
/*!
 @constant
 @abstract 加签索引字段
 */
extern NSString * const HTTP_HEADER_FIELD_AUTH;
/*!
 @constant
 @abstract 日期索引字段
 */
extern NSString * const HTTP_HEADER_FIELD_DATE;
/*!
 @constant
 @abstract 指定范围的索引字段
 */
extern NSString * const HTTP_HEADER_FIELD_BYTERANGE;
/*!
 @constant
 @abstract http请求头中的request id索引字段
 */
extern NSString * const HTTP_HEADER_FIELD_REQUEST_ID;

/*!
 @constant
 @abstract http请求头中的copy id字段
 */
extern NSString * const HTTP_HEADER_FIELD_COPY_ID;

/*!
 @constant
 @abstract 使用http://
 */
extern NSString * const HTTP_SCHEME;

/*!
 @constant
 @abstract bad request 字段
 */
extern NSInteger const HTTP_BAD_REQUEST;
/*!
 @constant
 @abstract 标示重定向返回码
 */
extern NSInteger const HTTP_REDIRECTION;

/*!
 @constant
 @abstract 标示成功返回码
 */
extern NSInteger const HTTP_SUCCESS;

/*!
 @constant
 @abstract 错误码字段
 */
extern NSString * const ERROR_CODE;

/*!
 @constant
 @abstract 错误信息字段
 */
extern NSString * const ERROR_MESSAGE;

/*!
 @constant
 @abstract host id索引字段
 */
extern NSString * const HOST_ID;

/*!
 @constant
 @abstract request id索引字段
 */
extern NSString * const REQUEST_ID;
/*!
 @constant
 @abstract 定义@“PUT”
 */
extern NSString * const HTTP_HEADER_FIELD_METHOD_PUT;
/*!
 @constant
 @abstract 定义@“GET”
 */
extern NSString * const HTTP_HEADER_FIELD_METHOD_GET;
/*!
 @constant
 @abstract 定义@“HEAD”
 */
extern NSString * const HTTP_HEADER_FIELD_METHOD_HEAD;
/*!
 @constant
 @abstract http请求头md5索引
 */
extern NSString * const HTTP_HEADER_FIELD_MDFIVE;
/*!
 @constant
 @abstract 计算文件块的大小
 */
extern long const CHUNK_SIZE;
/*!
 @constant
 @abstract user agent前缀
 */
extern NSString * const MBAAS_OSS_IOS_;
/*!
 @constant
 @abstract user agent 索引
 */
extern NSString * const HTTP_HEADER_FIELD_USER_AGENT;
/*!
 @constant
 @abstract 以kb为单位设定的数据块大小
 */
extern int const MULTIPART_UPLOAD_BLOCK_SIZE;
/*!
 @constant
 @abstract 网络请求尝试次数上限
 */
extern int const MAX_HTTP_REQUEST_ATTEMPTS;
/*!
 @constant
 @abstract http请求头中的referer字段索引
 */
extern NSString * const HTTP_HEADER_FIELD_REFERER;
/*!
 @constant
 @abstract OSS数据中心域名格式
 */
extern NSString * const ALIYUNCS;
/*!
 @constant
 @abstract 定义OSS SDK名字
 */
extern NSString * const OSS_SDK_NAME;
/*!
 @constant
 @abstract 定义OSS SDK版本号
 */
extern NSString * const OSS_SDK_Version;
/*!
 @constant
 @abstract 定义http header中的tempToken索引key
 */
extern NSString * const TEMP_TOKEN_KEY_IN_HTTP_HEADER;
/*!
 @constant
 @abstract 接入STS的情况下，放入获取到的url中的标示token的字段
 */
extern NSString * const SECURITY_TOKEN;
/*!
 @constant
 @abstract 标示listobject的xml的根节点
 */
extern NSString * const FATHER_ROOT;
/*!
 @constant
 @abstract 标示listobject的xml的contents子节点
 */
extern NSString * const CONTENTS_SON_ROOT;
/*!
 @constant
 @abstract 标示listObject的xml的commonPrefix子节点
 */
extern NSString * const COMMON_PREFIX_SON_ROOT;
/*!
 @constant
 @abstract 标示用户设置的数据为nil的异常处理
 */
extern NSString * const OSS_FILE_NOT_FOUND;

/*!
 @constant
 @abstract 标示oss异常
 */
extern NSString * const OSS_EXCEPTION;

/*!
 @constant
 @abstract 标示local异常
 */
extern NSString * const LOCAL_EXCEPTION;

/*!
 @constant
 @abstract 标示http头重Server字段
 */
extern NSString * const HTTP_SERVER_FIELD;

/*!
 @constant
 @abstract 标示阿里云OSS服务器名
 */
extern NSString * const ALIYUNOSS;

/*!
 @constant
 @abstract 标示阿里云服务器返回的x-oss-request-id字段
 */
extern NSString * const X_OSS_REQUEST_ID;

/*!
 @constant
 @abstract 断点下载分块大小
 */
extern int const RESUMABLE_DOWNLOAD_BLOCK_SIZE;

/*!
 @constant
 @abstract OSS服务器返回的http头中的标示请求文件的原始信息字段
 */
extern NSString * const CONTENT_RANGE;

/*!
 @constant
 @abstract 分块下载时OSS服务器返回的关于该object上次更改时间的字段
 */
extern NSString * const RESUMABLE_LAST_MODIFIED;

/*
 @constant
 @abstract 记录分块下载数据的目录名
 */
extern NSString * const OSS_RESUMABLE_DOWNLOAD_DIRECTORY;

/*
 @constant
 @abstract 标示xml数据解析中的content集合
 */
extern NSString * const CONTENTS_DICS;

/*
 @constant
 @abstract 标示xml数据解析中的commonPrefix集合
 */
extern NSString * const COMMON_PREFIX_DICS;

/*
 @constant
 @abstract 连接超时时间
 */
extern int const TIMEOUT_INTERVAL;

/*
 constant
 @abstract 临时token超时提前量
 */
extern int const BEFORE_EXPIREATION;
/*!
 @class
 @abstract 定义一些常量
 */
@interface OSSArgs : NSObject

@end

