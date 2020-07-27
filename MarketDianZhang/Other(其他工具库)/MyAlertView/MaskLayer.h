//
//  MaskLayer.h
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2017/12/15.
//  Copyright © 2017年 sfbm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionSheetDidSelectBlock)(NSInteger index);

@interface MaskLayer : UIView
@property (nonatomic, weak) UIView    *cover;

- (instancetype)initWithTitle:(NSString *)title selectSheetBlock:(ActionSheetDidSelectBlock)clickBlock;

- (void)show;
@end
