//
//  BaseViewController.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2017/12/5.
//  Copyright © 2017年 sfbm. All rights reserved.
//

#import "BaseViewController.h"
#import "SFBMLoginWithoutPasswordController.h"
#import "BaseViewController.h"
#import "SFBMHomeViewController.h"
#import "BaseNavigationController.h"
#define HUDTimeInterval 1.5
#define HUDTopMargin  50

@interface BaseViewController ()
@property (nonatomic, strong) UIView *netView;

@end

@implementation BaseViewController
-(void)viewWillDisappear:(BOOL)animated
{//NSNotificationCenterNeedToUpdate
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NSNotificationCenterNeedToUpdate" object:nil];
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;//隐藏底部 tabBar
//    self.tabBarController.tabBar.translucent = NO;//底部 tabBar取消透明
    //设置状态栏 字体颜色为黑色
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //    for (UIView *tabBarButton in self.tabBarController.tabBar.subviews) {
    //        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
    //            MYNSLog(@"清除多余系统UITabBarButton");
    //            [tabBarButton removeFromSuperview];
    //        }
    //    }
    
    [self afnNetstatusManage];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //键盘消失的手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    //IOS7以后去掉表头的20像素空白
    self.automaticallyAdjustsScrollViewInsets = NO;
    //IOS11以后去掉表头的20像素空白，以下代码在AppDelegate里全局设置
//    if (@available(iOS 11.0, *)) {
//        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//
//    } else {
//
//    }
    
    // Do any additional setup after loading the view from its nib.
    //添加导航返回按钮
    [self addBaseBackBarButtonItem];
//状态栏字体为白色
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NSNotificationCenterNeedToUpdate) name:@"NSNotificationCenterNeedToUpdate" object:nil];
    if (![CacheBox didLogin]) {
        //
//        [self NSNotificationCenterVerifyFaild];
    }
}

- (void)NSNotificationCenterVerifyFaild
{
    
    UINavigationController *presentVC = (UINavigationController *)[self getCurrentPresentedViewController];//获取当前rootVC上面present的VC
    if (![presentVC.viewControllers.firstObject isMemberOfClass:[SFBMLoginWithoutPasswordController class]]) {
        
        [CacheBox LoginOutNow];
//        [self showTheMostCommonAlertmessage:@"登录失效，请重新登录"];
        
        SFBMLoginWithoutPasswordController *vc = (SFBMLoginWithoutPasswordController *)[self getControllerFromStoryboard:@"Login" withControllerID:@"SFBMLoginWithoutPasswordController"];
        BaseNavigationController *baseNavi = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:baseNavi animated:YES completion:nil];
        
        UIViewController *currentVC = [self getCurrentVC];
        if (![currentVC isKindOfClass:[SFBMHomeViewController class]]) {
            [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:nil afterDelay:1];
        }
        
    }
    
}
////适配iOS 11以后的iPhone X
//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    if (@available(iOS 11.0, *))
//    {
//        UIEdgeInsets safeAreaInsets = self.view.safeAreaInsets;
//        CGFloat height = 44.0; // 导航栏原本的高度，通常是44.0
//        height += safeAreaInsets.top > 0 ? safeAreaInsets.top : 20.0; // 20.0是statusbar的高度，这里假设statusbar不消失
//        if (self.navigationController.navigationBar && self.navigationController.navigationBar.height != height) {
//            self.navigationController.navigationBar.height = height;
//        }
//
//    } else {
//
//    }
//
//}
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}


- (void)NSNotificationCenterNeedToUpdate
{
    [self showUpdateAlert];
}
- (UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    //    UIView *topView = [[[[UIApplication sharedApplication] keyWindow] subviews]lastObject];
    UIWindow *myWindow = [[UIApplication sharedApplication] keyWindow];
    if ([myWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
        
        result = [(UINavigationController *)myWindow.rootViewController visibleViewController];
        
    }
    return result;
}

- (UIViewController *)getCurrentPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
    
    
}


#pragma mark-  UIBarButtonItem 添加导航条的返回按钮
- (void)addBaseBackBarButtonItem
{
    UIButton *leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [leftBarBtn setBackgroundImage:[UIImage imageNamed:@"nav_back23"] forState:UIControlStateNormal];
    //    [leftBarBtn setBackgroundImage:[UIImage imageNamed:@"nav_back23"] forState:UIControlStateSelected];
    [leftBarBtn setImage:[UIImage imageNamed:@"nav_back_w6"] forState:UIControlStateNormal];
    [leftBarBtn setImage:[UIImage imageNamed:@"nav_back_w6"] forState:UIControlStateSelected];
    
    
    leftBarBtn.frame=CGRectMake(0, 0, 40, 40);
    leftBarBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    
    leftBarBtn.tag = 101;
    [leftBarBtn addTarget:self action:@selector(leftBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)leftBackBtnClick
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    [self.navigationController popViewControllerAnimated:YES];
}

@synthesize contentView = _contentView;

- (SFBMNetNotConnectView *)contentView{
    if (_contentView == nil) {
        _contentView = [[[NSBundle mainBundle] loadNibNamed:@"SFBMNetNotConnectView" owner:nil options:nil] lastObject];
    }
    return _contentView;
}

#pragma mark--网络状态监测管理
-(void)afnNetstatusManage
{
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    __weak typeof(self) _weakSelf = self;
    [manger startMonitoring];
    //2.监听改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown          = -1,
         AFNetworkReachabilityStatusNotReachable     = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                MYNSLog(@"未知");
                [_weakSelf showTheMostCommonAlertmessage:@"网络环境不流畅" direction:HUDDirectionBottom];
                break;
            case AFNetworkReachabilityStatusNotReachable:{
                MYNSLog(@"没有网络");
                [_weakSelf showTheMostCommonAlertmessage:@"无网络无法访问，请检查网络连接" direction:HUDDirectionBottom];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                MYNSLog(@"3G|4G");
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                MYNSLog(@"WiFi");

            }
                break;
            default:
                break;
        }
    }];
    
}
//点击空白处键盘消失
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)pop2Previous:(BOOL)animated
{
    [self.navigationController popViewControllerAnimated:animated];
}
- (void)push2Next:(UIViewController *)viewcontroller animated:(BOOL)animated
{
    [self.navigationController pushViewController:viewcontroller animated:animated];
}


