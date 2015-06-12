//
//  AppDelegate.m
//  Agree
//
//  Created by G4ddle on 15/1/15.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "AppDelegate.h"
#import "ScheduleTableViewController.h"
#import "APService.h"
#import "SRNet_Manager.h"
#import <SVProgressHUD.h>
#import "RootAccountLoginViewController.h"

#import "BMapKit.h"
#import "SDImageCache.h"

#import "EaseMob.h"


#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]

@interface AppDelegate () <EMChatManagerDelegate, SRNetManagerDelegate>

@end

@implementation AppDelegate {
    SRNet_Manager *_netManager;
    BMKMapManager *_mapManager;
    NSString *_token;
    
    BOOL _viewForLogin;
}


- (void)logout {
    for(UIViewController *viewController in self.rootController.viewControllers)
    {
        if([viewController isKindOfClass:[UINavigationController class]])
            [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
        [(UINavigationController *)viewController removeFromParentViewController];
    }
    [self.rootController removeFromParentViewController];
    
    //如果未注册,则开始注册流程
    Model_User *regUser = [[Model_User alloc] init];
    //设置uuid作为账户唯一码
//    [regUser setPk_user:[[[NSUUID alloc] init] UUIDString]];
    //设置串号id
    [regUser setDevice_id:_token];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
    RootAccountLoginViewController *rootController = [sb instantiateViewControllerWithIdentifier:@"rootAccountLogin"];
    rootController.userInfo = regUser;
    
    [self.window setRootViewController:rootController];
}

//环信接收到了离线的数据
- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages {
    NSNumber *updateValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"contact_update"];
    for (EMMessage *message in offlineMessages) {
        
        
        if (message.isGroup) {
            //小组信息
        } else {
            //私聊信息
            
            updateValue = [NSNumber numberWithInt: updateValue.intValue + 1];
            [[NSUserDefaults standardUserDefaults] setObject:updateValue forKey:@"contact_update"];
        }
    }
    
    if (updateValue) {
        //更新小组标识
        [(UIViewController *)[self.rootController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = updateValue.stringValue;
    }
}

- (void)didReceiveMessage:(EMMessage *)message {
    //这里收到了信息
    if (message.isGroup) {
        //群聊
        if (self.chatDelegate) {
            //处于某小组的详情界面中
            if ([message.from isEqualToString:self.chatDelegate.group.em_id]) {
                //处于同一小组的界面中,进行刷新
            } else {
                //处于不同小组
                [self.groupDelegate addGroupChatUpdateStatus:message.from];
            }
        } else {
            //处于小组详情外
            [self.groupDelegate addGroupChatUpdateStatus:message.from];
            if (!self.groupDelegate) {
                int badgeNum = [(UIViewController *)[self.rootController.viewControllers objectAtIndex:0] tabBarItem].badgeValue.intValue;
                if (badgeNum) {
                    badgeNum += 1;
                    [(UIViewController *)[self.rootController.viewControllers objectAtIndex:0] tabBarItem].badgeValue = [NSNumber numberWithInt:badgeNum].stringValue;
                }
            }
        }
    } else {
        //非群聊
        if (self.contactsDelegate) {
//            [self.contactsDelegate.tableView reloadData];
            [self.contactsDelegate reloadTableViewAndUnreadData];
        } else {
//            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"contact_update"];
            
            
            NSNumber *updateValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"contact_update"];
            updateValue = [NSNumber numberWithInt: updateValue.intValue + 1];
            [[NSUserDefaults standardUserDefaults] setObject:updateValue forKey:@"contact_update"];
            
            if (updateValue) {
                [(UIViewController *)[self.rootController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = updateValue.stringValue;
            }
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //清理sdimage
//    [[SDImageCache sharedImageCache] clearDisk];
//    [[SDImageCache sharedImageCache] clearMemory];
    
    //registerSDKWithAppKey:注册的appKey，详细见下面注释。
    //apnsCertName:推送证书名(不需要加后缀)，详细见下面注释。
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"superrabbit#superrabbit" apnsCertName:@"AgreeIOSPush_Dev" otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:NO]}];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];

    //自定义消息的集成
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    [[UITabBar appearance] setTintColor:AgreeBlue];

    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"e09S04Q9hzgYN8RnHo46gPcR"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    //清除推送的消息
    [APService clearAllLocalNotifications];
    [APService setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //腾讯云
    if (!_netManager) {
        _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
        [_netManager imageManagerSign];
    }

    //推送设置
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //判断进入的界面
    //查找用户id
//    NSNumber *user_id = [Model_User loadFromUserDefaults].pk_user;
    if ([Model_User loadFromUserDefaults]) {
        //拥有用户id
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
        self.rootController = [sb instantiateViewControllerWithIdentifier:@"rootTabbar"];
        [self.window setRootViewController:self.rootController];
        
    } else {
        _viewForLogin = TRUE;
        
        //如果未注册,则开始注册流程
        Model_User *regUser = [[Model_User alloc] init];
        //设置uuid作为账户唯一码
//        [regUser setPk_user:[[[NSUUID alloc] init] UUIDString]];
//        //设置串号id
//        _token = token;
//        [regUser setDevice_id:_token];
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryBoard" bundle:nil];
        RootAccountLoginViewController *rootController = [sb instantiateViewControllerWithIdentifier:@"rootAccountLogin"];
        rootController.userInfo = regUser;
        
        [self.window setRootViewController:rootController];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//app进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

//app从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    
    //清除推送的消息
    [APService clearAllLocalNotifications];
    [APService setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //暂时不使用环信的推送功能
//    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
    //获取到设备串号,开始注册帐号
    //处理串号格式
    NSString *token = [[NSString alloc] init];
    token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    self.deviceToken = token;
    
    
    // Required
    //根据串号注册极光推送
    [APService registerDeviceToken:deviceToken];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jPushLoginDone) name:kJPFNetworkDidLoginNotification object:nil];
}

- (void)jPushLoginDone {
    //jpush的串号获取成功
    self.jPushString = [APService registrationID];
    
    if (_viewForLogin) {    //登录流程
        
    } else {    //直接进入流程,更新用户资料
        Model_User *updateUser = [[Model_User alloc] init];
        updateUser.pk_user = [Model_User loadFromUserDefaults].pk_user;
        updateUser.device_id = self.deviceToken;
        updateUser.jpush_id = self.jPushString;
        
        if (!_netManager) {
            _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
        }
        [_netManager updateUserInfo:updateUser];
    }
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Error in registration. Error: %@", error);
//    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
//    NSLog(@"error -- %@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //这里接受本地刷新信息
    // Required
    [APService handleRemoteNotification:userInfo];
    
}

//自定义消息的回调方法
//应用内
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];
    
    /*
     1.聊天推送
     2.聚会信息推送
     3.相册图片推送
     
     5.关系更新推送
     */
    
    
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    //    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    
    NSNumber *typeTag = [extras objectForKey:@"type_tag"];
    
    switch (typeTag.intValue) {
        case 2: {   //聚会信息推送消息
            NSNumber *pk_group = [extras objectForKey:@"pk_group"];
            if (self.chatDelegate) {
                if ([pk_group isEqualToNumber:self.chatDelegate.group.pk_group]) {
                    //处于同一小组的界面中,进行刷新
                    [self.chatDelegate receiveParty];
                    
                } else {
                    //处于不同小组
                    [self.groupDelegate addGroupPartyUpdateStatus:pk_group];
                }
                
                //标注主日程更新
                NSNumber *updateValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"party_update"];
                updateValue = [NSNumber numberWithInt: updateValue.intValue + 1];
                [[NSUserDefaults standardUserDefaults] setObject:updateValue forKey:@"party_update"];
            } else if (self.scheduleDelegate) { //如果在主日程界面
                //则在主日程进行刷新
                [self.scheduleDelegate refresh:nil];
            } else {
                [self.groupDelegate addGroupPartyUpdateStatus:pk_group];
                //标注主日程更新
                NSNumber *updateValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"party_update"];
                updateValue = [NSNumber numberWithInt: updateValue.intValue + 1];
                [[NSUserDefaults standardUserDefaults] setObject:updateValue forKey:@"party_update"];
                
            }
        }
            break;
        case 3: {   //小组相册更新
            
        }
            break;
            
        case 5: {   //用户关系更新
            if (self.contactsDelegate) {
                [self.contactsDelegate loadDataFromNet];
            } else {
                NSNumber *updateValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"relation_update"];
                updateValue = [NSNumber numberWithInt: updateValue.intValue + 1];
                [[NSUserDefaults standardUserDefaults] setObject:updateValue forKey:@"relation_update"];
                
//                if (updateValue) {
//                    [(UIViewController *)[self.rootController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = updateValue.stringValue;
//                }
                
                int badgeNum = [(UIViewController *)[self.rootController.viewControllers objectAtIndex:2] tabBarItem].badgeValue.intValue;
                if (badgeNum) {
                    badgeNum += 1;
                    [(UIViewController *)[self.rootController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [NSNumber numberWithInt:badgeNum].stringValue;
                } else {
                    [(UIViewController *)[self.rootController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = @"1";
                }
            }
        }
            break;
        case 6: {   //好友请求获得通过,只需要刷新好友列表
            if (self.contactsDelegate) {
                [self.contactsDelegate loadDataFromNet];
            } else {
                int badgeNum = [(UIViewController *)[self.rootController.viewControllers objectAtIndex:2] tabBarItem].badgeValue.intValue;
                if (badgeNum) {
                    badgeNum += 1;
                    [(UIViewController *)[self.rootController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [NSNumber numberWithInt:badgeNum].stringValue;
                } else {
                    [(UIViewController *)[self.rootController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = @"1";
                }
            }
        }
            break;
        default:
            break;
    }
    
}

//应用外的推送信息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //这里接收本地刷新信息
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}



#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.superRabbit.Agree" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Agree" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Agree.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)interfaceReturnDataSuccess:(id)jsonDic with:(int)interfaceType {
    [SVProgressHUD dismiss];
    switch (interfaceType) {
        case kUpdateUserInfo: {
        
        }
            break;
        case kImageManagerSign: {
            if (jsonDic) {
                [TXYUploadManager authorize:@"201139" userId:[Model_User loadFromUserDefaults].pk_user.stringValue sign:(NSString *)jsonDic];
                self.uploadManager = [[TXYUploadManager alloc] initWithPersistenceId: @"persistenceId"];
            }
            
        }
        default:
            break;
    }
}


- (void)interfaceReturnDataError:(int)interfaceType {
    [SVProgressHUD dismiss];
}




@end
