//
//  CacheBox.h
//  Seller
//
//  Created by 毛宏鹏 on 16/8/16.
//  Copyright © 2016年 sfbm. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USER_MOBILE                @"mobile"
#define USER_ID                    @"userid"
#define USER_TOKEN                 @"usertoken"
#define USER_VERITY                @"verify"
#define USER_NAME                  @"username"
#define USER_ICON                  @"userPortrait"

#define TOKEN_DATE     @"tokenDate"//token保存日期

#define CHARGER_NAME  @"chargeName" //充电宝名称
#define FIRST_BORROW @"firstBorrow" //是否开始借

//极光推送 退出不清空
#define USER_REDISTRATIONID          @"registrationID"
//是否开启推送
#define USER_REGIST_BOOL          @"registratbool"
//保证一台设备今天n个用户最多签到n次
#define TODAYDATEID    @"todayDateIdentifier"
#define IDFV_USERID    @"idfv_userid"
#define IDFV_USERDATE  @"idfv_userdate"
//本地数据库版本
#define TABLEVERSION_DIARY           @"tableversiondiary"

@interface CacheBox : NSObject

//将数据保存到沙盒
+ (void)saveCacheValue:(id)value forKey:(NSString *)key;

//读取本地沙盒
+ (id)getCacheWithKey:(NSString *)key;

+ (void)removeObjectValue:(NSString *)key;
//判断是否登录
+ (BOOL)didLogin;
//退出登录
+ (void)LoginOutNow;

+(BOOL)haveBLE; //是否有蓝牙
+(void)addChargerWithName:(NSString *)chargerName; //添加充电宝
+ (void)removeCharger; //移除充电宝

//判断是否需要签到 value是用户的userId   key是IDFV_USERID
+ (BOOL)upUserIdCacheArray:(id)value forKey:(NSString *)key;
@end
