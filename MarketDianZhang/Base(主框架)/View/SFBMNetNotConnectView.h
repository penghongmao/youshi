//
//  SFBMNetNotConnectView.h
//  Battery
//
//  Created by 小屁孩 on 17/4/27.
//  Copyright © 2017年 SFBM. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SFBMViewState) {
    
    SFBMViewStateNotNet, //无网络
    SFBMViewStateNoData,//无数据
    SFBMViewStateReturnDeposit //押金退还
};

@interface SFBMNetNotConnectView : UIView

@property(nonatomic ,assign) SFBMViewState state;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
