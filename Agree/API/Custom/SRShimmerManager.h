//
//  SRShimmerManager.h
//  Agree
//
//  Created by G4ddle on 15/6/12.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FBShimmeringView.h>

@interface SRShimmerManager : NSObject

+ (FBShimmeringView *)createNaviShimmeringTitleView: (UIView *)naviView withTitle: (NSString *)naviTitle;

@end
