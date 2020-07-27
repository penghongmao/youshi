
//
//  SFBMDiaryModel2.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2018/7/11.
//  Copyright © 2018年 sfbm. All rights reserved.
//

#import "SFBMDiaryModel2.h"

@implementation SFBMDiaryModel2

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        NSArray *keys = [dic allKeys];
        //特殊处理 ID = id
        self.ID = [keys containsObject:@"id"]?[dic objectForKey:@"id"]:@"";
        
        self.title = [keys containsObject:@"title"]?[dic objectForKey:@"title"]:@"";
        self.content = [keys containsObject:@"content"]?[dic objectForKey:@"content"]:@"";
        self.color = [keys containsObject:@"color"]?[dic objectForKey:@"color"]:@"1";
        self.upload = [keys containsObject:@"upload"]?[dic objectForKey:@"upload"]:@"0";
        self.time = [keys containsObject:@"time"]?[dic objectForKey:@"time"]:@"";

        //特殊处理 0  
//        self.upload = [keys containsObject:@"upload"]?[dic objectForKey:@"upload"]:@"0";
        
    }
    
    return self;
}

@end
