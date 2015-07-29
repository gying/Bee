//
//  CD_Group_User.m
//  Agree
//
//  Created by G4ddle on 15/6/16.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "CD_Group_User.h"
#import "AppDelegate.h"

@implementation CD_Group_User

@dynamic pk_group_user;
@dynamic fk_group;
@dynamic fk_user;
@dynamic message_warn;
@dynamic party_warn;
@dynamic public_phone;
@dynamic remarks_name;
@dynamic role;
@dynamic status;
@dynamic nickname;
@dynamic avatar_path;

+ (void)saveGroupUserToCD: (Model_Group_User *)groupUser {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    CD_Group_User *newGroupUser = [NSEntityDescription insertNewObjectForEntityForName:@"CD_Group_User" inManagedObjectContext:context];
    
    newGroupUser.pk_group_user = groupUser.pk_group_user;
    newGroupUser.fk_group = groupUser.fk_group;
    newGroupUser.fk_user = groupUser.fk_user;
    newGroupUser.message_warn = groupUser.message_warn;
    newGroupUser.party_warn = groupUser.party_warn;
    newGroupUser.public_phone = groupUser.public_phone;
    newGroupUser.remarks_name = groupUser.remarks_name;
    newGroupUser.role = groupUser.role;
    newGroupUser.status = groupUser.status;
    newGroupUser.nickname = groupUser.nickname;
    newGroupUser.avatar_path = groupUser.avatar_path;
    
    
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@"不能保存：%@",[error localizedDescription]);
    }
    
}

+ (NSMutableArray *)getGroupUserFromCD {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CD_Group_User" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *newGroupUserArray = [[NSMutableArray alloc] init];
    
    for (CD_Group_User *groupUser in fetchedObjects) {
        Model_Group_User *newGroupUser = [[Model_Group_User alloc] init];
        newGroupUser.pk_group_user = groupUser.pk_group_user;
        newGroupUser.fk_group = groupUser.fk_group;
        newGroupUser.fk_user = groupUser.fk_user;
        newGroupUser.message_warn = groupUser.message_warn;
        newGroupUser.party_warn = groupUser.party_warn;
        newGroupUser.public_phone = groupUser.public_phone;
        newGroupUser.remarks_name = groupUser.remarks_name;
        newGroupUser.role = groupUser.role;
        newGroupUser.status = groupUser.status;
        newGroupUser.nickname = groupUser.nickname;
        newGroupUser.avatar_path = groupUser.avatar_path;
        [newGroupUserArray addObject:newGroupUser];
    }
    
    return newGroupUserArray;
    
}

+ (NSMutableArray *)getGroupUserFromCDByGroup: (Model_Group *)group {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CD_Group_User" inManagedObjectContext:context];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"fk_group == %d", group.pk_group.intValue];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *newGroupUserArray = [[NSMutableArray alloc] init];
    
    for (CD_Group_User *groupUser in fetchedObjects) {
        Model_Group_User *newGroupUser = [[Model_Group_User alloc] init];
        newGroupUser.pk_group_user = groupUser.pk_group_user;
        newGroupUser.fk_group = groupUser.fk_group;
        newGroupUser.fk_user = groupUser.fk_user;
        newGroupUser.message_warn = groupUser.message_warn;
        newGroupUser.party_warn = groupUser.party_warn;
        newGroupUser.public_phone = groupUser.public_phone;
        newGroupUser.remarks_name = groupUser.remarks_name;
        newGroupUser.role = groupUser.role;
        newGroupUser.status = groupUser.status;
        newGroupUser.nickname = groupUser.nickname;
        newGroupUser.avatar_path = groupUser.avatar_path;
        [newGroupUserArray addObject:newGroupUser];
    }
    
    return newGroupUserArray;
    
}

+ (void)removeGroupUserFromCD: (Model_Group_User *)groupUser {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CD_Group_User"];
    request.predicate = [NSPredicate predicateWithFormat:@"pk_group_user == %d", groupUser.pk_group_user.intValue];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (CD_Group_User *groupUserCD in result) {
        [context deleteObject:groupUserCD];
    }
    
    // 5. 通知_context保存数据
    if ([context save:nil]) {

    } else {

    }
}

+ (void)removeGroupUserFromCDByGroup: (Model_Group *)group {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CD_Group_User"];
    request.predicate = [NSPredicate predicateWithFormat:@"fk_group == %d", group.pk_group.intValue];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (CD_Group_User *groupUserCD in result) {
        [context deleteObject:groupUserCD];
    }
    
    // 5. 通知_context保存数据
    if ([context save:nil]) {

    } else {
    }
}

+ (void)removeAllGroupUserFromCD {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CD_Group_User"];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (CD_Group_User *groupUserCD in result) {
        [context deleteObject:groupUserCD];
    }
    
    // 5. 通知_context保存数据
    if ([context save:nil]) {

    } else {

    }
}

@end
