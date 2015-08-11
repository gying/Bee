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

#import "WXApi.h"
#import "UserSettingViewController.h"

#import <ALBB_OSS_IOS_SDK/ALBBOSSServiceProvider.h>
#import <ALBB_OSS_IOS_SDK/OSSTool.h>


#import "RootViewController.h"

@protocol SRReceivingDelegate <NSObject>

@optional
- (void)receivingData: (id)revData;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (nonatomic, weak)UserChatViewController *userChatDelegate;
@property (nonatomic, weak)GroupViewController *groupDelegate;
@property (nonatomic, weak)ContactsTableViewController *contactsDelegate;

@property (nonatomic, strong)UITabBarController *rootController;

@property (nonatomic, strong)NSString *jPushString;
@property (nonatomic, strong)NSString *deviceToken;


@property(strong , nonatomic)RootViewController * rootViewController;

@property (nonatomic, strong)id<ALBBOSSServiceProtocol> ossService;

@property (nonatomic, strong)UIViewController<WXApiDelegate> *wechatViewController;

//接收代理
@property (nonatomic, strong)id<SRReceivingDelegate>revDelegate;
@property (nonatomic, strong)UIViewController *topRootViewController;

- (void)logout;

@end

