//
//  MyContactListModel2.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2018/1/21.
//  Copyright © 2018年 sfbm. All rights reserved.
//

#import "MyContactListModel2.h"

@implementation MyContactListModel2

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init])
    {
        NSArray *keys = [dic allKeys];
        //特殊处理 ID = id
        self.ID = [keys containsObject:@"id"]?[dic objectForKey:@"id"]:@"";
        
        self.headpath = [keys containsObject:@"headpath"]?[dic objectForKey:@"headpath"]:@"";
        self.name = [keys containsObject:@"name"]?[dic objectForKey:@"name"]:@"";
        self.position = [keys containsObject:@"position"]?[dic objectForKey:@"position"]:@"";
        self.company = [keys containsObject:@"company"]?[dic objectForKey:@"company"]:@"";
        self.telephone = [keys containsObject:@"telephone"]?[dic objectForKey:@"telephone"]:@"";
        self.phone = [keys containsObject:@"phone"]?[dic objectForKey:@"phone"]:@"";
        self.fax = [keys containsObject:@"fax"]?[dic objectForKey:@"fax"]:@"";
        self.email = [keys containsObject:@"email"]?[dic objectForKey:@"email"]:@"";
        self.wechat = [keys containsObject:@"wechat"]?[dic objectForKey:@"wechat"]:@"";
        self.microblog = [keys containsObject:@"microblog"]?[dic objectForKey:@"microblog"]:@"";
        self.qq = [keys containsObject:@"qq"]?[dic objectForKey:@"qq"]:@"";
        self.address = [keys containsObject:@"address"]?[dic objectForKey:@"address"]:@"";
        self.remark = [keys containsObject:@"remark"]?[dic objectForKey:@"remark"]:@"";
        //特殊处理 0
        self.upload = [keys containsObject:@"upload"]?[dic objectForKey:@"upload"]:@"0";

        
    }

    return self;
}

/*
 @property (nonatomic, copy) NSString * ID;//头像地址
 
 @property (nonatomic, copy) NSData * headpath;//头像地址
 @property (nonatomic, copy) NSString * name;//姓名
 @property (nonatomic, copy) NSString * position;//职位
 @property (nonatomic, copy) NSString * company;//公司
 
 @property (nonatomic, copy) NSString * telephone;//固定电话
 @property (nonatomic, copy) NSString * phone;//手机
 @property (nonatomic, copy) NSString * fax;//传真 例如 86  519-85125379
 @property (nonatomic, copy) NSString * email;//电子邮箱
 @property (nonatomic, copy) NSString * wechat;//微信
 @property (nonatomic, copy) NSString * microblog;//微博
 @property (nonatomic, copy) NSString * qq;//QQ
 @property (nonatomic, copy) NSString * address;//地址
 @property (nonatomic, copy) NSString * remark;//备注
 @property (nonatomic, copy) NSString * upload;//是否已同步上传，默认为“0”没同步，同步之后修改本地数据库为“1”，修改联系人信息之后也认为没同步标记为 “0”
 */
@end
