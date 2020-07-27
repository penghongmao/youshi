//
//  SFBMAllMyCustomersController.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2017/12/22.
//  Copyright © 2017年 sfbm. All rights reserved.
//

#import "SFBMAllMyCustomersController.h"
#import "SFBMHomeViewControllerCell0.h"
#import "SFBMCustomerMessageDetailController.h"
#import "WPFViewController.h"
#import "MMManage.h"
#import "MyContactListModel2.h"
@interface SFBMAllMyCustomersController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArray;
    NSArray *_titleArray;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SFBMAllMyCustomersController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    self.tabBarController.tabBar.hidden = NO;//显示底部 tabBar
    //    self.tabBarController.tabBar.translucent = NO;//底部 tabBar取消透明
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"所有客户";

    _tableView.backgroundColor = RGBA(241, 240, 246, 1);
    //初始化
    _dataArray = [NSMutableArray array];
//    _dataArray =(NSMutableArray *) @[@"a沈万三",@"b沈万三",@"c沈万三",@"d沈万三",@"f沈万三",@"h沈万三",@"w沈万三"];
    
    [self addRightBarButtons];
    [self addMyData];
}

- (void)addMyData
{
    //查询整张表
    NSArray *arr1  = [[MMManage sharedLH] selectFromTableWithTableName:CONTACT_TABLE];
    
    for(NSDictionary *dic in arr1)
    {
        
        MyContactListModel2 *people = [[MyContactListModel2 alloc] initWithDic:dic];
        [_dataArray addObject:people];
    }
    
    [self.tableView reloadData];
}
- (void)addRightBarButtons
{

    UIButton *rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [leftBarBtn1 setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [rightBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn1 setTitle:@"搜索" forState:UIControlStateNormal];
    [rightBtn1.titleLabel setFont:[UIFont systemFontOfSize:15]];
    rightBtn1.frame=CGRectMake(0, 0, 80, 30);
    rightBtn1.tag = 12;
    [rightBtn1 addTarget:self action:@selector(rightBarBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn1.layer.cornerRadius = 4;
    rightBtn1.layer.borderColor = [UIColor whiteColor].CGColor;
    rightBtn1.layer.borderWidth = 0.5;
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn1];
    self.navigationItem.rightBarButtonItem = rightItem1;
}
#pragma mark - tableViewDataSource and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SFBMHomeViewControllerCell0 *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"SFBMHomeViewControllerCell0"];
    MyContactListModel2 *p = [_dataArray objectAtIndex:indexPath.row];
    cell.cellTitleL.text = p.name;
    cell.cellDetailL.text = p.company;
    UIImage *headImage = [UIImage imageWithData:p.headpath];
    if(!p.headpath){
        headImage = [UIImage imageNamed:@"group29"];
    }
    cell.cellImageV.image = headImage;

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
//    footerView.backgroundColor = [UIColor whiteColor];
//
//    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [footerButton setTitle:@"更多..." forState:UIControlStateNormal];
//    [footerButton setTitleColor:RGBA(149, 146, 146, 1) forState:UIControlStateNormal];
//    [footerButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    footerButton.frame = CGRectMake(10, 0, SCREEN_WIDTH-10, 50);
//    footerButton.tag = section+100;
//    [footerButton addTarget:self action:@selector(footerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [footerView addSubview:footerButton];
//
//    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(footerView.frame)-0.5, SCREEN_WIDTH, 0.5)];
//    imageV.backgroundColor = [UIColor lightGrayColor];
//    [footerView addSubview:imageV];
//    if (section==0) {
//        return footerView;
//    }else{
//        return nil;
//    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 23)];
//    //    headerView.backgroundColor = [UIColor redColor];
//    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-12, 23)];
//    NSString *title = _titleArray[section];
//    headerLabel.text = title;
//    headerLabel.textColor = RGBA(150, 150, 150, 1);
//    headerLabel.font = [UIFont systemFontOfSize:14];
//    [headerView addSubview:headerLabel];
//    return headerView;
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYNSLog(@"1111--");
    SFBMCustomerMessageDetailController *VC = (SFBMCustomerMessageDetailController *)[self getControllerFromStoryboard:@"Main" withControllerID:@"SFBMCustomerMessageDetailController"];
    MyContactListModel2 *p = [_dataArray objectAtIndex:indexPath.row];
    VC.model = p;//
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    if ([segue.identifier isEqualToString:@"SFBMCustomerMessageDetailControllerSegue"]) {
//        SFBMCustomerMessageDetailController *detailsVC = segue.destinationViewController;
//        detailsVC.idString = sender;
//        NSLog(@"2222--");
//
//    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell* )cell forRowAtIndexPath:(NSIndexPath *)indexPat{
}

/**
 *  布局视图
 */
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark--ACTION
//-(void)footerButtonClick:(UIButton *)button
//{
//    if (button.tag==100)
//    {
//        UIViewController *vc = [self getControllerFromStoryboard:@"Main" withControllerID:@"SFBMAllMyCustomersController"];
//        [self push2Next:vc animated:YES];
//
//    }
//}
- (void)rightBarBtnSelect:(UIButton *)button
{
    if (button.tag==11) {

    }else{
        //WPFViewController
        WPFViewController *vc = [[WPFViewController alloc] init];
        [self push2Next:vc animated:YES];    }
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

