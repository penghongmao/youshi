//
//  MyAlertView.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2017/12/15.
//  Copyright © 2017年 sfbm. All rights reserved.
//

#import "MyAlertView.h"
#import "MaskLayer.h"
#define TopNaviHeight  88
#define MessageTopMargin  24
#define MessageBottonMargin 32
#define ButtonHeight 36

#define ButtonHeight0 41
#define ButtonHorizatalMargin 13

@interface MyAlertView()
{
    MaskLayer *maskAlert;
    CGSize messageSize;
}
@end
@implementation MyAlertView

-(instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title message:(NSString *)message buttons:(NSArray *)buttons alerType:(ENUM_MyalertViewType )type
{
    switch (type) {
        case ENUM_MyalertVeiwOne:
            {
                messageSize = [message boundingRectWithSize:CGSizeMake(frame.size.width-12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]} context:nil].size;
                CGRect viewFrame = frame;
                viewFrame.size.height = messageSize.height +125;
                frame = viewFrame;
                self = [super initWithFrame:frame];
                if (self) {
                    
                    [self drawSubVeiwsWithTitle:title message:message buttons:buttons];
                }
                
            }
            break;
        case ENUM_MyalertVeiwTwo:
            {
                messageSize = [message boundingRectWithSize:CGSizeMake(frame.size.width-60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size;
                //88+24+messageSize.height+30+52*i;
                CGRect viewFrame = frame;
                viewFrame.size.height = TopNaviHeight+MessageTopMargin+messageSize.height+MessageBottonMargin+52*buttons.count+20;
                frame = viewFrame;
                self = [super initWithFrame:frame];
                if (self) {
                    
                    [self drawSubVeiwsWithImage:image title:title message:message buttons:buttons];
                }
                
            }
        default:
            break;
    }
    
    return self;
    
}
-(UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, TopNaviHeight)];
        _topView.backgroundColor = [UIColor colorWithRed:23/255.0f green:33/255.0f blue:43/255.0f alpha:1];//颜色可替换
    }
    return _topView;
}

