//
//  Model_Party_User.h
//  SRAgree
//
//  Created by G4ddle on 14/12/15.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model_Party_User : NSObject
@property (nonatomic, strong)NSNumber *pk_party_user;
@property (nonatomic, strong)NSString *fk_party;
@property (nonatomic, strong)NSNumber *fk_user;
@property (nonatomic, strong)NSNumber *type;
@property (nonatomic, strong)NSNumber *relationship;
@property (nonatomic, strong)NSNumber *syn_calendar;
@property (nonatomic, strong)NSNumber *status;

#pragma mark ver2
@property (nonatomic, strong)NSNumber *pay_count;
@property (nonatomic, strong)NSNumber *pay_amount;
//付款状态(1.未付, 2.已付, 3.代付(多人状态))
@property (nonatomic, strong)NSNumber *pay_type;


@end
