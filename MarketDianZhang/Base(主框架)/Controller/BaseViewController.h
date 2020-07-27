//
//  BaseViewController.h
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2017/12/5.
//  Copyright © 2017年 sfbm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Commens.h"
@class SFBMNetNotConnectView;
typedef NS_ENUM(NSInteger, HUDDirection) {
    
    HUDDirectionCentral, //HUD显示位置为中
    HUDDirectionTop,//HUD显示位置为上
    HUDDirectionBottom//HUD显示位置为下
};


@interface BaseViewController : UIViewController

@property (nonatomic,strong,readonly) SFBMNetNotConnectView *contentView;//无网络的接口
/*
 *  设置为默认的返回栏
 *
 *  @param viewcontroller viewcontroller description
 */
- (void)addBaseBackBarButtonItem;
/*
 *  设置为默认的导航栏
 *
 *  @param viewcontroller viewcontroller description
 */
- (void)leftBackBtnClick;
- (void)setDefaultNavigationBar;
/*
 *  进入下一级页面
 *
 *  @param viewcontroller viewcontroller description
 */
- (void)push2Next:(UIViewController *)viewcontroller animated:(BOOL)animated;

/**
 *  返回上一级页面
 */
- (void)pop2Previous:(BOOL)animated;

/**
 *  信息提示
 *
 *  @param text   text description
 *  @param mode   mode description
 *  @param second second description
 */
-(void)showMessageText:(NSString *)text withLoadMode:(MBProgressHUDMode)mode duration:(NSTimeInterval)second direction:(HUDDirection)direction;

/**
 *  工程中最常用的一种提示
 *
 *  @param message 提示内容
 */
-(void)showTheMostCommonAlertmessage:(NSString *)message;
/**
 *  工程中最常用的一种提示
 *
 *  @param message 提示内容
 */
-(void)showTheMostCommonAlertmessage:(NSString *)message direction:(HUDDirection)direction;
/**
 *  控件圆角处理
 *
 *  @param sender 控件对象
 *  @param radius 圆角值    为空 0
 *  @param aColor 边线颜色  为空 nil
 *  @param wide   边线宽度  为空 0
 */
-(void)baseCornerRaduisView:(UIView *)sender radius:(CGFloat)radius color:(UIColor *)aColor wide:(CGFloat)wide;

/**
 *  显示简单的alertView
 *
 *  @param message 提示内容
 *  @param buttonTitle 底部按钮标题
 */

- (void)showAlertControllerWithMessage:(NSString *)message buttonTitle:(NSString *)buttonTitle;

//显示更新
- (void)showUpdateAlert;
//lable的文字富文本编辑
/*
 *  @param aLable 需要富文本编辑的控件
 *  @param aColor 富文本颜色
 *  @param corRange 富文本范围
 *  @param aFont 富文本字体大小
 *  @param fonRange 富文本字体范围
 
 */
-(void)addTheMutaleAttributedStringWithLabe:(UILabel *)aLable withColor:(UIColor *)aColor colorRange:(NSRange )corRange withFont:(UIFont *)aFont fontRange:(NSRange )fonRange;

@end
@interface UIViewController (StoryBoard)
/*
 *  获取storyboard中的ViewController
 *
 *  @param storyboardName storyboard 名字
 * @param ID controller 的storyboardID
 */
- (UIViewController *)getControllerFromStoryboard:(NSString *)storyboardName withControllerID:(NSString *)ID;
@end

