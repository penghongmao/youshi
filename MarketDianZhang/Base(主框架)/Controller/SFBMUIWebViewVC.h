//
//  SFBMUIWebViewVC.h
//  MarketDianZhang
//
//  Created by HP M on 2019/9/20.
//  Copyright © 2019 sfbm. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, SFBMWebType2) {
    
    SFBMWebTypeAboutUs2, //关于我们
    SFBMWebTypeAboutSBC2, //关于随便充
    
    SFBMWebTypeVirtualCoin2, //关于雷币
    SFBMWebTypeChargeAgreement2, //押金说明
    SFBMWebTypeLocateFail2,  //定位失败
    SFBMWebTypeAllTheQuestions2, //全部问题
    
    SFBMWebTypeProcess2,//使用流程
    SFBMWebTypeUseAgreement2,//用户协议
    SFBMWebTypeBuyingAgreement2, //购买协议
    
    SFBMWebOtherHtml2 //其他网页直接传动态网址
    
};
@interface SFBMUIWebViewVC : BaseViewController
@property (nonatomic, assign) SFBMWebType2 type;//类型

@property (nonatomic, strong) NSString *webTitle;//网页标题
@property (nonatomic, strong) NSString *webUrl;//网址链接

@end

NS_ASSUME_NONNULL_END
