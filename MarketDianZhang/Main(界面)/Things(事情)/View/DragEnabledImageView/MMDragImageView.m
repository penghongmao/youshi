//
//  MMDragImageView.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2018/7/26.
//  Copyright © 2018年 sfbm. All rights reserved.
//

#import "MMDragImageView.h"
#import "UIView+Frame.h"
@interface MMDragImageView()
{
    CGPoint startLocation;
    NSString *_action;
    void(^_actionBlock)(void);
}
@end
@implementation MMDragImageView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMe)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    CGPoint pt = [[touches anyObject] locationInView:self];
    startLocation = pt;
    [[self superview] bringSubviewToFront:self];
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    CGPoint pt = [[touches anyObject] locationInView:self];
    float dx = pt.x - startLocation.x;
    float dy = pt.y - startLocation.y;
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    //
    float halfx = CGRectGetMidX(self.bounds);
    newcenter.x = MAX(halfx, newcenter.x);
    newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
    //
    float halfy = CGRectGetMidY(self.bounds);
    newcenter.y = MAX(halfy, newcenter.y);
    newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);
    //
    self.center = newcenter;
}
//拖动结束后 强制回到左边或者右边
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint point = self.center;
    if (point.x>[self superview].width/2.0) {
        
        [UIView animateWithDuration:0.2 animations:^{
            self.x = [self superview].width-self.width;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.x = 0;
        }];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void)tapMe {

    if(_actionBlock)
    {
        _actionBlock();
    }
}

-(void)setAction:(NSString *)action {
    _action = action;
}

-(void)setActionBlock:(void(^)(void))block {
    _actionBlock = block;
}

@end
