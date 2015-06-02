//
//  SRMoveArray.m
//  Agree
//
//  Created by G4ddle on 15/4/3.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "SRMoveArray.h"

@implementation NSMutableArray (SRMoveArray)

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    if (to != from) {
        id obj = [self objectAtIndex:from];
        [self removeObjectAtIndex:from];
        if (to >= [self count]) {
            [self addObject:obj];
        } else {
            [self insertObject:obj atIndex:to];
        }
    }
}
@end

