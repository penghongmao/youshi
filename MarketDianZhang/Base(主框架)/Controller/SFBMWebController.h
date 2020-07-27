//
//  SFBMWebController.h
//  Battery
//
//  Created by 小屁孩 on 17/5/8.
//  Copyright © 2017年 SFBM. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, SFBMWebType) {
    
    SFBMWebTypeAboutUs, //关于我们
    SFBMWebTypeAboutSBC, //关于随便充

    SFBMWebTypeVirtualCoin, //关于雷币
    SFBMWebTypeChargeAgreement, //押金说明
    SFBMWebTypeLocateFail,  //定位失败
    SFBMWebTypeAllTheQuestions, //全部问题
    
    SFBMWebTypeProcess,//使用流程
    SFBMWebTypeUseAgreement,//用户协议
    SFBMWebTypeBuyingAgreement, //购买协议

    SFBMWebOtherHtml //其他网页直接传动态网址

};

@interface SFBMWebController : BaseViewController

@property (nonatomic, assign) SFBMWebType type;//类型

@property (nonatomic, strong) NSString *webTitle;//网页标题
@property (nonatomic, strong) NSString *webUrl;//网址链接

@end
