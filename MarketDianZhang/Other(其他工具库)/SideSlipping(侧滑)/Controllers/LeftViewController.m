//
//  LeftViewController.m
//  ViewControllerTransition
//
//  Created by 陈旺 on 2017/7/10.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "LeftViewController.h"
#import "NextViewController.h"
#import "CWTableViewInfo.h"
#import "UIViewController+CWLateralSlide.h"
#import "BaseNavigationController.h"

#import "YCCollectionViewController.h"
#import <AVFoundation/AVFoundation.h>
#define PICKER_PowerBrowserPhotoLibirayText  @"请在iPhone的“设置->隐私->相机”中允许访问相机"//适配ios11之前的版本

@interface LeftViewController ()

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong)UILabel *userName;
@end

@implementation LeftViewController
{
    CWTableViewInfo *_tableViewInfo;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; //iOS11 设置UIScrollViewContentInsetAdjustmentAutomatic解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题,在选中图片或退出相册时：再重新设置为UIScrollViewContentInsetAdjustmentNever
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupHeader];
    [self setupTableView];
    
    [self.view addSubview:self.headerView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSString *userId = [NSString stringWithFormat:@"%@",[CacheBox getCacheWithKey:USER_ID]];
    if ([CacheBox didLogin]) {
        _userName.text = userId;
        
        
    }else{
        _userName.text = @"登录/注册";
        
    }
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect rect = self.view.frame;
    
    switch (_drawerType) {
        case DrawerDefaultLeft:
            [self.view.superview sendSubviewToBack:self.view];
            break;
        case DrawerTypeMaskLeft:
            rect.size.width = kCWSCREENWIDTH * 0.75;
            break;
        default:
            break;
    }
    self.view.frame = rect;
    
}

-(UIView *)headerView
{
    if (_headerView==nil)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, kCWSCREENWIDTH * 0.75, 100)];
        _headerView.backgroundColor = [UIColor clearColor];
        UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 80, 80)];
        logoImage.centerY = _headerView.height/2;
        logoImage.image = [UIImage imageNamed:@"logo26"];
        [_headerView addSubview:logoImage];
        
        _userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoImage.frame), 0, 145, 80)];
        _userName.text = @" 登录/注册";
        _userName.textAlignment = NSTextAlignmentLeft;
        _userName.centerY = _headerView.height/2;
        _userName.textColor = [UIColor whiteColor];
        _userName.font = [UIFont systemFontOfSize:20];
        [_headerView addSubview:_userName];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginClickPresent)];
        [_headerView addGestureRecognizer:tapGesture];
    }
    return _headerView;
}
- (void)setupHeader {
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCWSCREENWIDTH * 0.75, 200)];
    imageV.backgroundColor = [UIColor clearColor];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:imageV];
}

- (void)setupTableView {
    
    _tableViewInfo = [[CWTableViewInfo alloc] initWithFrame:CGRectMake(0, 300, kCWSCREENWIDTH * 0.75, CGRectGetHeight(self.view.bounds)-300) style:UITableViewStylePlain];
    
    for (int i = 0; i < self.titleArray.count; i++) {
        NSString *title = self.titleArray[i];
        NSString *imageName = self.imageArray[i];
        SEL sel = @selector(didSelectCell:indexPath:);
        CWTableViewCellInfo *cellInfo = [CWTableViewCellInfo cellInfoWithTitle:title imageName:imageName target:self sel:sel];
        [_tableViewInfo addCell:cellInfo];
    }
    
    [self.view addSubview:[_tableViewInfo getTableView]];
    [[_tableViewInfo getTableView] reloadData];
}

#pragma mark - cell点击事件
- (void)didSelectCell:(CWTableViewCellInfo *)cellInfo indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.titleArray.count - 1) { //
//        [self dismissViewControllerAnimated:YES completion:nil];
        [self loginOutClick];
        return;
    }
    
