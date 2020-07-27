//
//  MMDragImageView.h
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2018/7/26.
//  Copyright © 2018年 sfbm. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface MMDragImageView : UIImageView

-(void)setAction:(NSString*)action;

-(void)setActionBlock:(void(^)(void))block;

@end
