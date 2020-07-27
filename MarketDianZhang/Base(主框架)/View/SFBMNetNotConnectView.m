//
//  SFBMNetNotConnectView.m
//  Battery
//
//  Created by 小屁孩 on 17/4/27.
//  Copyright © 2017年 SFBM. All rights reserved.
//

#import "SFBMNetNotConnectView.h"
#import <Foundation/Foundation.h>
#import "Commens.h"
@interface SFBMNetNotConnectView()

@end
@implementation SFBMNetNotConnectView
- (void)awakeFromNib{
    [super awakeFromNib];
    
}

- (void)setState:(SFBMViewState)state{
    _state = state;
    switch (state) {
        case SFBMViewStateNoData: //无数据
        {
            self.imageView.image = [UIImage imageNamed:@"empty_nothing20"];
            self.contentLabel.text = @"暂无任何记录";
            
        }
            break;
        case SFBMViewStateNotNet: //没有网络
        {
            self.imageView.image = [UIImage imageNamed:@"empty_wifi19"];
            self.contentLabel.text = @"网络无反应，请检查您的网络设置";
            
        }
            break;
        case SFBMViewStateReturnDeposit:{//押金退还
            self.imageView.image = [UIImage imageNamed:@"empty_money21"];
            self.contentLabel.text = @"押金已退还到支付的银行卡、支付宝或微信内。请检查明细，如未支付成功，请联系客服电话：\n400-000-2222";
            
        }
            break;
            
        default:
            break;
    }
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
