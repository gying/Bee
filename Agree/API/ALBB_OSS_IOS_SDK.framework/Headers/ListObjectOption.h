//
//  ALBBListObjectOption.h
//  OSS_IOS_SDK_Demo
//
//  Created by 郭天 on 15/4/4.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListObjectOption : NSObject

@property (nonatomic) NSString *delimiter;

@property (nonatomic) NSString *marker;

@property (nonatomic) int maxKeys;

@property (nonatomic) NSString *prefix;


- (NSString *)genQueryString;

@end
