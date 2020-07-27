//
//  BaseTabBarController.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2017/12/25.
//  Copyright © 2017年 sfbm. All rights reserved.
//

#import "BaseTabBarController.h"
#import "SFBMHomeViewController.h"
#import "BaseNavigationController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavigationControllers];
    
}

-(void)addNavigationControllers
{
    //设置字体颜色
    //    [nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
    //    [nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:NAVIBACK_YELLOW} forState:UIControlStateSelected];
    //首页
    UIStoryboard *sb1 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIStoryboard *sb3 = [UIStoryboard storyboardWithName:@"Things" bundle:nil];
    UIStoryboard *sb4 = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];

    UIViewController *VC1 = [sb1 instantiateViewControllerWithIdentifier:@"SFBMHomeViewController"];
//    SFBMTestViewController *VC1 = [[SFBMTestViewController alloc] init];
    VC1.title = @"事情";
    BaseNavigationController *nav1=[[BaseNavigationController alloc] initWithRootViewController:VC1];
    
    UITabBarItem  *item1=[[UITabBarItem alloc] initWithTitle:@"事情" image:[[UIImage imageNamed:@"btnMatter22"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"btnMatterClick22"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item1 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
    [item1 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:BASECOLOR} forState:UIControlStateSelected];
    
    //item.imageInsets=UIEdgeInsetsMake(6, 0, -6, 0);
    VC1.tabBarItem=item1;
    
    //进货单 SFBMAllThingsController
    UIViewController *VC3 = [sb3 instantiateViewControllerWithIdentifier:@"SFBMAllThingsController"];

//    SFBMTestViewController *VC3 = [[SFBMTestViewController alloc] init];

    VC3.title = @"友事";

    BaseNavigationController *nav3=[[BaseNavigationController alloc] initWithRootViewController:VC3];
    
    UITabBarItem *item3=[[UITabBarItem alloc] initWithTitle:@"友事" image:[[UIImage imageNamed:@"btnClient21"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]selectedImage:[[UIImage imageNamed:@"btnClientClick21"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
    [item3 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:BASECOLOR} forState:UIControlStateSelected];
    //item2.imageInsets=UIEdgeInsetsMake(6, 0, -6, 0);
    VC3.tabBarItem=item3;
    //订单
    UIViewController *VC4 = [sb4 instantiateViewControllerWithIdentifier:@"SFBMPersonalCenterController"];
//    SFBMTestViewController *VC4 = [[SFBMTestViewController alloc] init];

    VC4.title = @"我的";

    BaseNavigationController *nav4=[[BaseNavigationController alloc] initWithRootViewController:VC4];
    
    UITabBarItem *item4=[[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"btnMe23"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]selectedImage:[[UIImage imageNamed:@"btnMeOnclick23"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item4 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
    [item4 setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:BASECOLOR } forState:UIControlStateSelected];
    VC4.tabBarItem=item4;
    
    //    moreVC.jpushStr = self.jpushStrRoot;
    

    //添加小红点(收到推送以后显示)
    //    if (_jpushStr.length>0) {
    //        item4.badgeValue = _jpushStr;
    //
    //    }
    
    //        fifthVC.tabBarItem.badgeValue = @"99";
    //        fifthVC.navigationController.tabBarItem.badgeValue = @"99";
    //    fifthVC.tabBarItem.badgeValue = @"99";
    
    //选择器
    UITabBarController *tabarVC=[[UITabBarController alloc] init];
    tabarVC.delegate=self;
//    self.viewControllers=[[NSArray alloc] initWithObjects:nav1,nav3,nav4, nil];
    self.viewControllers=[[NSArray alloc] initWithObjects:nav3, nil];

    
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //此处可以添加各种判断，点击时各种处理
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
