//
//  SFBMOneTypeThingsController.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2018/8/2.
//  Copyright © 2018年 sfbm. All rights reserved.
//

#import "SFBMOneTypeThingsController.h"
#import "XLChannelView.h"
#import "MMManage.h"
#import "SFBMDiaryModel2.h"
#import "SFBMDiaryModel.h"
#import "SFBMDiaryServerModel.h"
//侧滑
#import "LeftViewController.h"
#import "RightViewController.h"
//#import "CWScrollView.h"
#import "CWTableViewInfo.h"
#import "UIViewController+CWLateralSlide.h"
#import "MMDragImageView.h"
@interface SFBMOneTypeThingsController ()
{
    NSMutableArray *_diaryArray;
    XLChannelView *_channelView;
    NSMutableArray *_diaryColorArray;
}
@property(nonatomic,strong) NSString *titlse;
@property(nonatomic,strong) XLChannelView *channelView;
@end

@implementation SFBMOneTypeThingsController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;//显示底部 tabBar
    _diaryColorArray = [NSMutableArray arrayWithObjects:DIARYCOLOR1,DIARYCOLOR2,DIARYCOLOR3,DIARYCOLOR4,DIARYCOLOR5,DIARYCOLOR6, nil];
    [self selectMyDiaryData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self addRightBarButtons];
    [self.view addSubview:self.channelView];
//    [self addUIDragImageView];
}

#pragma mark--set UI
-(XLChannelView *)channelView
{
    if (!_channelView) {
        _channelView = [[XLChannelView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
    }
    return _channelView;
}
-(void)addUIDragImageView
{
    MMDragImageView *dragImageV = [[MMDragImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60,SCREEN_HEIGHT-60-64-49, 60, 60)];
    dragImageV.layer.cornerRadius = 30;
    dragImageV.backgroundColor = [UIColor clearColor];
    dragImageV.image = [UIImage imageNamed:@"editingNow36"];
    [self.view addSubview:dragImageV];
    
    [dragImageV setActionBlock:^{
        UIViewController *vc = [self getControllerFromStoryboard:@"Main" withControllerID:@"SFBMMutableEditingController"];
        [self push2Next:vc animated:YES];
    }];
}
-(void)showChannel
{
    //    NSArray *arr1 = @[@"教育",@"动漫",@"政务",@"纪录片",@"房产",@"佛学",@"股票",@"理财"];
    //    NSArray *arr2 = @[@"韩流",@"探索",@"综艺",@"美食",@"育儿"];
    //    [[XLChannelControl shareControl] showChannelViewWithInUseTitles:arr1 unUseTitles:arr2 finish:^(NSArray *inUseTitles, NSArray *unUseTitles) {
    //        NSLog(@"inUseTitles = %@",inUseTitles);
    //        NSLog(@"unUseTitles = %@",unUseTitles);
    //    }];
    _channelView = [[XLChannelView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //    _channelView.inUseTitles = [NSMutableArray arrayWithArray:arr1];
    //    _channelView.unUseTitles = [NSMutableArray arrayWithArray:arr2];
    
    [self.view addSubview:_channelView];
}
- (void)addRightBarButtons
{
    UIButton *leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBarBtn setTitle:@" 友事" forState:UIControlStateNormal];
    [leftBarBtn setImage:[UIImage imageNamed:@"btnMenu10"] forState:UIControlStateNormal];
    [leftBarBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    leftBarBtn.frame=CGRectMake(0, 0, 64, 44);
    leftBarBtn.tag = 11;
    [leftBarBtn addTarget:self action:@selector(defaultAnimationFromLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem0 = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftItem0;
    
    UIButton *rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [leftBarBtn1 setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [rightBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn1 setTitle:@"新建" forState:UIControlStateNormal];
    [rightBtn1.titleLabel setFont:[UIFont systemFontOfSize:15]];
    rightBtn1.frame=CGRectMake(0, 0, 60, 30);
    rightBtn1.tag = 12;
    [rightBtn1 addTarget:self action:@selector(rightBarBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn1.layer.cornerRadius = 4;
    rightBtn1.layer.borderColor = [UIColor whiteColor].CGColor;
    rightBtn1.layer.borderWidth = 0.5;
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn1];
    self.navigationItem.rightBarButtonItem = rightItem1;
}
- (void)rightBarBtnSelect:(UIButton *)button
{
    if (button.tag==11) {

    }else{
        
        UIViewController *vc = [self getControllerFromStoryboard:@"Main" withControllerID:@"SFBMMutableEditingController"];
        [self push2Next:vc animated:YES];
        

    }
}

#pragma mark--set datasource
- (void)selectMyDiaryData
{
    NSString *note = @"base64image=";
    //查询整张表
//    _diaryArray  = [[MMManage sharedLH] selectFromTableWithTableName:DIARY_TABLE];
    _diaryArray = [self.oneTypeDiary mutableCopy];
    //        MYNSLog(@"_diaryArray==%@",_diaryArray);
    
    NSMutableArray *muArr = [NSMutableArray array];
    for(NSDictionary *dic in _diaryArray)
    {
        SFBMDiaryModel2 *thing = [[SFBMDiaryModel2 alloc] initWithDic:dic];
        [muArr addObject:thing];
    }
    
    self.channelView.inUseTitles = [NSMutableArray arrayWithArray:muArr];
    [self.channelView reloadData];
}

#pragma mark - 侧滑 点击事件
// 仿QQ从左侧划出
- (void)defaultAnimationFromLeft {
    // 自己随心所欲创建的一个控制器
    LeftViewController *vc = [[LeftViewController alloc] init];
    
    // 这个代码与框架无关，与demo相关，因为有兄弟在侧滑出来的界面，使用present到另一个界面返回的时候会有异常，这里提供各个场景的解决方式，需要在侧滑的界面present的同学可以借鉴一下！处理方式在leftViewController的viewDidAppear:方法内。
    // 另外一种方式 直接使用 cw_presentViewController:方法也可以，两个方法的表示形式有点差异
    vc.drawerType = DrawerDefaultLeft; // 为了表示各种场景才加上这个判断，如果只有单一场景这行代码完全不需要
    
    // 调用这个方法
    [self cw_showDefaultDrawerViewController:vc];
    // 或者这样调用
    //    [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeDefault configuration:nil];
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
