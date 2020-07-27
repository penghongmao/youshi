//
//  NSString+isEnptyHP.h
//  SellerApp
//
//  Created by 毛宏鹏 on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

#import <UIKit/UIKit.h>
@interface NSString (isEnptyHP)
//判断字符串是否为空
-(BOOL)isEnptyHP;

+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//把横向排版的字符串转换成竖着排版的
+ (NSString *)getVerticalModeSrting:(NSString *)aString;
//按照长度截取字符串  count截取的长度
+ (NSString *)stringAtIndexByCount:(NSString *)aString withCount:(NSInteger )count;

+(NSString*)Md5:(NSString *)Str;
+(NSString*)Md5WithSHA1:(NSString*)str;
//富文本编辑
+(NSMutableAttributedString *)mutableAttributedWithString:(NSString*)string beginLocation:(CGFloat)begin withLengh:(CGFloat)lengh withColor:(UIColor *)color withFont:(UIFont *)font;

//秒转换时：分：秒
+(NSString *)getHoursFormSecondsWithTimeInterval:(NSString *)totalTime;

//图片转字符串
+(NSString *)UIImageToBase64Str:(UIImage *)image;
//字符串转图片
+(UIImage *)Base64StrToUIImage:(NSString *)encodedImageStr;
//字典转Json字符串
- (NSString*)dictionaryToJSONString:(id)infoDict;
//JSON字符串转化为字典
- (NSDictionary *)JsonStringToDictionary:(NSString *)jsonString;
@end
