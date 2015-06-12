//
//  SRShimmerManager.m
//  Agree
//
//  Created by G4ddle on 15/6/12.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "SRShimmerManager.h"
#import <SVProgressHUD.h>

@implementation SRShimmerManager

+ (FBShimmeringView *)createNaviShimmeringTitleView: (UIView *)naviView withTitle: (NSString *)naviTitle{
    FBShimmeringView *titleView = [[FBShimmeringView alloc] initWithFrame:CGRectMake(60, 30, [UIScreen mainScreen].bounds.size.width - 120, 30)];
    [naviView addSubview:titleView];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:titleView.bounds];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.text = NSLocalizedString(naviTitle, nil);
    
    titleView.shimmeringSpeed = 100;
    titleView.shimmeringOpacity = 0.9;
    titleView.contentView = loadingLabel;
    
    titleView.shimmering = YES;
    
    return titleView;
}

@end
