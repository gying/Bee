//
//  CD_Party.m
//  Agree
//
//  Created by G4ddle on 15/6/16.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "CD_Party.h"
#import "AppDelegate.h"

@implementation CD_Party

@dynamic pk_party;
@dynamic fk_group;
@dynamic name;
@dynamic remark;
@dynamic begin_time;
@dynamic end_time;
@dynamic tip_time;
@dynamic longitude;
@dynamic latitude;
@dynamic location;
@dynamic fk_user;
@dynamic status;
@dynamic relationship;
@dynamic pk_party_user;
@dynamic inNum;

#pragma mark V2
@dynamic pay_type;
@dynamic pay_amount;
@dynamic pay_fk_user;
@dynamic interval;

+ (Model_Party *)packedCDPartyToModel:(CD_Party *)party {
    
    Model_Party *newParty = [[Model_Party alloc] init];
    newParty.pk_party = party.pk_party;
    newParty.fk_group = party.fk_group;
    newParty.name = party.name;
    newParty.remark = party.remark;
    newParty.begin_time = party.begin_time;
    newParty.end_time = party.end_time;
    newParty.tip_time = party.tip_time;
    newParty.longitude = party.longitude;
    newParty.latitude = party.latitude;
    newParty.location = party.location;
    newParty.fk_user = party.fk_user;
    newParty.status = party.status;
    newParty.relationship = party.relationship;
    newParty.pk_party_user = party.pk_party_user;
    newParty.inNum = party.inNum;
    
    newParty.pay_type = party.pay_type;
    newParty.pay_amount = party.pay_amount;
    newParty.pay_fk_user = party.pay_fk_user;
    newParty.interval = party.interval;
    
    return newParty;
}

+ (CD_Party *)packedModelPartyToCD: (Model_Party *)party withCD: (CD_Party *)cd_party {
    
    cd_party.pk_party = party.pk_party;
    cd_party.fk_group = party.fk_group;
    cd_party.name = party.name;
    cd_party.remark = party.remark;
    cd_party.begin_time = party.begin_time;
    cd_party.end_time = party.end_time;
    cd_party.tip_time = party.tip_time;
    cd_party.longitude = party.longitude;
    cd_party.latitude = party.latitude;
    cd_party.location = party.location;
    cd_party.fk_user = party.fk_user;
    cd_party.status = party.status;
    cd_party.relationship = party.relationship;
    cd_party.pk_party_user = party.pk_party_user;
    cd_party.inNum = party.inNum;
    
    cd_party.pay_type = party.pay_type;
    cd_party.pay_amount = party.pay_amount;
    cd_party.pay_fk_user = party.pay_fk_user;
    cd_party.interval = party.interval;

    return cd_party;
}

+ (void)savePartyToCD: (Model_Party *)party {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    CD_Party *newParty = [NSEntityDescription insertNewObjectForEntityForName:@"CD_Party" inManagedObjectContext:context];
    [self packedModelPartyToCD:party withCD:newParty];
    NSError *error;
    if(![context save:&error]) {
        NSLog(@"不能保存：%@",[error localizedDescription]);
    }
}

+ (NSMutableArray *)getPartyFromCD {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CD_Party" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *newPartyArray = [[NSMutableArray alloc] init];
    
    for (CD_Party *party in fetchedObjects) {
        [newPartyArray addObject:[self packedCDPartyToModel:party]];
    }
    
    return newPartyArray;
    
}

+ (void)removePartyFromCD: (Model_Party *)party {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CD_Party"];
    request.predicate = [NSPredicate predicateWithFormat:@"pk_party == %@", party.pk_party];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (CD_Party *partyCD in result) {
        [context deleteObject:partyCD];
        break;
    }
    
    // 5. 通知_context保存数据
    if ([context save:nil]) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

+ (NSMutableArray *)getPartyFromCDByRelation: (int)relation {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CD_Party" inManagedObjectContext:context];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"relationship == %d", relation];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"begin_time" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *newPartyArray = [[NSMutableArray alloc] init];
    
    for (CD_Party *party in fetchedObjects) {
        [newPartyArray addObject:[self packedCDPartyToModel:party]];
    }
    return newPartyArray;
}

+ (NSMutableArray *)getPartyFromCDForSchedule {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CD_Party" inManagedObjectContext:context];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"relationship != 2"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"begin_time" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *newPartyArray = [[NSMutableArray alloc] init];
    
    for (CD_Party *party in fetchedObjects) {
        [newPartyArray addObject:[self packedCDPartyToModel:party]];
    }
    return newPartyArray;
}



+ (NSMutableArray *)getPartyFromCDByGroup: (Model_Group *)group {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CD_Party" inManagedObjectContext:context];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"fk_group == %d", group.pk_group.intValue];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *newPartyArray = [[NSMutableArray alloc] init];
    
    for (CD_Party *party in fetchedObjects) {
        [newPartyArray addObject:[self packedCDPartyToModel:party]];
    }
    return newPartyArray;
}

+ (void)removePartyFromCDByGroup: (Model_Group *)group {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CD_Party"];
    request.predicate = [NSPredicate predicateWithFormat:@"fk_group == %d", group.pk_group.intValue];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (CD_Party *partyCD in result) {
        [context deleteObject:partyCD];
    }
    
    // 5. 通知_context保存数据
    if ([context save:nil]) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}

+ (void)removeAllPartyFromCD {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CD_Party"];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (CD_Party *partyCD in result) {
        [context deleteObject:partyCD];
    }
    
    // 5. 通知_context保存数据
    if ([context save:nil]) {
        NSLog(@"删除成功");
    } else {
        NSLog(@"删除失败");
    }
}


@end
