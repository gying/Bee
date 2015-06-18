//
//  CD_User.m
//  Agree
//
//  Created by G4ddle on 15/6/16.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "CD_User.h"
#import "AppDelegate.h"


@implementation CD_User

@dynamic pk_user;
@dynamic nickname;
@dynamic avatar_path;
@dynamic phone;
@dynamic password;
@dynamic setup_time;
@dynamic last_login_time;
@dynamic sex;
@dynamic jpush_id;
@dynamic device_id;
@dynamic status;
@dynamic relationship;
@dynamic chat_update;
@dynamic relationship_update;



+ (void)saveUserToCD: (Model_User *)user {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    CD_User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"CD_User" inManagedObjectContext:context];
    
    newUser.pk_user = user.pk_user;
    newUser.nickname = user.nickname;
    newUser.avatar_path = user.avatar_path;
    newUser.phone = user.phone;
    newUser.password = user.password;
    newUser.setup_time = user.setup_time;
    newUser.last_login_time = user.last_login_time;
    newUser.sex = user.sex;
    newUser.jpush_id = user.jpush_id;
    newUser.device_id = user.jpush_id;
    newUser.status = user.status;
    newUser.relationship = user.relationship;
    newUser.chat_update = user.chat_update;
    newUser.relationship_update = user.relationship_update;
    
    
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@"不能保存：%@",[error localizedDescription]);
    }
    
}

+ (NSMutableArray *)getUserFromCD {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CD_User" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *newUserArray = [[NSMutableArray alloc] init];
    
    for (CD_User *user in fetchedObjects) {
        Model_User *newUser = [[Model_User alloc] init];
        newUser.pk_user = user.pk_user;
        newUser.nickname = user.nickname;
        newUser.avatar_path = user.avatar_path;
        newUser.phone = user.phone;
        newUser.password = user.password;
        newUser.setup_time = user.setup_time;
        newUser.last_login_time = user.last_login_time;
        newUser.sex = user.sex;
        newUser.jpush_id = user.jpush_id;
        newUser.device_id = user.jpush_id;
        newUser.status = user.status;
        newUser.relationship = user.relationship;
        newUser.chat_update = user.chat_update;
        newUser.relationship_update = user.relationship_update;
        [newUserArray addObject:newUser];
    }
    return newUserArray;
}

+ (void)removeUserFromCD: (Model_User *)user {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CD_User"];
    request.predicate = [NSPredicate predicateWithFormat:@"pk_user == %d", user.pk_user.intValue];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (CD_User *userCD in result) {
        [context deleteObject:userCD];
        break;
    }
    
    // 5. 通知_context保存数据
    if ([context save:nil]) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}


@end