//    if (indexPath.row == self.titleArray.count - 2) { // 显示alertView
//        [self showAlterView];
//        return;
//    }
//
    if (indexPath.row == self.titleArray.count - 2) { // 我的相册
//        [self handleSelectPics];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Things" bundle:nil];
        UIViewController *VC = [sb instantiateViewControllerWithIdentifier:@"YCCollectionViewController"];
        //    [self presentViewController:VC animated:YES completion:nil];
//        [self.navigationController pushViewController:VC animated:YES];
        [self cw_pushViewController:VC];
        return;

    }
    if (indexPath.row == self.titleArray.count - 3) { // 我的文件夹
        UIViewController *VC = [self getControllerFromStoryboard:@"Things" withControllerID:@"SFBMMyFoldersController"];
        [self cw_pushViewController:VC];

        return;
        
    }
    NextViewController *vc = [NextViewController new];
    if (indexPath.row == 0) {
//        if (_drawerType == DrawerDefaultLeft) { // 默认动画左侧滑出的情况用这种present方式
//            [self presentViewController:vc animated:YES completion:nil];
//        }else if (_drawerType == DrawerTypeMaskLeft) { // Mask动画左侧滑出的情况用这种present方式
//            [self cw_presentViewController:vc drewerHiddenDuration:0.01];
//        }else{ // 右侧滑出的情况用这种present方式
//            [self cw_presentViewController:vc];
//        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        if (_drawerType == DrawerTypeMaskLeft) {
            [self cw_pushViewController:vc drewerHiddenDuration:0.01];
        }else {
//            [self cw_pushViewController:vc];
            UIViewController *setVC = [self getControllerFromStoryboard:@"Personal" withControllerID:@"SFBMPersonalCenterController"];
            [self cw_pushViewController:setVC];
            
            return;
        }
    }
}

- (void)showAlterView {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"hello world!" message:@"hello world!嘿嘿嘿" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"😂😄" style:UIAlertActionStyleDefault handler:nil];
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:nil];
}
- (void)loginOutClick
{
    if ([CacheBox didLogin]) {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要退出登录?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [CacheBox LoginOutNow];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SFBMSettingViewControllerPopToRootChangeVCZero" object:nil];
        //        [CYTABBARCONTROLLER setSelectedIndex:0];
        self.tabBarController.selectedIndex = 0;
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UIViewController *VC = [sb instantiateViewControllerWithIdentifier:@"SFBMLoginWithoutPasswordController"];
        
        BaseNavigationController *baseNavi = [[BaseNavigationController alloc] initWithRootViewController:VC];
//        [self.navigationController presentViewController:baseNavi animated:YES completion:nil];
        [self cw_presentViewController:baseNavi];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [CacheBox LoginOutNow];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SFBMSettingViewControllerPopToRootChangeVCZero" object:nil];
            //        [CYTABBARCONTROLLER setSelectedIndex:0];
            self.tabBarController.selectedIndex = 0;
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            UIViewController *VC = [sb instantiateViewControllerWithIdentifier:@"SFBMLoginWithoutPasswordController"];
            
            BaseNavigationController *baseNavi = [[BaseNavigationController alloc] initWithRootViewController:VC];
            //        [self.navigationController presentViewController:baseNavi animated:YES completion:nil];
            [self cw_presentViewController:baseNavi];
            
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action1];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
//        [self loginClickPresent];
    }
    
}
#pragma mark - Getter
- (NSArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = @[@"personal_member_icons",
//                        @"personal_myservice_icons",
                        @"personal_news_icons",
                        @"personal_order_icons",
//                        @"personal_preview_icons",
                        @"personal_service_icons"];
    }
    return _imageArray;
}

- (NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = [@[@"我的日记",
                        @"文件夹",
                        @"我的相册",
                        @"退出登录"] mutableCopy];
    }
    return _titleArray;
}

#pragma mark-- click Action
- (void)loginClickPresent
{
    if (![CacheBox didLogin]) {
        UIViewController *loginVC = [self getControllerFromStoryboard:@"Login" withControllerID:@"SFBMLoginWithoutPasswordController"];
        [self cw_presentViewController:loginVC];
    }

}
@end
