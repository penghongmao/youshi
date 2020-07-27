//
//  SFBMMyImportantThingsController.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2018/1/12.
//  Copyright © 2018年 sfbm. All rights reserved.
//

#import "SFBMMyImportantThingsController.h"
//#import "SFBMPayflowModel.h"
#import "SFBMNetNotConnectView.h"
#import "SFBMMyImportantThingsCell.h"

#import "TabView.h"
#import "JMDropMenu.h"

#import "MMManage.h"

@interface SFBMMyImportantThingsController ()<TabViewDelegate,UITableViewDelegate,TabViewDelegate,JMDropMenuDelegate>
{
    NSInteger currentPage;
    BOOL loadMore;
    
    NSInteger _selectItem;
    NSInteger currentPage2;
    NSMutableArray *_titleArray;
    BOOL loadMore2;
}
@property (nonatomic , strong) NSMutableArray *data;
@property (nonatomic , strong) NSMutableArray *data2;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic, strong) MJRefreshNormalHeader *header;
@property (nonatomic,strong) SFBMNetNotConnectView *emptyView;
@property (nonatomic, strong) TabView *tabView; //选择
/** titleArr */
@property (nonatomic, strong) NSArray *titleArr;
/** imgArr */
@property (nonatomic, strong) NSArray *imageArr;

@end

@implementation SFBMMyImportantThingsController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;//显示底部 tabBar

//    [self getProtertyList];
    
