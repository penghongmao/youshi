//
//  SFBMDiaryServerModel2.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2018/7/26.
//  Copyright © 2018年 sfbm. All rights reserved.
//

#import "SFBMDiaryServerModel2.h"

@implementation SFBMDiaryServerModel2
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
        self.userid = [keys containsObject:@"userid"]?[dic objectForKey:@"userid"]:@"";

        //特殊处理 userid
        //        self.upload = [keys containsObject:@"upload"]?[dic objectForKey:@"upload"]:@"0";
        
    }
    
    return self;
}

@end
