//
//  CacheBox.m
//  Seller
//
//  Created by 毛宏鹏 on 16/8/16.
//  Copyright © 2016年 sfbm. All rights reserved.
//
#define ChargerHeader @"SBC"
#import "CacheBox.h"

@implementation CacheBox

+ (void)saveCacheValue:(id)value forKey:(NSString *)key
{
    if (value) {
//        NSString *valueStr = [NSString stringWithFormat:@"%@",value];
        NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
        NSString *hash_key = [NSString stringWithFormat:@"cache-%@",key];
        [setting setObject:value forKey:hash_key];
        [setting synchronize];
    }
}
//判断是否需要签到
+ (BOOL)upUserIdCacheArray:(id)value forKey:(NSString *)key
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    NSString *hash_key = [NSString stringWithFormat:@"cache-%@",key];
    
    NSMutableArray *array = (NSMutableArray *)[setting objectForKey:hash_key];
    NSMutableArray *mutArr1 = [NSMutableArray arrayWithArray:array];
//    NSLog(@"mutArr1==%@",mutArr1);
    if (mutArr1.count==20) {
        [mutArr1 removeAllObjects];
        [mutArr1 addObject:value];
        [setting setObject:mutArr1 forKey:hash_key];
        [setting synchronize];

        [self upTheIdentifierAtIndex:0 forKey:IDFV_USERDATE];
        return YES;
        
    }else{
        if ([mutArr1 containsObject:value]) {
            NSInteger index = [mutArr1 indexOfObject:value];
            BOOL upBool = [self upTheIdentifierAtIndex:index forKey:IDFV_USERDATE];
            
            return upBool;
        }else{
            [self upTheIdentifierAtIndex:mutArr1.count forKey:IDFV_USERDATE];
            [mutArr1 addObject:value];
            [setting setObject:mutArr1 forKey:hash_key];
            [setting synchronize];
            return YES;
        }
    }
    
//    return YES;
}

+ (BOOL)upTheIdentifierAtIndex:(NSInteger )index forKey:(NSString *)key
{//获取当前日期
    NSDate* inputDate = [NSDate date];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[NSLocale currentLocale]];
    [inputFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *value = [inputFormatter stringFromDate:inputDate];
//    NSLog(@"value==%@", value);

    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    NSString *hash_key = [NSString stringWithFormat:@"cache-%@",key];
    NSMutableArray *array = (NSMutableArray *)[setting objectForKey:hash_key];
    NSMutableArray *mutArr1 = [NSMutableArray arrayWithArray:array];
//    NSLog(@"mutArr12==%@", mutArr1);

    if (mutArr1.count==20) {
        [mutArr1 removeAllObjects];
        [setting setObject:mutArr1 forKey:hash_key];
        [setting synchronize];

        return YES;

    }else{
        if (index == mutArr1.count) {//index==0或者index==mutArr1.count的时候
            [mutArr1 addObject:value];
            [setting setObject:mutArr1 forKey:hash_key];
            [setting synchronize];
            return YES;
        }else{
            NSString *indexString = [mutArr1 objectAtIndex:index];
            if ([indexString isEqualToString:value]) {
                
                return NO;
            }else{
                [mutArr1 replaceObjectAtIndex:index withObject:value];
                [setting setObject:mutArr1 forKey:hash_key];
                [setting synchronize];
                return YES;
            }
        }
    }
    
//    return YES;
}


+ (id)getCacheWithKey:(NSString *)key
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *hash_key = [NSString stringWithFormat:@"cache-%@",key];
    id value = [settings objectForKey:hash_key];
    return value;
}

+ (void)removeObjectValue:(NSString *)key
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *hash_key = [NSString stringWithFormat:@"cache-%@",key];
    [settings removeObjectForKey:hash_key];
    [settings synchronize];
}

- (void)removeObjectValue:(NSString *)key
{
    [CacheBox removeObjectValue:key];
}

#pragma mark--退出登录
+ (void)LoginOutNow
{
    [self removeObjectValue:USER_ID];
    [self removeObjectValue:USER_MOBILE];
    [self removeObjectValue:USER_NAME];
    [self removeObjectValue:USER_TOKEN];
    [self removeObjectValue:USER_VERITY];
    [self removeObjectValue:USER_ICON];
    [self removeObjectValue:TOKEN_DATE];
    if ([self haveBLE]) {
        [self removeCharger];
    }
//    [self removeObjectValue:USER_NAME];

}
+ (BOOL)didLogin
{
    NSString *userID = [CacheBox getCacheWithKey:USER_ID];
    if (userID.length>0) {
        return YES;
    }
    return NO;
}
#pragma mark- 充电宝
+(BOOL)haveBLE{
    NSString *ble = [CacheBox getCacheWithKey:CHARGER_NAME];
    if (ble.length>0) {
        return YES;
    }
    return NO;
}
+(void)removeCharger{
    [self removeObjectValue:CHARGER_NAME];
}

+(void)addChargerWithName:(NSString *)chargerName{
    
    NSString *value = [ChargerHeader stringByAppendingString:chargerName];
    [self saveCacheValue:value forKey:CHARGER_NAME];
    
}


@end
