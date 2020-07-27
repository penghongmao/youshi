//
//  SFBMDiaryModel.h
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2018/7/11.
//  Copyright © 2018年 sfbm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFBMDiaryModel : NSObject
@property (nonatomic, copy) NSString * title;//标题
@property (nonatomic, copy) NSString * content;//正文
@property (nonatomic, copy) NSString * color;//文章标注颜色
@property (nonatomic, copy) NSString * upload;//是否已同步上传，默认为“0”没同步，同步之后修改本地数据库为“1”，修改日记信息之后也认为没同步标记为 “0”
@property (nonatomic, copy) NSString * time;//时间


@end
