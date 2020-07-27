//
//  MyAlertView.h
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2017/12/15.
//  Copyright © 2017年 sfbm. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AlertViewClickBlock)(NSInteger tag);

@interface MyAlertView : UIView

typedef NS_ENUM(NSInteger,ENUM_MyalertViewType)
{
    ENUM_MyalertVeiwOne = 0,//不包含图片和logo的弹框
    ENUM_MyalertVeiwTwo, //包含图片和logo的弹框
};


@property (nonatomic,strong)UIView *topView;
@property (nonatomic ,copy)AlertViewClickBlock alertBlock;
-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title message:(NSString *)message buttons:(NSArray *)buttons alerType:(ENUM_MyalertViewType )type;

-(void)showBlock:(AlertViewClickBlock)alertBlock;
- (void)show;
@end
