//
//  GLaunchManager.m
//  MarketDianZhang
//
//  Created by HP M on 2019/5/29.
//  Copyright © 2019 sfbm. All rights reserved.
//

#import "GLaunchManager.h"
#import "MyAfnetwork.h"
#import "SFBMWebController.h"
#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
@interface GLaunchManager ()
@property (nonatomic, weak) UIWindow *window;
/// 当前根控制器
@property (nonatomic, strong, readonly) __kindof UIViewController *curRootVC;
@end

@implementation GLaunchManager

+ (GLaunchManager *)sharedInstance
{
    static GLaunchManager *rootVCManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rootVCManager = [[self alloc] init];
    });
    return rootVCManager;
}

- (id)init
{
    if (self = [super init]) {
//        [self startListenException];//监测崩溃信息
    }
    return self;
}

- (void)launchInWindow:(UIWindow *)window
{
    self.window = window;
//    if ([GUserHelper isLogin]) {      // 已登录
//
//    }
//    else {  // 未登录
//
//    }
    [self redirectlyToYouShi];
    return;
    [self appIdInfoNetworking];
    
}

-(void)appIdInfoNetworking
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"app_id"] = @"2019666888";
    __weak typeof(self) weakself = self;
    [MyAfnetwork GET:APP_ID_URL params:params success:^(NSDictionary *myDic) {
//        MYNSLog(@"myDic==%@",myDic);
        NSString *dicStr = (NSString *)myDic;
        NSData *data = [[NSData alloc] initWithBase64EncodedString:dicStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//        MYNSLog(@"jsonDic==%@",jsonDic);
        NSInteger code = [[jsonDic objectForKey:@"code"] integerValue];
        NSInteger is_update = [[jsonDic objectForKey:@"is_update"] integerValue];
        NSInteger is_wap = [[jsonDic objectForKey:@"is_wap"] integerValue];
        NSString *update_url = [jsonDic objectForKey:@"update_url"];
        NSString *wap_url = [jsonDic objectForKey:@"wap_url"];
        if (code==200)
        {
            if (is_update ==1)
            {
                //open  update_url
                SFBMWebController *vc = (SFBMWebController *)[self getControllerFromStoryboard:@"Login" withControllerID:@"SFBMWebController"];
                vc.type = SFBMWebOtherHtml;
                vc.webUrl = update_url;
//                [self push2Next:vc animated:YES];
                [weakself setCurRootVC:vc];
                return;
                
            }else if (is_update==0)
            {
                if (is_wap==1)
                {
                    //open  wap_url
                    SFBMWebController *vc = (SFBMWebController *)[self getControllerFromStoryboard:@"Login" withControllerID:@"SFBMWebController"];
                    vc.type = SFBMWebOtherHtml;
                    vc.webUrl = wap_url;
//                    [self push2Next:vc animated:YES];
                    [weakself setCurRootVC:vc];
                    return;
                }else if (is_wap==0)
                {
                    [weakself redirectlyToYouShi];
                    return;
                }
            }
            
        }
    } fail:^(NSError *error) {
//        MYNSLog(@"error==%@",error);
        [weakself redirectlyToYouShi];
    }];
}
-(void)redirectlyToYouShi
{
    UIStoryboard *sb3 = [UIStoryboard storyboardWithName:@"Things" bundle:nil];
    UIViewController *VC3 = [sb3 instantiateViewControllerWithIdentifier:@"SFBMAllThingsController"];
    VC3.title = @"友事";
    BaseNavigationController *nav3=[[BaseNavigationController alloc] initWithRootViewController:VC3];
    
    UITabBarItem *item3=[[UITabBarItem alloc] initWithTitle:@"友事" image:[[UIImage imageNamed:@"btnClient21"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]selectedImage:[[UIImage imageNamed:@"btnClientClick21"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
    [item3 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:BASECOLOR} forState:UIControlStateSelected];
    //item2.imageInsets=UIEdgeInsetsMake(6, 0, -6, 0);
    VC3.tabBarItem=item3;
    UITabBarController *tabbarC = [[UITabBarController alloc] init];
    tabbarC.viewControllers = [[NSArray alloc] initWithObjects:nav3, nil];
    [self setCurRootVC:tabbarC];
    
}

- (void)setCurRootVC:(__kindof UIViewController *)curRootVC
{
    _curRootVC = curRootVC;
    
    {
        UIWindow *window = self.window ? self.window : [UIApplication sharedApplication].keyWindow;
        for (id view in window.subviews) {
            [view removeFromSuperview];
        }
        [window setRootViewController:curRootVC];
        [window addSubview:curRootVC.view];
        [window makeKeyAndVisible];
    }
}
#pragma mark 获取storyboard中的Controller
- (UIViewController *)getControllerFromStoryboard:(NSString *)storyboardName withControllerID:(NSString *)ID{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *VC = ID?[sb instantiateViewControllerWithIdentifier:ID]:[sb instantiateInitialViewController];
    return VC;
}
@end
