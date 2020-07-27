//
//  SFBMHomeViewController.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2017/12/6.
//  Copyright © 2017年 sfbm. All rights reserved.
//

#import "SFBMHomeViewController.h"
#import "SFBMHomeViewControllerCell0.h"
#import "SFBMCustomerMessageDetailController.h"
#import "MMManage.h"
#import "MyContactListModel2.h"
#import "BMChineseSort.h"


@interface SFBMHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArray;
    NSMutableArray *_diaryArray;

    NSArray *_titleArray;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;

@end

@implementation SFBMHomeViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;//显示底部 tabBar
//    self.tabBarController.tabBar.translucent = NO;//底部 tabBar取消透明
    [self addMyData];
    [self selectMyDiaryData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"联系人";

    _tableView.backgroundColor = RGBA(241, 240, 246, 1);
    //初始化
//    _dataArray = [NSMutableArray array];
//    _dataArray =(NSMutableArray *) @[@[@"客户小E"],@[@"a沈万三",@"a沈万三",@"a沈万三",@"a沈万三"],@[@"b沈万三",@"b沈万三",@"b沈万三",@"b沈万三"],@[@"c沈万三",@"c沈万三",@"c沈万三"]];
//    _titleArray = @[@"最新好友",@"A",@"B",@"C"];
    
    [self addRightBarButtons];
}
//废弃代码
- (void)selectMyDiaryData
{
    NSString *note = @"base64image=";
    //查询整张表
    _diaryArray  = [[MMManage sharedLH] selectFromTableWithTableName:DIARY_TABLE];
//    MYNSLog(@"_diaryArray==%@",_diaryArray);
    if (_diaryArray.count>0) {
        NSDictionary *diaryDic = [_diaryArray lastObject];
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
//    NSMutableArray *muArr = [NSMutableArray array];
//    for(NSDictionary *dic in _dataArray)
//    {
//
//        MyContactListModel2 *people = [[MyContactListModel2 alloc] initWithDic:dic];
//        [muArr addObject:people];
//    }
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
- (void)addMyData
{
    //查询整张表
    _dataArray  = [[MMManage sharedLH] selectFromTableWithTableName:CONTACT_TABLE];
    NSMutableArray *muArr = [NSMutableArray array];
    for(NSDictionary *dic in _dataArray)
    {

        MyContactListModel2 *people = [[MyContactListModel2 alloc] initWithDic:dic];
        [muArr addObject:people];
    }
    
    //根据Person对象的 name 属性 按中文 对 Person数组 排序
    self.indexArray = [BMChineseSort IndexWithArray:muArr Key:@"name"];
    self.letterResultArr = [BMChineseSort sortObjectArray:muArr Key:@"name"];
    [self.indexArray insertObject:@"最近好友" atIndex:0];
    
        NSMutableArray *muArr2 = [NSMutableArray array];
        MyContactListModel2 *people = [[MyContactListModel2 alloc] init];
        people.name = @"客户小李";
        people.ID = @"";
    people.company = @"万圣金融有限公司";

        [muArr2 addObject:people];
    [self.letterResultArr insertObject:muArr2 atIndex:0];

    [self.tableView reloadData];
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
    
    UIButton *rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftBarBtn1 setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [rightBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn1 setTitle:@"添加客户" forState:UIControlStateNormal];
    [rightBtn1.titleLabel setFont:[UIFont systemFontOfSize:15]];
    rightBtn1.frame=CGRectMake(0, 0, 80, 30);
    rightBtn1.tag = 11;
    [rightBtn1 addTarget:self action:@selector(rightBarBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn1.layer.cornerRadius = 4;
    rightBtn1.layer.borderColor = [UIColor whiteColor].CGColor;
    rightBtn1.layer.borderWidth = 0.5;
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn1];
    self.navigationItem.rightBarButtonItem = rightItem1;
}
#pragma mark - tableViewDataSource and delegate
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [self.indexArray objectAtIndex:section];
//}
//section行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.indexArray count];
}
//每组section个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.letterResultArr objectAtIndex:section] count];
}
//********右侧带索引字母快速查询*********
//section右侧index数组
//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return self.indexArray;
//}
////点击右侧索引表项时调用 索引与section的对应关系
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
//    return index;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSArray *arr = [_dataArray objectAtIndex:indexPath.section];
//    NSString *textTitle = arr[indexPath.row];
    SFBMHomeViewControllerCell0 *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"SFBMHomeViewControllerCell0"];
//    cell.cellTitleL.text = textTitle;
    
    //获得对应的Person对象<替换为你自己的model对象>
    MyContactListModel2 *p = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.cellTitleL.text = p.name;
    cell.cellDetailL.text = p.company;

    UIImage *headImage;


    if(!p.headpath){
     headImage = [UIImage imageNamed:@"group29"];
    }else{
       headImage = [NSString Base64StrToUIImage:p.headpath];
    }
    cell.cellImageV.image = headImage;
    MYNSLog(@"headImage==%@",headImage);
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 50;
    }else{
        return 0.1;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 23;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    footerView.backgroundColor = [UIColor whiteColor];
    
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerButton setTitle:@"更多..." forState:UIControlStateNormal];
    [footerButton setTitleColor:RGBA(149, 146, 146, 1) forState:UIControlStateNormal];
    [footerButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    footerButton.frame = CGRectMake(10, 0, SCREEN_WIDTH-10, 50);
    footerButton.tag = section+100;
    [footerButton addTarget:self action:@selector(footerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:footerButton];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(footerView.frame)-0.5, SCREEN_WIDTH, 0.5)];
    imageV.backgroundColor = [UIColor lightGrayColor];
    [footerView addSubview:imageV];
    if (section==0) {
        return footerView;
    }else{
        return nil;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 23)];
//    headerView.backgroundColor = [UIColor redColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-12, 23)];
    NSString *title = [self.indexArray objectAtIndex:section];
    headerLabel.text = title;
    headerLabel.textColor = RGBA(150, 150, 150, 1);
    headerLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:headerLabel];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFBMCustomerMessageDetailController *VC = (SFBMCustomerMessageDetailController *)[self getControllerFromStoryboard:@"Main" withControllerID:@"SFBMCustomerMessageDetailController"];
    MyContactListModel2 *p = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    VC.model = p;//假数据
    [self.navigationController pushViewController:VC animated:YES];
}
- (IBAction)topButtonClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 101:
        {//

        }
            break;
        case 102:
        {//  SFBMCouponViewController   SFBMCouponSelectViewController
//            UIViewController *vc = [self getControllerFromStoryboard:@"Personal" withControllerID:@"SFBMCouponViewController"];
//            [self push2Next:vc animated:YES];
            
        }
            break;
        case 103:
        {//
            
        }
            break;
        case 104:
        {//
            
        }
            break;
        default:
            break;
    }
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
-(void)footerButtonClick:(UIButton *)button
{
    if (button.tag==100)
    {
        UIViewController *vc = [self getControllerFromStoryboard:@"Main" withControllerID:@"SFBMAllMyCustomersController"];
        [self push2Next:vc animated:YES];
        
    }
}
- (void)rightBarBtnSelect:(UIButton *)button
{
    if (button.tag==11) {
        //SFBMCouponSelectViewController
        UIViewController *vc = [self getControllerFromStoryboard:@"Main" withControllerID:@"SFBMCreateCustomerViewController"];
        [self push2Next:vc animated:YES];
    }else{
        //SFBMMutableEditingController
        UIViewController *vc = [self getControllerFromStoryboard:@"Main" withControllerID:@"SFBMMutableEditingController"];
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
