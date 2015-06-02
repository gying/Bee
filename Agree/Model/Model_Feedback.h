//
//  Model_Feedback.h
//  SRAgree
//
//  Created by G4ddle on 14/12/15.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model_Feedback : NSObject

@property (nonatomic, strong)NSNumber *pk_feedback;
@property (nonatomic, strong)NSNumber *fk_user;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSDate *date;
@property (nonatomic, strong)NSNumber *type;
@property (nonatomic, strong)NSNumber *status;

@end
