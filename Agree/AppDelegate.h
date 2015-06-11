//
//  AppDelegate.h
//  Agree
//
//  Created by G4ddle on 15/1/15.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GroupChatTableViewController.h"
#import "GroupDetailViewController.h"
#import "GroupViewController.h"
#import "UserChatViewController.h"
#import "ScheduleTableViewController.h"
#import "TXYUploadManager.h"


#import "WXApi.h"
#import "RootAccountLoginViewController.h"






@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootAccountLoginViewController *viewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (nonatomic, weak)GroupDetailViewController *chatDelegate;
@property (nonatomic, weak)UserChatViewController *userChatDelegate;
@property (nonatomic, weak)GroupViewController *groupDelegate;
@property (nonatomic, weak)ContactsTableViewController *contactsDelegate;
@property (nonatomic, weak)ScheduleTableViewController *scheduleDelegate;

@property (nonatomic, strong)UITabBarController *rootController;

@property (nonatomic, strong)NSString *jPushString;
@property (nonatomic, strong)NSString *deviceToken;

@property (nonatomic, strong)TXYUploadManager *uploadManager;




- (void)logout;

@end

