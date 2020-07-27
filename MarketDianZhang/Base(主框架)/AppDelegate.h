//
//  AppDelegate.h
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2017/12/5.
//  Copyright © 2017年 sfbm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property(nonatomic, strong) UITabBarController *rootTabbarCtr;
- (void)saveContext;


@end