#pragma mark - HUD
-(void)showTheMostCommonAlertmessage:(NSString *)message{
    [self showMessageText:message withLoadMode:MBProgressHUDModeText duration:1.5 direction:HUDDirectionCentral];
}
-(void)showTheMostCommonAlertmessage:(NSString *)message direction:(HUDDirection)direction
{
    [self showMessageText:message withLoadMode:MBProgressHUDModeText duration:1.5 direction:direction];
}

-(void)showMessageText:(NSString *)text withLoadMode:(MBProgressHUDMode)mode duration:(NSTimeInterval)second direction:(HUDDirection)direction
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window?self.view.window:self.view animated:YES];
    CGFloat hudY;
    switch (direction) {
        case HUDDirectionTop:
            hudY = !self.navigationController?hud.backgroundView.centerY - HUDTopMargin:hud.backgroundView.centerY - HUDTopMargin- kNavigationBarHeight;
            hudY = - hudY;
            break;
        case HUDDirectionBottom:
            hudY = hud.backgroundView.centerY - HUDTopMargin- kNavigationBarHeight;
            break;
        default:
            hudY = !self.navigationController?-kNavigationBarHeight:0;
            break;
    }
    hud.offset = CGPointMake(0, hudY);
    
    //[[[UIApplication sharedApplication] delegate] window]
    if (mode) {
        hud.mode = mode;
    }
    if (text) {
        hud.label.text = text;
    }
    hud.label.numberOfLines = 0;
    [self setHUDViewStyleWithHUD:hud];
    [hud hideAnimated:YES afterDelay:second];
}
#pragma mark -Lable 富文本编辑
-(void)addTheMutaleAttributedStringWithLabe:(UILabel *)aLable withColor:(UIColor *)aColor colorRange:(NSRange )corRange withFont:(UIFont *)aFont fontRange:(NSRange )fonRange
{
    NSMutableAttributedString *mutString = [[NSMutableAttributedString alloc] initWithString:aLable.text];
    if (aColor) {
        [mutString addAttribute:NSForegroundColorAttributeName value:aColor range:corRange];
    }
    if (aFont) {
        [mutString addAttribute:NSFontAttributeName value:aFont range:fonRange];
    }
    
    aLable.attributedText = mutString;
    
}
#pragma mark--UIScrollViewDelegate  防止区头停留滑动 默认区头高度是49，如果你的区头高度变了此方法需要重新设定区头高度sectionHeaderHeight 此方法需要根据高度定制，不可在父类统一控制
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    CGFloat sectionHeaderHeight = 49;
//
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}
#pragma mark 设置圆角
-(void)baseCornerRaduisView:(UIView *)sender radius:(CGFloat)radius color:(UIColor *)aColor wide:(CGFloat)wide
{
    sender.layer.cornerRadius = 4;
    if (aColor) {
        sender.layer.borderColor = aColor.CGColor;
        sender.layer.borderWidth = wide;
    }
    if (radius>0) {
        sender.layer.cornerRadius = radius;
    }
    sender.layer.masksToBounds = YES;
    
}

#pragma mark - alertView
- (void)showAlertControllerWithMessage:(NSString *)message buttonTitle:(NSString *)buttonTitle{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    buttonTitle = buttonTitle.length == 0?@"好":buttonTitle;
    UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma  mark - 更新版本
- (void)showUpdateAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您需要更新app才能完成操作" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/app/id1235503687"];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 全局判断是否需要登录
- (void)gotoLoginViewController
{
    
}
- (void)setHUDViewStyleWithHUD:(MBProgressHUD *)hud{
    hud.margin = 12;
    hud.bezelView.layer.cornerRadius = 22;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    //    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    //    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.label.textColor = [UIColor whiteColor];
}
#pragma  mark - 设置默认导航栏
- (void)setDefaultNavigationBar{
    
    //导航栏字体
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:17]}];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : BASECOLOR}];
    [self.navigationController.navigationBar setTintColor:BASECOLOR];
    //设置导航栏背景颜色
    self.navigationController.navigationBar.barTintColor = BASENAVICOLOR;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

@implementation UIViewController (StoryBoard)

#pragma mark 获取storyboard中的Controller
- (UIViewController *)getControllerFromStoryboard:(NSString *)storyboardName withControllerID:(NSString *)ID{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *VC = ID?[sb instantiateViewControllerWithIdentifier:ID]:[sb instantiateInitialViewController];
    return VC;
}
@end

