//
//  FederationToken.h
//  ALBB_OSS_IOS_SDK
//
//  Created by 郭天 on 15/6/1.
//  Copyright (c) 2015年 郭 天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSSFederationToken : NSObject

@property (nonatomic, strong) NSString *ak;
@property (nonatomic, strong) NSString *sk;
@property (nonatomic, strong) NSString *tempToken;
@property (nonatomic, strong) NSNumber *expiration;

- (instancetype)initWithAk:(NSString *)ak sk:(NSString *)sk tempToken:(NSString *)tempToken expiration:(NSNumber *)expiration;

@end
