//
//  SRChatLabel.m
//  Agree
//
//  Created by G4ddle on 15/2/16.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "SRChatLabel.h"

@implementation SRChatLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawTextInRect:(CGRect)rect {
    //文字距离上下左右边框都有10单位的间隔
    CGRect newRect = CGRectMake(rect.origin.x + 10, rect.origin.y + 10, rect.size.width - 20, rect.size.height -20);
    [super drawTextInRect:newRect];
}

@end
