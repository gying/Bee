//
//  Model_User.m
//  SRAgree
//
//  Created by G4ddle on 14/12/15.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import "Model_User.h"
#import "MJExtension.h"

@implementation Model_User

- (void)saveToUserDefaults {
    [[NSUserDefaults standardUserDefaults] setObject:self.keyValues forKey:kDefUser];
}

+ (Model_User *)loadFromUserDefaults {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kDefUser]) {
        return [Model_User objectWithKeyValues:[[NSUserDefaults standardUserDefaults] objectForKey:kDefUser]];
    }
    return nil;
}

@end
