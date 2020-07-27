//
//  TabView.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2018/1/12.
//  Copyright © 2018年 sfbm. All rights reserved.
//

#import "TabView.h"
#import "Commens.h"
@implementation TabView{
    NSArray *_tabTexts;
    CGFloat _labelWidth;
    UIView *_lineView;
    
}
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _tabTexts = titles;
        _labelWidth = SCREEN_WIDTH/titles.count;
        self.currentIndex = 0;
        //添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
        
        [self _createTab];
    }
    return self;
}
#pragma mark - 创建标签
- (void)_createTab{
    //创建标签
    for (int i = 0; i < _tabTexts.count; i++) {
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(_labelWidth*i, 0, _labelWidth, self.height)];
        textLabel.text = _tabTexts[i];
        textLabel.font = [UIFont systemFontOfSize:15];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = RGBA(119, 119, 119, 1);
        textLabel.highlightedTextColor = BASENAVICOLOR;
        if (i == 0) {
            textLabel.highlighted = YES;
        }
        textLabel.tag = 3000+i;
        [self addSubview:textLabel];
        
    }
    //底部的线
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-3, SCREEN_WIDTH/2, 3)];
    _lineView.layer.cornerRadius = 2;
    _lineView.centerX = _labelWidth/2.0;
    _lineView.backgroundColor = BASENAVICOLOR;
    [self addSubview:_lineView];
    
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.highlighted = NO;
        }
    }
    UILabel *selectLabel = (UILabel *)[self viewWithTag:_currentIndex+3000];
    selectLabel.highlighted = YES;
    [UIView animateWithDuration:.35 animations:^{
        _lineView.centerX = (currentIndex*_labelWidth) + _labelWidth/2.0;
    }];
    
}

//文字选中颜色
- (void)setTopicColor:(UIColor *)topicColor{
    _topicColor  = topicColor;
    _lineView.backgroundColor = topicColor;
    
    
}

#pragma mark - 点击手势
- (void)tapAction:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self];
    NSInteger index = point.x/_labelWidth;
    if (self.currentIndex != index) {
        self.currentIndex = index;
        [self.delegate tabViewDidSelectAtIndex:index];
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

