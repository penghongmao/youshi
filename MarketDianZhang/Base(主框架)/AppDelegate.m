//
//  AppDelegate.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2017/12/5.
//  Copyright © 2017年 sfbm. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "Commens.h"
#import "GLaunchManager.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
//#import <AdSupport/AdSupport.h>
//static NSString *appKey = @"0c6a25dc7f76a559d8f1523a";
//static NSString *channel = @"AppStore";
//#ifdef DEBUG // 开发
//static BOOL const isProduction = FALSE; // 极光FALSE为开发环境
//#else // 生产
//static BOOL const isProduction = TRUE; // 极光TRUE为生产环境
//#endif


//@interface AppDelegate ()<JPUSHRegisterDelegate>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //状态栏字体为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    [self initRootVC];
    
    //适配iOS11 解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; //iOS11 解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题
    }
    //添加根控制器
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    BaseTabBarController *tabBarC1 = [[BaseTabBarController alloc] init];
//    self.window.rootViewController = tabBarC1;
    [self.window makeKeyAndVisible];
    
    [[GLaunchManager sharedInstance] launchInWindow:self.window];
    
    //==========极光推送代码如下=======
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
//    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
//    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        // 可以添加自定义categories
//        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
//        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
//    }
//    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
//    
//    
//    // Required
//    // init Push
//    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
//    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
//    [JPUSHService setupWithOption:launchOptions appKey:appKey
//                          channel:channel
//                 apsForProduction:isProduction
//            advertisingIdentifier:nil];
//    //获取 registrationID
//    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
//        if(resCode == 0){
//            MYNSLog(@"registrationID获取成功：%@",registrationID);
//            [CacheBox saveCacheValue:registrationID forKey:USER_REDISTRATIONID];
//            
//        }
//        else{
//            [CacheBox saveCacheValue:@"" forKey:USER_REDISTRATIONID];
//            
//            MYNSLog(@"registrationID获取失败，code：%d",resCode);
//        }
//    }];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"MarketDianZhang"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark--极光推送  JPUSHRegisterDelegate
//- (void)application:(UIApplication *)application
//didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//
//    /// Required - 注册 DeviceToken
//    [JPUSHService registerDeviceToken:deviceToken];
//}
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    //Optional
//    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
//}
//// iOS 10 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
//    // Required
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    MYNSLog(@"iOS10程序在前台时收到的推送111userInfo: %@", userInfo);
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//        MYNSLog(@"iOS10程序在前台时收到的推送222userInfo: %@", userInfo);
//
//    }
//    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
//}
//
//// iOS 10 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
//    // Required
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//        MYNSLog(@"iOS10程序关闭后通过点击推送进入程序弹出的通知:userInfo %@", userInfo);
//
//    }
//    completionHandler();  // 系统要求执行这个方法
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    MYNSLog(@"收到通知22userInfo:%@", userInfo);
//    NSString *alertStr = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//    MYNSLog(@"收到通知内容22alertStr:%@", alertStr);//此处对消息处理，跳转不同页面
//    // Required, iOS 7 Support
//    [JPUSHService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//
//    // Required,For systems with less than or equal to iOS6
//    [JPUSHService handleRemoteNotification:userInfo];
//}
//
////推送  收到自定义消息(非APNs)
//- (void)networkDidReceiveMessage:(NSNotification *)notification {
//    NSDictionary * userInfo = [notification userInfo];
//    //    NSString *content = [userInfo valueForKey:@"content"];
//    NSDictionary *content = [userInfo valueForKey:@"content"];
////    NSString *content = [extras valueForKey:@"content"]; //服务端传递的Extras附加字段，key是自己定义的
//    //    NSString *msgTitle = [userInfo valueForKey:@"title"]; //服务端传递的Extras附加字段，key是自己定义的
////    if (_alertStr.length>0&&[mesgType isEqualToString:@"message"]) {
////        //收到推送类型是message 并且从通知栏点击进来
////        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
////        UIViewController *VC = [sb instantiateViewControllerWithIdentifier:@"SFBMMyMessageViewController"];
////
////        UINavigationController *currentNavi = [self getCurrentVC];
////
////        [currentNavi pushViewController:VC animated:YES];
////
////    }else if (_alertStr.length==0&&[mesgType isEqualToString:@"message"]){
////        //收到推送类型是message 并且没有从通知栏点击进来
////        [personalViewController addNotificationCount];
////    }
//
//    NSLog(@"userInfo===%@--%@",userInfo,content);
//    // 程序在前台或通过点击推送进来的会弹这个alert
//    NSString *message = [NSString stringWithFormat:@"%@", userInfo[@"content"] ];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
//
//}



@end
