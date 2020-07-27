//
//  NSString+PFzhengZeBiaoDa.m
//  My_App
//
//  Created by 毛宏鹏 on 16/6/23.
//  Copyright © 2016年 毛宏鹏. All rights reserved.
//

#import "NSString+PFzhengZeBiaoDa.h"

@implementation NSString (PFzhengZeBiaoDa)

//手机号的正则表达式
+ (BOOL)isMobileStr:(NSString *)phoneNumber
{
    if (phoneNumber.length == 0) {
        return NO;
    }
    //第一位数字是1 ，第二位数字0~9，后面一共10位数，所以一共11位数字
    NSString *phoneRegex = @"[1][0-9]{10}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneRegex];
    BOOL isMatch = [phoneTest evaluateWithObject:phoneNumber];
    if (!isMatch) {
//        labelTi.hidden = NO;
//        labelTi.text = @"请输入正确的手机号码!";
//        NSString *tishi = @"请输入正确的手机号码!";
//        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
        return NO;
    }
    return YES;
}
//判断邮政编码的正则表达式
-(BOOL)isZipStr:(NSString *)zip
{
    if (zip.length == 0) {
        return NO;
    }
    else{
        
        NSString *zipStr = @"[1-9]\\d{5}(?!\\d)";
        NSPredicate *zipTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",zipStr];
        BOOL isMatch = [zipTest evaluateWithObject:zip];
        if (!isMatch) {
//            labelTi.hidden = NO;
//            labelTi.text = @"请输入正确的邮箱!";
//            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doTimer) userInfo:nil repeats:NO];
//            self.zipField.clearsOnInsertion = YES;
//            self.zipField.text = 0;
            return NO;
        }
    }
    return YES;
}

//=====================
//是否是有效的正则表达式

+(BOOL)isValidateRegularExpression:(NSString *)strDestination byExpression:(NSString *)standardExpression{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", standardExpression];
    
    return [predicate evaluateWithObject:strDestination];
}

//验证email
+(BOOL)isValidateEmail:(NSString *)email {
    //jfkjkfj@ddvv.com     123123123@qq.com   asdadsasda@163.com
    NSString *strRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}";
    BOOL rt = [self isValidateRegularExpression:email byExpression:strRegex];
    
    return rt;
}

//验证11位号码
+(BOOL)isValidateTelNumber:(NSString *)number {
    
    NSString *strRegex = @"[0-9]{11,11}";
    
    BOOL rt = [self isValidateRegularExpression:number byExpression:strRegex];
    
    return rt;
    
}

// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum])
        || ([regextestcm evaluateWithObject:mobileNum])
        || ([regextestct evaluateWithObject:mobileNum])
        || ([regextestcu evaluateWithObject:mobileNum]))
    {
        if([regextestcm evaluateWithObject:mobileNum]) {
            NSLog(@"China Mobile");
        } else if([regextestct evaluateWithObject:mobileNum]) {
            NSLog(@"China Telecom");
        } else if ([regextestcu evaluateWithObject:mobileNum]) {
            NSLog(@"China Unicom");
        } else {
            NSLog(@"Unknow");
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}


//zheng浮点数
+(BOOL)validateFloat:(NSString *)candidate
{
    NSString * floatRegex = @"^(([0-9]+\\.[0-9]*[1-9][0-9]*)|([1-9][0-9]*\\.[0-9]+)|([1-9][0-9]*)|0)$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", floatRegex];
    return [pred evaluateWithObject:candidate];
}

/**
 *  去除两端空格和回车
 */
- (NSString *)trim
{
    NSString *text = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return text;
}

- (NSString *)trimWithCharacters:(NSString *)character
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:character? :@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
    NSString *trimString = [self stringByTrimmingCharactersInSet:set];
    return trimString;
}

@end
