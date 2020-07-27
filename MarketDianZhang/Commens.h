//
//  Commens.h
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2017/12/5.
//  Copyright © 2017年 sfbm. All rights reserved.
//

#ifndef Commens_h
#define Commens_h
//必备第三方
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "MJExtension.h"
#import "MJRefresh.h"

//自定义工具
#import "CacheBox.h"
#import "UIView+Frame.h"
#import "NSString+isEnptyHP.h"
#import "MyAfnetwork.h"
#import "HTTPRequest.h"

#ifdef DEBUG

#define MYNSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define MYNSLog(...)
#endif

//屏幕的SIZE
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//获取最新导航栏高度
#define NAVIHEIGHT_X  [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height
//导航栏高度
#define kNavigationBarHeight 64
#define kTabbarHeight 49
#define kStatusBarHeight 20

//特定颜色
//颜色
#define RGBA(r,g,b,a)      [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

#define BASECOLOR  RGBA(51,150,251,1)
#define BASEVIEWBORDERCOLOR RGBA(30,45,57,1)
#define BASENAVICOLOR  RGBA(26,42,55,1)
#define BASEBLUECOLOR  RGBA(86,174,210,1)

#define DIARYCOLOR1  RGBA(229,91,80,1)
#define DIARYCOLOR2  RGBA(255,209,128,1)
#define DIARYCOLOR3  RGBA(255,255,141,1)
#define DIARYCOLOR4  RGBA(204,255,144,1)
#define DIARYCOLOR5  RGBA(167,255,235,1)
#define DIARYCOLOR6  RGBA(130,177,255,1)

#endif /* Commens_h */
