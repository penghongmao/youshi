//
//  TabView.h
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2018/1/12.
//  Copyright © 2018年 sfbm. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TabViewDelegate <NSObject>
//选中第几个
- (void)tabViewDidSelectAtIndex:(NSInteger)index;

@end

@interface TabView : UIView

@property (nonatomic,weak) id<TabViewDelegate> delegate; //代理
@property (nonatomic,assign) NSInteger currentIndex; //当前页数
@property (nonatomic, strong) UIColor *topicColor; //设置主题颜色

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

@end

