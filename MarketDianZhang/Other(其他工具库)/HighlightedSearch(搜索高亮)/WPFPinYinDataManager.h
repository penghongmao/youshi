//
//  WPFPinYinDataManager.h
//  HighlightedSearch
//
//  Created by Leon on 2017/12/7.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPFPinYinDataManager : NSObject

/** 添加解析的单个数据源,id标识符是为了防止重名 */
+ (void)addInitializeString:(NSString *)string identifer:(NSString *)identifier company:(NSString *)company headImageData:(NSData *)imageData;

/** 获取已解析的数据源 */
+ (NSArray *)getInitializedDataSource;

@end
