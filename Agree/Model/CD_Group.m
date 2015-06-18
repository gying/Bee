//
//  CD_Group.m
//  Agree
//
//  Created by G4ddle on 15/6/15.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "CD_Group.h"
#import "AppDelegate.h"



@implementation CD_Group

@dynamic pk_group;
@dynamic em_id;
@dynamic name;
@dynamic setup_time;
@dynamic last_post_time;
@dynamic last_post_message;
@dynamic avatar_path;
@dynamic remark;
@dynamic party_update;
@dynamic chat_update;
@dynamic photo_update;
@dynamic status;



+ (void)saveGroupToCD: (Model_Group *)group {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    CD_Group *newGroup = [NSEntityDescription insertNewObjectForEntityForName:@"CD_Group" inManagedObjectContext:context];
    
//    
//    CD_Group *newGroup = [[CD_Group alloc] init];
    newGroup.pk_group = group.pk_group;
    newGroup.em_id = group.em_id;
    newGroup.name = group.name;
    newGroup.setup_time = group.setup_time;
    newGroup.last_post_time = group.last_post_time;
    newGroup.last_post_message = group.last_post_message;
    newGroup.avatar_path = group.avatar_path;
    newGroup.remark = group.remark;
    newGroup.party_update = group.party_update;
    newGroup.chat_update = group.chat_update;
    newGroup.photo_update = group.photo_update;
    newGroup.status = group.status;
    
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@"不能保存：%@",[error localizedDescription]);
    }

}

+ (NSMutableArray *)getGroupFromCD {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CD_Group" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *newGroupArray = [[NSMutableArray alloc] init];
    
    for (CD_Group *group in fetchedObjects) {
        Model_Group *newGroup = [[Model_Group alloc] init];
        newGroup.pk_group = group.pk_group;
        newGroup.em_id = group.em_id;
        newGroup.name = group.name;
        newGroup.setup_time = group.setup_time;
        newGroup.last_post_time = group.last_post_time;
        newGroup.last_post_message = group.last_post_message;
        newGroup.avatar_path = group.avatar_path;
        newGroup.remark = group.remark;
        newGroup.party_update = group.party_update;
        newGroup.chat_update = group.chat_update;
        newGroup.photo_update = group.photo_update;
        newGroup.status = group.status;
        [newGroupArray addObject:newGroup];
    }
    
    return newGroupArray;
    
}

+ (void)removeGroupFromCD: (Model_Group *)group {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CD_Group"];
    request.predicate = [NSPredicate predicateWithFormat:@"pk_group == %d", group.pk_group.intValue];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (CD_Group *groupCD in result) {
        [context deleteObject:groupCD];
        break;
    }
    
    // 5. 通知_context保存数据
    if ([context save:nil]) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

+ (void)removeAllGroupFromCD {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CD_Group"];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (CD_Group *groupCD in result) {
        [context deleteObject:groupCD];
    }
    
    // 5. 通知_context保存数据
    if ([context save:nil]) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

@end
