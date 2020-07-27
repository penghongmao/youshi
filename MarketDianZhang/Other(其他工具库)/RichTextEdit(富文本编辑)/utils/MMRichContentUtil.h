//
//  MMRichContentUtil.h
//  RichTextEditDemo
//
//  Created by aron on 2017/7/24.
//  Copyright © 2017年 aron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MMRichContentUtil : NSObject

// image经过base64编码转成字符串然后和正常的字符串组合在一起的字符串内容
+ (NSString*)htmlContentFromRichContents:(NSArray*)richContents;
//将 image经过base64编码转成字符串然后和正常的字符串组合在一起的字符串内容 转回model组成的数组
+ (NSMutableArray *)modeArrayFromBase64String:(NSString *)base64String;
// 验证内容是否有效，判断图片是否全部上传成功
+ (BOOL)validateRichContents:(NSArray*)richContents;
// 压缩图片
+ (UIImage*)scaleImage:(UIImage*)originalImage;
// 保存图片到本地
+ (NSString*)saveImageToLocal:(UIImage*)image;

@end
