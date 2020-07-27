//
//  SFBMUserBaseInfoModel.h
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2017/12/6.
//  Copyright © 2017年 sfbm. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SFBMUserBaseInfoModel;
@interface SFBMUserBaseInfoModel : NSObject
@property (nonatomic ,copy) NSString *nickname;//昵称
@property (nonatomic ,copy) NSString *userPortrait;//头像
@property (nonatomic ,copy) NSString *userName; //用户名字
@property (nonatomic, copy) NSString *balance; //余额
@property (nonatomic ,copy) NSString *usingStatus; //使用状态/1.使用中,0,不在使用中
@property (nonatomic ,copy) NSString *goingOrderNo; //当前未完成的订单号
@property (nonatomic ,copy) NSString *deposit;//押金
@property (nonatomic ,copy) NSString *accumulatePoints;//积分
@property (nonatomic ,copy) NSString *elecQty;//充电量
@property (nonatomic ,copy) NSString *chargingBabyUsedTimes;//充电宝使用次数
@property (nonatomic ,copy) NSString *couponQty;//优惠券数量 已经废弃
@property (nonatomic ,copy) NSString *usableCouponQty;//可用的优惠券数量
@property (nonatomic, copy) NSString *hasUnreadMsg; // 是否有未读消息


+ (void)getUserBaseInfoWithSuccessBlock:(void(^)(SFBMUserBaseInfoModel * model))success failure:(void(^)(void))failure;

@end
