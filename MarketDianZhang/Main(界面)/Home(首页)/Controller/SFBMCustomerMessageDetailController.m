//
//  SFBMCustomerMessageDetailController.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2018/1/11.
//  Copyright © 2018年 sfbm. All rights reserved.
//

#import "SFBMCustomerMessageDetailController.h"
#import "SFBMHomeViewControllerCell0.h"
#import "SFBMCustomerMessageDetailController.h"
#import "SFBMCreateCustomerViewController.h"
@interface SFBMCustomerMessageDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArray;
    NSArray *_titleArray;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *noteBtn0;
@property (weak, nonatomic) IBOutlet UIButton *noteBtn1;
@property (weak, nonatomic) IBOutlet UIButton *noteBtn2;
@property (weak, nonatomic) IBOutlet UIButton *noteBtn3;
@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UILabel *viewName;
@property (weak, nonatomic) IBOutlet UILabel *viewCompany;

@end

@implementation SFBMCustomerMessageDetailController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //    self.tabBarController.tabBar.hidden = NO;//显示底部 tabBar
    //    self.tabBarController.tabBar.translucent = NO;//底部 tabBar取消透明
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"客户详情";
    
    _tableView.backgroundColor = RGBA(241, 240, 246, 1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self baseCornerRaduisView:self.noteBtn0 radius:self.noteBtn0.height/2 color:BASECOLOR wide:0.5];
    [self baseCornerRaduisView:self.noteBtn1 radius:self.noteBtn1.height/2 color:BASECOLOR wide:0.5];
    [self baseCornerRaduisView:self.noteBtn2 radius:self.noteBtn2.height/2 color:BASECOLOR wide:0.5];
    [self baseCornerRaduisView:self.noteBtn3 radius:self.noteBtn3.height/2 color:BASECOLOR wide:0.5];

    //初始化
    _dataArray = [NSMutableArray array];
    _dataArray =(NSMutableArray *) @[_model.phone,_model.email,_model.address];
//    self.headImageV.image = [self Base64StrToUIImage:_model.headpath];
    self.headImageV.image = [NSString Base64StrToUIImage:_model.headpath];

    self.viewName.text = _model.name;
    self.viewCompany.text = _model.company;
    
        [self addRightBarButtons];
}

- (void)addRightBarButtons
{
    UIButton *rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [leftBarBtn1 setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [rightBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn1 setTitle:@"编辑" forState:UIControlStateNormal];
    [rightBtn1.titleLabel setFont:[UIFont systemFontOfSize:15]];
    rightBtn1.frame=CGRectMake(0, 0, 64, 30);
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
    NSString *textTitle = _dataArray[indexPath.row];
    SFBMHomeViewControllerCell0 *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"SFBMHomeViewControllerCell0"];
    cell.cellTitleL.text = textTitle;
    
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
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYNSLog(@"1111--");
//    SFBMCustomerMessageDetailController *VC = (SFBMCustomerMessageDetailController *)[self getControllerFromStoryboard:@"Main" withControllerID:@"SFBMCustomerMessageDetailController"];
//    VC.idString = @"1888";
//    [self.navigationController pushViewController:VC animated:YES];
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
    if (button.tag==12) {
        //SFBMCouponSelectViewController
        SFBMCreateCustomerViewController *vc = (SFBMCreateCustomerViewController *)[self getControllerFromStoryboard:@"Main" withControllerID:@"SFBMCreateCustomerViewController"];
        vc.model = self.model;
        vc.update = YES;
        [self push2Next:vc animated:YES];
    }
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


