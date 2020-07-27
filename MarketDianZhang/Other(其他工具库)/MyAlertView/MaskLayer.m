//
//  MaskLayer.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2017/12/15.
//  Copyright © 2017年 sfbm. All rights reserved.
//

#import "MaskLayer.h"
#define SCREEN_BOUNDS_mask         [UIScreen mainScreen].bounds

@interface MaskLayer ()
@property (nonatomic, copy) NSString  *title;
@property (nonatomic, copy) ActionSheetDidSelectBlock selectSheetBlock;
@property (nonatomic, weak) UIView    *actionSheet;

@end
@implementation MaskLayer

- (instancetype)initWithTitle:(NSString *)title selectSheetBlock:(ActionSheetDidSelectBlock)clickBlock
{
    if (self = [super initWithFrame:SCREEN_BOUNDS_mask]) {
        _title            = title;
        _selectSheetBlock = clickBlock;
        
        [self setupCover];
        
    }
    return self;
}

- (void)setupCover {
    
    [self addSubview:({
        UIView *cover = [[UIView alloc] init];
        cover.frame = self.bounds;
        cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        //        [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboards)]];
        _cover = cover;
    })];
    _cover.alpha = 0;
}


- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.7
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.cover.alpha = 1.0;
                     }
                     completion:nil];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.7
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.cover.alpha = 0.0;
                         //                         self.actionSheet.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         for (UIView *sub in self.subviews) {
                             [sub removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }];
}

- (void)dismissKeyboards
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [self dismiss];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

