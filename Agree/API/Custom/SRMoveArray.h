//
//  SRMoveArray.h
//  Agree
//
//  Created by G4ddle on 15/4/3.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (SRMoveArray)

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;
@end
