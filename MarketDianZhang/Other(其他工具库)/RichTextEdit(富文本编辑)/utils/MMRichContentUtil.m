//
//  MMRichContentUtil.m
//  RichTextEditDemo
//
//  Created by aron on 2017/7/24.
//  Copyright © 2017年 aron. All rights reserved.
//

#import "MMRichContentUtil.h"
#import "MMRichImageVoiceModel.h"
#import "MMRichImageModel.h"
#import "MMRichTextModel.h"
#import "UIImage+Util.h"
#import "UtilMacro.h"
#import "NSString+isEnptyHP.h"

#define kRichContentEditCache      @"RichContentEditCache"


@implementation MMRichContentUtil

+ (NSString*)htmlContentFromRichContents:(NSArray*)richContents {
    NSMutableString *htmlContent = [NSMutableString string];

    for (int i = 0; i< richContents.count; i++) {
        NSObject* content = richContents[i];
        if ([content isKindOfClass:[MMRichImageModel class]]) {
            MMRichImageModel* imgContent = (MMRichImageModel*)content;
//            [htmlContent appendString:[NSString stringWithFormat:@"<img src=\"%@\" width=\"%@\" height=\"%@\" />", [NSString UIImageToBase64Str:imgContent.image], @(imgContent.image.size.width), @(imgContent.image.size.height)]];
            [htmlContent appendString:[NSString stringWithFormat:@"base64image=%@", [NSString UIImageToBase64Str:imgContent.image]]];
            
        }else if ([content isKindOfClass:[MMRichImageVoiceModel class]]) {
            MMRichImageVoiceModel* imgContent = (MMRichImageVoiceModel*)content;
            
            [htmlContent appendString:[NSString stringWithFormat:@"mhpvoicepath=%@", imgContent.localImageVoicePath]];
            
        }
        else if ([content isKindOfClass:[MMRichTextModel class]]) {
            MMRichTextModel* textContent = (MMRichTextModel*)content;
            [htmlContent appendString:textContent.textContent];
        }
        
        // 添加换行
        if (i != richContents.count - 1) {
            [htmlContent appendString:@"<br />"];
        }
    }
    
    return htmlContent;
}
+ (NSMutableArray *)modeArrayFromBase64String:(NSString *)base64String
{
    NSMutableArray *data = [NSMutableArray array];
    NSArray *array = [base64String componentsSeparatedByString:@"<br />"];
    for (int i=0; i<array.count; i++) {
        
        NSString *baseStr = array[i];
        if ([baseStr containsString:@"base64image="]) {//图片的base64image=组合格式
            NSString *imageStr = [[baseStr componentsSeparatedByString:@"base64image="] lastObject];
            UIImage *image = [NSString Base64StrToUIImage:imageStr];
            MMRichImageModel *mode = [MMRichImageModel new];
            mode.image = image;
            [data addObject:mode];
        }else if ([baseStr containsString:@"mhpvoicepath="]) {//录音的mhpvoicepath=组合格式
            NSString *voicePathStr = [[baseStr componentsSeparatedByString:@"mhpvoicepath="] lastObject];
            MMRichImageVoiceModel *mode = [MMRichImageVoiceModel new];
            //aio_voice_operate_listen_nor
            mode.image = [UIImage imageNamed:@"aio_voice_operate_listen_press"];
            mode.localImageVoicePath = voicePathStr;
            [data addObject:mode];
        }
        else{//普通文字
            MMRichTextModel *textModel = [MMRichTextModel new];
            textModel.textContent = baseStr;
            [data addObject:textModel];
        }
    }
    
    
    return data;
}
+ (BOOL)validateRichContents:(NSArray*)richContents {
    for (int i = 0; i< richContents.count; i++) {
        NSObject* content = richContents[i];
        if ([content isKindOfClass:[MMRichImageModel class]]) {
            MMRichImageModel* imgContent = (MMRichImageModel*)content;
            if (imgContent.isDone == NO) {
                return NO;//图片没有上传成功
            }
        }
    }
    return YES;
}

+ (UIImage*)scaleImage:(UIImage*)originalImage {
    float scaledWidth = 1242;
    return [originalImage scaletoWize:scaledWidth];
}

+ (NSString*)saveImageToLocal:(UIImage*)image {
    NSString *path=[self createDirectory:kRichContentEditCache];
    NSData* data = UIImageJPEGRepresentation(image, 1.0);
    NSString *filePath = [path stringByAppendingPathComponent:[self.class genRandomFileName]];
    [data writeToFile:filePath atomically:YES];
    return filePath;
}

// 创建文件夹
+ (NSString *)createDirectory:(NSString *)path {
    BOOL isDir = NO;
    NSString *finalPath = [CACHE_PATH stringByAppendingPathComponent:path];
    
    if (!([[NSFileManager defaultManager] fileExistsAtPath:finalPath
                                               isDirectory:&isDir]
          && isDir))
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:finalPath
                                 withIntermediateDirectories :YES
                                                  attributes :nil
                                                       error :nil];
    }
    
    return finalPath;
}

+ (NSString*)genRandomFileName {
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    uint32_t random = arc4random_uniform(10000);
    return [NSString stringWithFormat:@"%@-%@.png", @(timeStamp), @(random)];
}

@end
