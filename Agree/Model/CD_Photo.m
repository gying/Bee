//
//  CD_Photo.m
//  Agree
//
//  Created by G4ddle on 15/6/15.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "CD_Photo.h"
#import "AppDelegate.h"


@implementation CD_Photo

@dynamic pk_photo;
@dynamic fk_group;
@dynamic fk_party;
@dynamic fk_user;
@dynamic path;
@dynamic create_time;
@dynamic type;
@dynamic remark;
@dynamic status;

+ (void)savePhotoToCD: (Model_Photo *)photo {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    Model_Photo *newPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"CD_Photo" inManagedObjectContext:context];
    newPhoto.pk_photo = photo.pk_photo;
    newPhoto.fk_group = photo.fk_group;
    newPhoto.fk_party = photo.fk_party;
    newPhoto.fk_user = photo.fk_user;
    newPhoto.path = photo.path;
    newPhoto.create_time = photo.create_time;
    newPhoto.type = photo.type;
    newPhoto.remark = photo.remark;
    newPhoto.status = photo.status;
    
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@"不能保存：%@",[error localizedDescription]);
    }
    
}

+ (NSMutableArray *)getPhotoFromCDByGroup: (Model_Group *)group {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CD_Photo" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"fk_group == %d", group.pk_group.intValue]];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *newPhotoArray = [[NSMutableArray alloc] init];
    
    for (CD_Photo *photo in fetchedObjects) {
        Model_Photo *newPhoto = [[Model_Photo alloc] init];
        newPhoto.pk_photo = photo.pk_photo;
        newPhoto.fk_group = photo.fk_group;
        newPhoto.fk_party = photo.fk_party;
        newPhoto.fk_user = photo.fk_user;
        newPhoto.path = photo.path;
        newPhoto.create_time = photo.create_time;
        newPhoto.type = photo.type;
        newPhoto.remark = photo.remark;
        newPhoto.status = photo.status;
        [newPhotoArray addObject:newPhoto];
    }
    
    return newPhotoArray;
}

+ (void)removePhotoFromCDByGroup: (Model_Group *)group {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CD_Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"fk_group == %d", group.pk_group.intValue];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (CD_Photo *photoCD in result) {
        [context deleteObject:photoCD];
//        break;
    }
    
    if ([context save:nil]) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

+ (void)removePhotoFromCD: (Model_Photo *)photo {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CD_Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"pk_photo == %@", photo.pk_photo];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (CD_Photo *photoCD in result) {
        [context deleteObject:photoCD];
        break;
    }
    
    if ([context save:nil]) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

+ (void)removeAllPhotoFromCD {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CD_Photo"];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (CD_Photo *photoCD in result) {
        [context deleteObject:photoCD];
    }
    
    if ([context save:nil]) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}


@end
