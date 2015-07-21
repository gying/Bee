//
//  ALBBListObjectResult.h
//  OSS_IOS_SDK_Demo
//
//  Created by 郭天 on 15/4/4.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListObjectResult : NSObject

@property (nonatomic) NSString *bucketName;

@property (nonatomic) NSString *prefix;

@property (nonatomic) NSString *marker;

@property (nonatomic) NSString *delimiter;

@property (nonatomic) int maxKeys;

@property (nonatomic) NSString *nextMarker;

@property (nonatomic) BOOL isTruckcated;

@property (nonatomic) NSMutableArray *objectList;

@property (nonatomic) NSMutableArray *commonPrefixList;

@end
