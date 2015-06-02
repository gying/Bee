//
//  Model_Photo.h
//  SRAgree
//
//  Created by G4ddle on 14/12/15.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Model_Photo : NSObject
@property (nonatomic, strong)NSString *pk_photo;
@property (nonatomic, strong)NSNumber *fk_group;
@property (nonatomic, strong)NSString *fk_party;
@property (nonatomic, strong)NSNumber *fk_user;
@property (nonatomic, strong)NSString *path;
@property (nonatomic, strong)NSDate *create_time;
@property (nonatomic, strong)NSNumber *type;
@property (nonatomic, strong)NSString *remark;
@property (nonatomic, strong)NSNumber *status;



@end
