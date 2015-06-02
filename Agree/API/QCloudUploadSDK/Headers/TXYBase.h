//
//  TXYBase.h
//
//  Created by Tencent on 1/19/15.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/***************************** 用户请求任务结构 ********************************/
/**
 *  腾讯云所有上传任务的基类
 */
@interface TXYTask : NSObject <NSCoding>
/** 上传任务的唯一标示，内部维护 */
@property (nonatomic, assign, readonly)    int64_t               taskId;
@end

/*!
 @enum TXYFileType enum
 @abstract 文件的类型.
 */
typedef NS_ENUM(NSInteger, TXYFileType)
{
    /** 图片文件 */
    TXYFileTypePhoto = 1,
    /** 音频文件 */
    TXYFileTypeAudio,
    /** 视频文件 */
    TXYFileTypeVideo,
    /** 其他类型文件 */
    TXYFileTypeOther,
};

/**
 *  腾讯云文件上传的基类，不可直接用做上传参数，
 *  必须使用TXYPhotoUploadTask或者TXYVideoUploadTask
 */
@interface TXYUploadTask : TXYTask <NSCoding>
/** 文件的路径，用户必填 */
@property (nonatomic, readonly)    NSString            *filePath;
/** 文件上传请求后通知用户业务后台的信息，用户选填 */
@property (nonatomic, readonly)    NSString            *msgContext;
@end

/**
 * 图片文件上传任务
 */
@interface TXYPhotoUploadTask : TXYUploadTask <NSCoding>

/** 图片过期的时间，单位为相对发送时间的天数，用户选填 */
@property (nonatomic, assign, readonly)    unsigned int        expiredDate;

/*!
 * @brief 图片上传任务初始化函数
 * @param filePath 图片路径，必填
 * @return TXYPhotoUploadTask实例
 */
- (instancetype)initWithPath:(NSString *)filePath;

/*!
 * @brief 图片上传任务初始化函数
 * @param filePath 图片路径，必填
 * @param expiredDate 过期时间，选填
 * @param msgContext  通知用户业务后台的信息，选填
 * @return TXYPhotoUploadTask实例
 */
- (instancetype)initWithPath:(NSString *)filePath
                 expiredDate:(unsigned int)expiredDate
                  msgContext:(NSString *)msgContext;
@end


/**
 * 视频文件上传任务
 */
@interface TXYVideoUploadTask : TXYUploadTask <NSCoding>

/** 视频标题，用户选填 */
@property (nonatomic, readonly)    NSString            *videoTitle;
/** 视频描述，用户选填 */
@property (nonatomic, readonly)    NSString            *videoDesc;
/** 以视频第几帧作为封面 */
@property (nonatomic, assign, readonly)    unsigned int        coverFrame;

/*!
 * @brief 视频上传任务初始化函数
 * @param filePath 视频路径，必填
 * @return TXYVideoUploadTask实例
 */
- (instancetype)initWithPath:(NSString *)filePath;

/*!
 * @brief 视频上传任务初始化函数
 * @param filePath 视频路径，必填
 * @param videoTitle 视频标题，选填
 * @param videoDesc 视频描述信息,选填
 * @param coverFrame 以视频第几帧作为封面，选填
 * @param msgContext  通知用户业务后台的信息，选填
 * @return TXYVideoUploadTask实例
 */
- (instancetype)initWithPath:(NSString *)filePath title:(NSString *)videoTitle
                        desc:(NSString *)videoDesc coverFrame:(unsigned int)coverFrame
                     msgContext:(NSString *)msgContext;

@end


/**
 *  腾讯云文件命令的基类，不可直接用做上传参数，
 *  必须使用具体子类，如TXYFileMoveCommand，TXYFileDeleteCommand或者TXYPhotoStatCommand
 */
@interface TXYCommandTask : TXYUploadTask
/** 操作URL，必填  */
@property (nonatomic, readonly)    NSString            *commandURL;

/*!
 * @brief 初始化方法
 * @param commandURL 要操作的URL
 * @return TXYCommandTask实例
 */
- (instancetype)initWithURL:(NSString *)commandURL;

@end


/**
 *  文件复制命令
 */
@interface TXYFileCopyCommand : TXYCommandTask
@end


/**
 * 文件删除命令,视频不支持复制功能
 */
@interface TXYFileDeleteCommand : TXYCommandTask
@end


/**
 * 文件查询命令
 */
@interface TXYFileStatCommand : TXYCommandTask
@end



/***************************** 后台回包信息 ********************************/
/**
 * 后台回包的基类
 */
@interface TXYTaskRsp : NSObject
/** 任务描述代码，为retCode >= 0时标示成功，为负数表示为失败 */
@property (nonatomic, assign)    int                    retCode;
/** 任务描述信息 */
@property (nonatomic, strong)    NSString               *descMsg;
@end

/**
 * 图片上传任务的回包
 */
@interface TXYPhotoUploadTaskRsp : TXYTaskRsp
/** 成功后，后台返回图片的url，由上传模块维护 */
@property (nonatomic, strong)    NSString               *photoURL;
/** 成功后，后台返回图片文件的key*/
@property (nonatomic, strong)    NSString               *photoFileId;
@end

/**
 * 视频上传任务的回包
 */
@interface TXYVideoUploadTaskRsp : TXYTaskRsp
/** 成功后，后台返回视频的url */
@property (nonatomic, strong)    NSString               *videoURL;
/** 成功后，后台返回视频文件的key*/
@property (nonatomic, strong)    NSString               *videoFileId;
/** 视频封面的url*/
@property (nonatomic, strong)    NSString               *coverURL;
/** 成功后，后台返回封面图片的key*/
@property (nonatomic, strong)    NSString               *coverFileId;
@end

/**
 *  文件复制命令的回包
 */
@interface TXYFileCopyCommandRsp : TXYTaskRsp
/** 复制图片的URL */
@property (nonatomic, strong)    NSString               *copiedURL;
@end


/**
 *  文件删除命令的回包
 */
@interface TXYFileDeleteCommandRsp : TXYTaskRsp
@end


@class TXYFileInfo;
/**
 *  文件查询命令的回包
 */
@interface TXYFileStatCommandRsp : TXYTaskRsp
/** 成功时，图片基本信息 @see <TXYFileInfo> */
@property (nonatomic, strong)    TXYFileInfo       *fileInfo;
@end



/**
 * 文件的基本信息
 */
@interface TXYFileInfo : NSObject

/** 查询文件的id */
@property (nonatomic, strong)    NSString        *fileId;
/** 查询文件的URL */
@property (nonatomic, strong)    NSString        *fileURL;
/** 查询文件的类型 */
@property (nonatomic, assign)    TXYFileType     fileType;
/** 额外的文件信息，详情参见开发文档 */
@property (nonatomic, strong)   NSDictionary     *extendInfo;

@end






