//
//  MyContactListModel.h
//  MyFMDB
//
//  Created by 毛宏鹏 on 2018/1/16.
//  Copyright © 2018年 sfbm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyContactListModel : NSObject
//@property (nonatomic, copy) NSData * headpath;//头像地址
@property (nonatomic, copy) NSString * headpath;//头像地址

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

@end
