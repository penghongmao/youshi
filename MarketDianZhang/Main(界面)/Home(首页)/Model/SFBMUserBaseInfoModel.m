//
//  SFBMUserBaseInfoModel.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2017/12/6.
//  Copyright © 2017年 sfbm. All rights reserved.
//

#import "SFBMUserBaseInfoModel.h"
#import "Commens.h"
@implementation SFBMUserBaseInfoModel

+ (void)getUserBaseInfoWithSuccessBlock:(void (^)(SFBMUserBaseInfoModel *))success failure:(void (^)(void))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [CacheBox getCacheWithKey:USER_ID];
    params[@"token"] = [CacheBox getCacheWithKey:USER_TOKEN];
    //    __weak typeof(self) weakSelf = self;//
    [MyAfnetwork postUrl:@"" baseURL:@"" withHUD:NO message:nil parameters:params getChat:^(NSDictionary *myDic) {
        //
        NSString *erroMsg = [myDic objectForKey:@"errCode"];
        int code = erroMsg.intValue;
        
        if (code== 0){
            NSDictionary *dic = [myDic objectForKey:@"data"];
            SFBMUserBaseInfoModel *userInfoModel = [SFBMUserBaseInfoModel mj_objectWithKeyValues:dic];
            //            [CacheBox saveCacheValue:userInfoModel.userName forKey:USER_NAME];
            
            success(userInfoModel);
            
        }else{
            failure();
        }
        
    } failure:^{
        failure();
    }];
    
    
}


//获取用户资产
+ (void)getUserBalance{
}


@end

