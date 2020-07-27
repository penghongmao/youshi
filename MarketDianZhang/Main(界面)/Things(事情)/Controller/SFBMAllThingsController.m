//
//  SFBMAllThingsController.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2018/7/19.
//  Copyright © 2018年 sfbm. All rights reserved.
//

#import "SFBMAllThingsController.h"
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
#import "SFBMWebController.h"
#import "SFBMUIWebViewVC.h"
//测试
#import "YCCollectionViewController.h"
@interface SFBMAllThingsController ()
{
    NSMutableArray *_diaryArray;
    XLChannelView *_channelView;
    NSMutableArray *_diaryColorArray;
}
@property(nonatomic,strong) NSString *titlse;
@property(nonatomic,strong) XLChannelView *channelView;
@end

@implementation SFBMAllThingsController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;//显示底部 tabBar
    _diaryColorArray = [NSMutableArray arrayWithObjects:DIARYCOLOR1,DIARYCOLOR2,DIARYCOLOR3,DIARYCOLOR4,DIARYCOLOR5,DIARYCOLOR6, nil];
    [self selectMyDiaryData];
    [self appIdInfoNetworking];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addRightBarButtons];
//    [self showChannel];
    [self.view addSubview:self.channelView];
    [self addUIDragImageView];
}

#pragma mark--set UI
-(XLChannelView *)channelView
{
    if (!_channelView) {
        _channelView = [[XLChannelView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        

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
        //SFBMCouponSelectViewController
        UIViewController *vc = [self getControllerFromStoryboard:@"Main" withControllerID:@"SFBMCreateCustomerViewController"];
        [self push2Next:vc animated:YES];
    }else{
        
        UIViewController *vc = [self getControllerFromStoryboard:@"Main" withControllerID:@"SFBMMutableEditingController"];
        [self push2Next:vc animated:YES];
        
        //模拟本地和网络同步数据的代码
        /*
         NSString *userid = [CacheBox getCacheWithKey:USER_ID];
         if (userid.length>0) {
         //已登录
         BOOL needUpload = NO;//是否需要同步上传
         if (_diaryArray.count>0)
         {
         //创建本地 表 如果表已经存在，不会新建
         [[MMManage sharedLH] creatDatabaseTableWithTableName:DIARYSERVER_TABLE forClass:[SFBMDiaryServerModel class]];
         NSMutableArray *uploadServerArray = [NSMutableArray arrayWithCapacity:0];
         for(NSDictionary *dic in _diaryArray)
         {
         
         NSString *upload = [dic objectForKey:@"upload"];
         if ([upload isEqualToString:@"0"])
         {
         
         needUpload = YES;//此条数据需要同步
         NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
         [mutDic setValue:@"1" forKey:@"upload"];
         
         BOOL change = [[MMManage sharedLH]updateContentMessageWithID:[mutDic objectForKey:@"id"] withContentDic:mutDic withTableName:DIARY_TABLE forClass:[SFBMDiaryModel2 class]];
         if (change==NO) {
         MYNSLog(@"更新失败，");
         }
         [mutDic removeObjectForKey:@"id"];
         
         [mutDic setValue:[CacheBox getCacheWithKey:USER_ID] forKey:USER_ID];
         [uploadServerArray addObject:mutDic];
         }
         }
         
         if (needUpload==NO)
         {
         [self showTheMostCommonAlertmessage:@"没有需要同步的数据"];
         }else
         {
         //uploadServerArray
         BOOL success = NO;
         
         success = [[MMManage sharedLH] insertContentList:uploadServerArray WithTableName:DIARYSERVER_TABLE forClass:[SFBMDiaryServerModel class]];
         
         if(success==YES){
         [self showTheMostCommonAlertmessage:@"同步成功"];
         //更新数据
         [self selectMyDiaryData];
         }else{
         [self showTheMostCommonAlertmessage:@"失败了，请重试"];
         }
         }
         }
         
         }else{
         [self showTheMostCommonAlertmessage:@"您还没有登录，请先登录"];
         }
         */
    }
}

#pragma mark--set datasource
- (void)selectMyDiaryData
{
    NSString *note = @"base64image=";
    //查询整张表
    _diaryArray  = [[MMManage sharedLH] selectFromTableWithTableName:DIARY_TABLE];
    
    MYNSLog(@"_diaryArray==%@",_diaryArray);
    if (_diaryArray.count>0)
    {
        NSDictionary *diaryDic = [_diaryArray firstObject];
//        NSString *time = diaryDic[@"time"];
//        MYNSLog(@"time==%@",time);
//        if (time.length==0) {
//            MYNSLog(@"time.length=1=%ld",time.length);
//
//        }else{
//            MYNSLog(@"time.length=2=%ld",time.length);
//        }
        NSString *contentStr = diaryDic[@"content"];
        NSArray *contentArr = [contentStr componentsSeparatedByString:@"<br />"];
        
        NSString *imageStr = [contentArr lastObject];
        if ([imageStr containsString:note]) {
            NSArray *imageArr0 = [imageStr componentsSeparatedByString:note];
            NSString *imageStr0 = [imageArr0 lastObject];
            UIImage *diaryImage = [NSString Base64StrToUIImage:imageStr0];
            //            MYNSLog(@"diaryImage=%@",diaryImage);
            //            MYNSLog(@"diaryImagewidth=%f",diaryImage.size.width);
            //需要重新建模型
            
        }
        
    }
    //如果没有数据，初始化的时候有一条自带数据
    if (_diaryArray.count==0) {
        //
        NSDictionary *modeDic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"color",@"我是正文内容",@"content",@"0",@"id",@"2019-02-23 18:20",@"time",@"请点我开始记录美好生活",@"title",@"0",@"upload", nil];
        [_diaryArray addObject:modeDic];
        
    }
    NSMutableArray *muArr = [NSMutableArray array];
    for(NSDictionary *dic in _diaryArray)
    {
        SFBMDiaryModel2 *thing = [[SFBMDiaryModel2 alloc] initWithDic:dic];
        [muArr addObject:thing];
    }

    self.channelView.inUseTitles = [NSMutableArray arrayWithArray:muArr];

    [self.channelView reloadData];

    //
    //    //根据Person对象的 name 属性 按中文 对 Person数组 排序
    //    self.indexArray = [BMChineseSort IndexWithArray:muArr Key:@"name"];
    //    self.letterResultArr = [BMChineseSort sortObjectArray:muArr Key:@"name"];
    //    [self.indexArray insertObject:@"最近好友" atIndex:0];
    //
    //    NSMutableArray *muArr2 = [NSMutableArray array];
    //    MyContactListModel2 *people = [[MyContactListModel2 alloc] init];
    //    people.name = @"客户小李";
    //    people.ID = @"";
    //    people.company = @"万圣金融有限公司";
    //
    //    [muArr2 addObject:people];
    //    [self.letterResultArr insertObject:muArr2 atIndex:0];
    //
    //    [self.tableView reloadData];
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
-(void)appIdInfoNetworking
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"app_id"] = @"2019666888";
    
    [MyAfnetwork GET:APP_ID_URL params:params success:^(NSDictionary *myDic) {
        MYNSLog(@"myDic==%@",myDic);
        NSString *dicStr = (NSString *)myDic;
        NSData *data = [[NSData alloc] initWithBase64EncodedString:dicStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        MYNSLog(@"jsonDic==%@",jsonDic);
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
                [self push2Next:vc animated:YES];
            }else if (is_update==0)
            {
                if (is_wap==1)
                {
//                    SFBMWebController *vc2 = (SFBMWebController *)[self getControllerFromStoryboard:@"Login" withControllerID:@"SFBMWebController"];
//                    vc2.type = SFBMWebOtherHtml;
//                    vc2.webUrl = wap_url;
//                    [self push2Next:vc2 animated:YES];
//                    return ;
//                    SFBMUIWebViewVC *vc1 = [[SFBMUIWebViewVC alloc] init];
//                    vc1.type = SFBMWebOtherHtml;
////                    vc1.webUrl = update_url;
////                    vc1.webUrl = @"http:www.baidu.com";
//                    vc1.webUrl = @"http://pingguo.zz-app.com:256";
//
//                    [self push2Next:vc1 animated:YES];
//                    return ;
                    //open  wap_url
                    SFBMWebController *vc = (SFBMWebController *)[self getControllerFromStoryboard:@"Login" withControllerID:@"SFBMWebController"];
                    vc.type = SFBMWebOtherHtml;
                    vc.webUrl = wap_url;
                    [self push2Next:vc animated:YES];
                }else if (is_wap==0)
                {
                    //
                }
            }
            
        }
    } fail:^(NSError *error) {
         MYNSLog(@"error==%@",error);
    }];
}
@end
