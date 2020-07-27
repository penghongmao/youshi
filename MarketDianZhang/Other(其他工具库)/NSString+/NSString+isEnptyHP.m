//
//  NSString+isEnptyHP.m
//  SellerApp
//
//  Created by 毛宏鹏 on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NSString+isEnptyHP.h"
@implementation NSString (isEnptyHP)
//判断字符串是否为空
-(BOOL)isEnptyHP
{
    
    if (self.length==0||self==nil||[self isEqualToString:@""]||self==NULL||[self isKindOfClass:[NSNull class]]) {
        
        return YES;
    }else
    {
        return NO;
    }
    
}

+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *)getVerticalModeSrting:(NSString *)aString
{
    NSArray *strArr = [aString componentsSeparatedByString:@""];
    NSString *myStr = @"";
    for (int i = 0; i<strArr.count; i++)
    {
        if ([myStr isEnptyHP]) {
            myStr = [strArr objectAtIndex:i];
        }else{
            myStr = [NSString stringWithFormat:@"%@\n%@",myStr,[strArr objectAtIndex:i]];
        }
    }

    return myStr;
}

+ (NSString *)stringAtIndexByCount:(NSString *)aString withCount:(NSInteger )count
{
    //如果长度超过则截取
    NSInteger sum = aString.length;
    if (sum>count) {
        NSString *myString = [aString substringWithRange:NSMakeRange(0, count)];
        return myString;

    }
    //如果不需要截取，返回原字符串
    return aString;
}

+(NSString*)Md5:(NSString *)Str
{
    const char *cStr = [Str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (uint32_t)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
    
    
}
+(NSString*)Md5WithSHA1:(NSString*)str
{
    
    const char  *shtro=[str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData  *data=[NSData dataWithBytes:shtro length:str.length];
    uint8_t uint [CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (uint32_t)data.length, uint);
    NSMutableString *outep=[NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH*2];
    for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++)
    {
        [outep appendFormat:@"%02x",uint[i]];
    }
    const char *cStr = [outep UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (uint32_t)strlen(cStr), result); // This is the md5 call
    NSString*sha1Str =[NSString stringWithFormat:
                       @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                       result[0], result[1], result[2], result[3],
                       result[4], result[5], result[6], result[7],
                       result[8], result[9], result[10], result[11],
                       result[12], result[13], result[14], result[15]];
    return sha1Str;
    
}

+(NSMutableAttributedString *)mutableAttributedWithString:(NSString*)string beginLocation:(CGFloat)begin withLengh:(CGFloat)lengh withColor:(UIColor *)color withFont:(UIFont *)font
{
    NSMutableAttributedString *attriSting = [[NSMutableAttributedString alloc] initWithString:string];
    if (color) {
        [attriSting addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(begin, lengh)];
    }
    if (font) {
        [attriSting addAttribute:NSFontAttributeName value:font range:NSMakeRange(begin, lengh)];
    }
    
    return attriSting;
}

+ (NSString *)getHoursFormSecondsWithTimeInterval:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%.2ld",(long)seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%.2ld",(long)(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%.2ld",(long)seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}

//图片转字符串
+(NSString *)UIImageToBase64Str:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

//字符串转图片
+(UIImage *)Base64StrToUIImage:(NSString *)encodedImageStr
{
//    NSData *decodedImageData = [[NSData alloc] initWithBase64Encoding:encodedImageStr];
    NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];

    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    return decodedImage;
}
#pragma mark-字典转Json字符串
- (NSString*)dictionaryToJSONString:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}
#pragma mark-JSON字符串转化为字典
- (NSDictionary *)JsonStringToDictionary:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


@end