-(void)drawSubVeiwsWithTitle:(NSString *)title message:(NSString *)message buttons:(NSArray *)buttons
{
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    lineLabel.text = title;
    lineLabel.adjustsFontSizeToFitWidth = YES;
    lineLabel.textColor = [UIColor darkGrayColor];
    lineLabel.textAlignment = NSTextAlignmentCenter;
    lineLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:lineLabel];
    
    UILabel *messageL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    messageL.text = message;
    messageL.textColor = [UIColor darkGrayColor];
    messageL.textAlignment = NSTextAlignmentCenter;
    messageL.font = [UIFont systemFontOfSize:16.0];
    messageL.numberOfLines = 0;
    [self addSubview:messageL];
    NSRange range = [message rangeOfString:@"48小时"];
    if (range.location != NSNotFound) {
        NSDictionary *dic = @{
                              NSForegroundColorAttributeName:[UIColor darkGrayColor],
                              NSFontAttributeName:[UIFont systemFontOfSize:15.0]
                              };
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:message attributes:dic];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        messageL.attributedText = str;
    }
    
    lineLabel.frame = CGRectMake(12, 19, self.bounds.size.width-12, 20);
    
    messageL.frame = CGRectMake(12, CGRectGetMaxY(lineLabel.frame)+8, self.bounds.size.width - (12*2), messageSize.height);
    CGFloat baseY = CGRectGetMaxY(messageL.frame) + 23;
    CGFloat baseW = (self.bounds.size.width - 5*2 - ButtonHorizatalMargin*2)/3;
    for (int i=0; i<buttons.count; i++) {
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleBtn.frame = CGRectMake(5 + (baseW + ButtonHorizatalMargin)*i, baseY, baseW, ButtonHeight0);
        [cancleBtn setTitle:[buttons objectAtIndex:i] forState:UIControlStateNormal];
        [cancleBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        
        cancleBtn.layer.cornerRadius = 2.0;
        cancleBtn.layer.masksToBounds = YES;
        cancleBtn.layer.borderColor = [UIColor colorWithRed:(float)83/255.0f green:(float)183/255.0f blue:(float)243/255.0f alpha:1].CGColor;
        cancleBtn.layer.borderWidth = 1;
        [cancleBtn setTitleColor:[UIColor colorWithRed:(float)83/255.0f green:(float)183/255.0f blue:(float)243/255.0f alpha:1] forState:UIControlStateNormal];

        cancleBtn.backgroundColor = [UIColor clearColor];
        cancleBtn.tag = i;
        
        if (i==0) {
            cancleBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            [cancleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
        }
        [cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:cancleBtn];
        
    }
}

-(void)drawSubVeiwsWithImage:(UIImage *)image title:(NSString *)title message:(NSString *)message buttons:(NSArray *)buttons
{
    
    
    [self addSubview:self.topView];
    
    UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    imageV1.image = image;
    [_topView addSubview:imageV1];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    lineLabel.text = title;
    lineLabel.adjustsFontSizeToFitWidth = YES;
    lineLabel.textColor = [UIColor whiteColor];
    lineLabel.font = [UIFont systemFontOfSize:17.0];
    [_topView addSubview:lineLabel];
    
    UILabel *messageL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    messageL.text = message;
    messageL.textColor = [UIColor darkGrayColor];
    messageL.font = [UIFont systemFontOfSize:15.0];
    messageL.numberOfLines = 0;
    [self addSubview:messageL];
    NSRange range = [message rangeOfString:@"48小时"];
    if (range.location != NSNotFound) {
        NSDictionary *dic = @{
                              NSForegroundColorAttributeName:[UIColor darkGrayColor],
                              NSFontAttributeName:[UIFont systemFontOfSize:15.0]
                              };
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:message attributes:dic];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        messageL.attributedText = str;
    }
    
    
    _topView.frame = CGRectMake(0, 0, self.bounds.size.width, TopNaviHeight);
    imageV1.frame = CGRectMake(25, 8, 80, 80);
    lineLabel.frame = CGRectMake(CGRectGetMaxX(imageV1.frame)+12, _topView.center.y-10, self.bounds.size.width-CGRectGetMaxX(imageV1.frame)-12, 20);
    
    messageL.frame = CGRectMake(30, CGRectGetMaxY(_topView.frame)+MessageTopMargin, self.bounds.size.width - (30*2), messageSize.height);
    CGFloat baseY = CGRectGetMaxY(messageL.frame) + MessageBottonMargin;
    for (int i=0; i<buttons.count; i++) {
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancleBtn.frame = CGRectMake(30, baseY+52*i, self.bounds.size.width - 60, ButtonHeight);
        [cancleBtn setTitle:[buttons objectAtIndex:i] forState:UIControlStateNormal];
        [cancleBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        
        cancleBtn.layer.cornerRadius = ButtonHeight/2.0;
        cancleBtn.layer.masksToBounds = YES;
        cancleBtn.backgroundColor = [UIColor colorWithRed:(float)125/255.0f green:(float)186/255.0f blue:(float)24/255.0f alpha:1];
        cancleBtn.tag = i;
        
        if (buttons.count>1&&i==buttons.count-1) {
            cancleBtn.backgroundColor = [UIColor clearColor];
            cancleBtn.layer.borderColor = [UIColor grayColor].CGColor;
            cancleBtn.layer.borderWidth = 1;
            [cancleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
        }
        [cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:cancleBtn];
        
    }
}

-(void)showBlock:(AlertViewClickBlock)alertBlock
{
    _alertBlock = alertBlock;
}
-(void)cancleBtnClick:(UIButton *)btn
{
    if (_alertBlock) {
        _alertBlock(btn.tag);
    }
    
    [self dismiss];
}

- (void)show {
    
    //    [[UIApplication sharedApplication].keyWindow addSubview:self];
    //    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    //    self.alpha = 0;
    //    self.transform = CGAffineTransformScale(self.transform,0.1,0.1);
    //    [UIView animateWithDuration:0.3 animations:^{
    //        self.transform = CGAffineTransformIdentity;
    //        self.alpha = 1;
    //        [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor blackColor];
    //        [UIApplication sharedApplication].keyWindow.alpha = 0.6;
    //    }];
    maskAlert = [[MaskLayer alloc] initWithTitle:nil selectSheetBlock:nil];
    [maskAlert show];
    
    [maskAlert addSubview:self];
    
}

- (void)dismiss {
    //    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor clearColor];
    //    [UIApplication sharedApplication].keyWindow.alpha = 1;
    //
    //
    //    [UIView animateWithDuration:0.3 animations:^{
    //        self.transform = CGAffineTransformScale(self.transform, 0.1, 0.1);
    //        self.alpha = 0;
    //    } completion:^(BOOL finished) {
    //
    //        [self removeFromSuperview];
    //    }];
    [maskAlert removeFromSuperview];
}

@end