//    [self getProtertyList2];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _data = [NSMutableArray array];
    _data2 = [NSMutableArray array];
    _data = (NSMutableArray *)@[@[@"",@""],@[@"",@""]];
    _data2 = (NSMutableArray *)@[@[@"",@"",@""],@[@"",@"",@"",@""]];

    self.titleArr = @[@"文件夹",@"归档",@"回收站"];
    self.imageArr = @[@"shapeCopy34",@"shapeCopy35",@"shapeCopy33"];
    
    _titleArray = [NSMutableArray arrayWithObjects:@"已置顶",@"其他", nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //加上一个tabView
    self.tabView = [[TabView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45) titles:@[@"事 情",@"提 醒"]];
    self.tabView.delegate = self;
    [self.view insertSubview:self.tabView atIndex:1];
    
//    [self example16];
    [self cellLineMoveLeft];
    [self addRightBarButtons];
}
- (void)addRightBarButtons
{
    UIButton *leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBarBtn setTitle:@" 友事" forState:UIControlStateNormal];
    [leftBarBtn setImage:[UIImage imageNamed:@"btnMenu10"] forState:UIControlStateNormal];
    [leftBarBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    leftBarBtn.frame=CGRectMake(0, 0, 64, 44);
    leftBarBtn.tag = 12;
    [leftBarBtn addTarget:self action:@selector(rightBarBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem0 = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftItem0;
    
//    UIButton *rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [leftBarBtn1 setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
//    [rightBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [rightBtn1 setTitle:@"搜索" forState:UIControlStateNormal];
//    [rightBtn1.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    rightBtn1.frame=CGRectMake(0, 0, 80, 30);
//    rightBtn1.tag = 11;
//    [rightBtn1 addTarget:self action:@selector(rightBarBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
//    rightBtn1.layer.cornerRadius = 4;
//    rightBtn1.layer.borderColor = [UIColor whiteColor].CGColor;
//    rightBtn1.layer.borderWidth = 0.5;
//    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn1];
//    self.navigationItem.rightBarButtonItem = rightItem1;
}

//查询所有事件
- (void)selectMyDiaryData
{
    NSString *note = @"base64image=";
    //查询整张表
    NSArray *diaryArray  = [[MMManage sharedLH] selectFromTableWithTableName:DIARY_TABLE];
    MYNSLog(@"_diaryArray==%@",diaryArray);
    if (diaryArray.count>0) {
        NSDictionary *diaryDic = [diaryArray lastObject];
        NSString *contenttitle = diaryDic[@"title"];
        NSString *contentStr = diaryDic[@"content"];
        
        
        NSArray *contentArr = [contentStr componentsSeparatedByString:@"<br />"];
        NSString *imageStr = [contentArr lastObject];
        if ([imageStr containsString:note]) {
            NSArray *imageArr0 = [imageStr componentsSeparatedByString:note];
            NSString *imageStr0 = [imageArr0 lastObject];
            UIImage *diaryImage = [NSString Base64StrToUIImage:imageStr0];
            MYNSLog(@"diaryImage=%@",diaryImage);
            MYNSLog(@"diaryImagewidth=%f",diaryImage.size.width);
            //需要重新建模型
            
        }
        
    }
}

- (void)cellLineMoveLeft {
    //cell分割线向左移动15像素
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

#pragma mark- TabViewDelegate
//选中某一个
- (void)tabViewDidSelectAtIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {
            _selectItem = 0;
            if (self.data2.count>0) {
                self.emptyView.hidden = YES;
            }else{
                self.emptyView.hidden = NO;
                
            }
            [self.tableView reloadData];
            [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
        }
            //            [_mapView removeAnnotations:_mapView.annotations];
            //            [_mapView addAnnotations:_data];
            break;
        case 1://
        {
            _selectItem = 1;
            if (self.data.count>0) {
                self.emptyView.hidden = YES;
            }else{
                self.emptyView.hidden = NO;
                
            }
            [self.tableView reloadData];
            [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
        }
            //            [_mapView removeAnnotations:_mapView.annotations];
            //            [_mapView addAnnotations:_batteryArray];
            break;
        default:
            break;
    }
    
}

#pragma mark UITableView + 上拉刷新 默认
//- (void)example16
//{
//    // 添加默认的下拉刷新
//    [self example01];
//    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）上拉加载更多
//    self.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataOrNot:)];
//    self.footer.automaticallyHidden = YES;
//    // 设置字体
//    self.footer.stateLabel.font = [UIFont systemFontOfSize:15];
//    // 设置颜色
//    self.footer.stateLabel.textColor = [UIColor blackColor];
//    // 设置footer
//    self.tableView.mj_footer = self.footer;
//}
//
//- (void)example01
//{
//
//    __weak __typeof(self) weakSelf = self;
//
//    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
//    self.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        if (_selectItem==0) {
//            currentPage2 = 0;
//            [_data2 removeAllObjects];
//            [weakSelf getProtertyList2];
//        }else{
//            currentPage = 0;
//            [_data removeAllObjects];
//            [weakSelf getProtertyList];
//        }
//    }];
//    self.tableView.mj_header = self.header;
//    // 马上进入刷新状态
//    [self.tableView.mj_header beginRefreshing];
//
//}
//
//- (void)loadMoreDataOrNot:(MJRefreshAutoNormalFooter *)footer
//{
//    if (currentPage>0&&loadMore == YES&&_selectItem==0) {
//        [self getProtertyList2];
//    }else if (currentPage2>0&&loadMore2 == YES&&_selectItem==1){
//        [self getProtertyList];
//    }
//    else{
//        [footer setTitle:@"没有更多数据了" forState:MJRefreshStateIdle];
//        [footer setTitle:@"加载更多 ..." forState:MJRefreshStateRefreshing];
//        [footer setTitle:@"没有更多数据了33" forState:MJRefreshStateNoMoreData];
//        [self.tableView.mj_footer endRefreshing];
//        MYNSLog(@"没有更多了");
//    }
//}


#pragma mark - tableViewDataSource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _selectItem==0? _data2.count:_data.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr1 = _data[section];
    NSArray *arr2 = _data2[section];

    return _selectItem==0? arr1.count:arr2.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    //    headerView.backgroundColor = [UIColor redColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-12, 35)];
    NSString *title = _titleArray[section];
    headerLabel.text = title;
    headerLabel.textColor = RGBA(150, 150, 150, 1);
    headerLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:headerLabel];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SFBMMyImportantThingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SFBMMyImportantThingsCell"];
    
//    cell.model = [_selectItem==0? _data2:_data objectAtIndex:indexPath.row];
    if (indexPath.section==0) {
        cell.cellLeftView.backgroundColor = RGBA((arc4random()%255), (arc4random()%255), (arc4random()%255), 1);
        cell.cellRightView.backgroundColor = RGBA((arc4random()%255), (arc4random()%255), (arc4random()%255), 1);
    }else{
        cell.cellLeftView.backgroundColor = RGBA(252, 145, 145, 1);
        cell.cellRightView.backgroundColor = RGBA(252, 145, 145, 1);

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell* )cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
#pragma  mark network
//
//- (void)getProtertyList{
//
//    NSString *userId = [CacheBox getCacheWithKey:USER_ID];
//    NSString *token = [CacheBox getCacheWithKey:USER_TOKEN];
//
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"userId"] = userId;
//    params[@"token"] = token;
//    params[@"beginNum"] = [NSString stringWithFormat:@"%ld",(long)currentPage*LINITCount];
//    params[@"pageCount"] = [NSString stringWithFormat:@"%d",LINITCount];
//
//    __weak __typeof(self) weakSelf = self;
//    [MyAfnetwork postUrl:USERPAYFLOW_URL baseURL:BASE_URL withHUD:NO message:nil parameters:params getChat:^(NSDictionary *myDic) {
//        if (weakSelf.header.isRefreshing) {
//            [weakSelf.header endRefreshing];
//        }
//        NSArray *arr = [myDic objectForKey:@"bills"];
//        NSMutableArray *data = [SFBMPayflowModel mj_objectArrayWithKeyValuesArray:arr];
//        if (data.count == 0) {
//            [weakSelf.view addSubview:weakSelf.emptyView];
//        }else{
//            if (currentPage == 0) {
//                weakSelf.data = data;
//            }else{
//                [weakSelf.data addObjectsFromArray:data];
//            }
//            if (weakSelf.data.count == LINITCount) {
//                currentPage = currentPage + 1;
//                loadMore = YES;
//            }else{
//                loadMore = NO;
//            }
//
//            [weakSelf.tableView reloadData];
//        }
//
//        if (weakSelf.data2.count>0) {
//            _emptyView.hidden = YES;
//        }
//
//    } failure:^{
//        [weakSelf showTheMostCommonAlertmessage:NetOrServiceFailed];
//    }];
//
//
//    [self.tableView.mj_footer endRefreshing];
//
//}
//
//- (void)getProtertyList2{
//
//    NSString *userId = [CacheBox getCacheWithKey:USER_ID];
//    NSString *token = [CacheBox getCacheWithKey:USER_TOKEN];
//
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"userId"] = userId;
//    params[@"token"] = token;
//    params[@"beginNum"] = [NSString stringWithFormat:@"%ld",(long)currentPage*LINITCount];
//    params[@"pageCount"] = [NSString stringWithFormat:@"%d",LINITCount];
//
//    __weak __typeof(self) weakSelf = self;
//    [MyAfnetwork postUrl:USERCONSUME_URL baseURL:BASE_URL withHUD:NO message:nil parameters:params getChat:^(NSDictionary *myDic) {
//        if (weakSelf.header.isRefreshing) {
//            [weakSelf.header endRefreshing];
//        }
//        NSArray *arr = [myDic objectForKey:@"data"];
//        NSMutableArray *data = [SFBMPayflowModel mj_objectArrayWithKeyValuesArray:arr];
//        if (data.count == 0) {
//            [weakSelf.view addSubview:weakSelf.emptyView];
//        }else{
//            if (currentPage2 == 0) {
//                weakSelf.data2 = data;
//            }else{
//                [weakSelf.data2 addObjectsFromArray:data];
//            }
//            if (weakSelf.data2.count == LINITCount) {
//                currentPage2 = currentPage2 + 1;
//                loadMore2 = YES;
//            }else{
//                loadMore2 = NO;
//            }
//
//            [weakSelf.tableView reloadData];
//        }
//
//        if (weakSelf.data2.count>0) {
//            _emptyView.hidden = YES;
//        }
//    } failure:^{
//        [weakSelf showTheMostCommonAlertmessage:NetOrServiceFailed];
//    }];
//
//
//    [self.tableView.mj_footer endRefreshing];
//
//}

-(SFBMNetNotConnectView *)emptyView
{
    if (!_emptyView) {
        _emptyView = self.contentView;
        _emptyView.frame = CGRectMake(0, 55, SCREEN_WIDTH, SCREEN_HEIGHT-55);
        _emptyView.state = SFBMViewStateNoData;
        
    }
    
    return _emptyView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)rightBarBtnSelect:(UIButton *)button
{
    if (button.tag==11) {
        //SFBMCouponSelectViewController
        UIViewController *vc = [self getControllerFromStoryboard:@"Main" withControllerID:@"SFBMCreateCustomerViewController"];
        [self push2Next:vc animated:YES];
    }else{
#pragma mark - 左边下拉菜单
    [JMDropMenu showDropMenuFrame:CGRectMake(8, 64, 120, 128) ArrowOffset:16.f TitleArr:self.titleArr ImageArr:self.imageArr Type:JMDropMenuTypeWeChat LayoutType:JMDropMenuLayoutTypeNormal RowHeight:40.f Delegate:self];

    }
}

- (void)didSelectRowAtIndex:(NSInteger)index Title:(NSString *)title Image:(NSString *)image {
    NSLog(@"index----%zd,  title---%@, image---%@", index, title, image);
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

