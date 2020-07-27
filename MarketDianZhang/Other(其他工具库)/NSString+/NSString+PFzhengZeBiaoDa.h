//
//  NSString+PFzhengZeBiaoDa.h
//  My_App
//
//  Created by 毛宏鹏 on 16/6/23.
//  Copyright © 2016年 毛宏鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PFzhengZeBiaoDa)

//判断手机号的正则表达
+ (BOOL)isMobileStr:(NSString *)phoneNumber;
//判断邮政编码的正则表达式
-(BOOL)isZipStr:(NSString *)zip;

//验证email
+(BOOL)isValidateEmail:(NSString *)email;

//验证11位手机号码
+(BOOL)isValidateTelNumber:(NSString *)number;

// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//浮点数
+(BOOL)validateFloat:(NSString *)candidate;
- (NSString *)trim;
- (NSString *)trimWithCharacters:(NSString *)character;

@end
