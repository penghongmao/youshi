//
//  SFBMPersonalCenterController.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2017/12/25.
//  Copyright © 2017年 sfbm. All rights reserved.
//

#import "SFBMPersonalCenterController.h"
#import "BaseNavigationController.h"
@interface SFBMPersonalCenterController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArray;

}
@property (weak, nonatomic) IBOutlet UIImageView *headerImageV;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SFBMPersonalCenterController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    self.tabBarController.tabBar.hidden = NO;//显示底部 tabBar
//    self.navigationController.navigationBar.hidden = YES;
    
    NSString *phone = [CacheBox getCacheWithKey:USER_MOBILE];
    self.phoneLabel.text = phone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self baseCornerRaduisView:self.headerImageV radius:self.headerImageV.height/2 color:nil wide:0];

    _tableView.backgroundColor = RGBA(241, 240, 246, 1);
    self.view.backgroundColor = RGBA(241, 240, 246, 1);
    //初始化
    _dataArray = [NSMutableArray array];
    _dataArray =(NSMutableArray *) @[@"我的信息",@"客户分类设置",@"文件夹设置",@"意见反馈",@"设置"];
    
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
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"SFBMPersonalCenterControllerCell"];
    cell.textLabel.text = textTitle;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    SFBMCustomerMessageDetailController *VC = (SFBMCustomerMessageDetailController *)[self getControllerFromStoryboard:@"Main" withControllerID:@"SFBMCustomerMessageDetailController"];
//    VC.idString = @"1888";
//    [self.navigationController pushViewController:VC animated:YES];
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

- (IBAction)loginOutClick:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要退出登录?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [CacheBox LoginOutNow];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SFBMSettingViewControllerPopToRootChangeVCZero" object:nil];
//        [CYTABBARCONTROLLER setSelectedIndex:0];
        self.tabBarController.selectedIndex = 0;
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UIViewController *VC = [sb instantiateViewControllerWithIdentifier:@"SFBMLoginWithoutPasswordController"];
        
        BaseNavigationController *baseNavi = [[BaseNavigationController alloc] initWithRootViewController:VC];
        [self.navigationController presentViewController:baseNavi animated:YES completion:nil];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)testBtnClick:(id)sender{
    [self requestNetworkingTest0];
}

- (void)requestNetworkingTest0
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *user_id = [NSString stringWithFormat:@"%@",[CacheBox getCacheWithKey:USER_ID]];
    NSString *token = [CacheBox getCacheWithKey:USER_TOKEN];
    params[@"user_id"] = user_id;
    params[@"token"] = token;

    __weak typeof(self) __weakSelf = self;
    [MyAfnetwork postUrl:CONTACTSVIEW_URL baseURL:BASE_URL withHUD:NO message:nil parameters:params getChat:^(NSDictionary *myDic) {
        //
        int code = [[myDic objectForKey:@"retCode"] intValue];
        if (code==10000) {
            [__weakSelf showTheMostCommonAlertmessage:[myDic objectForKey:@"retMsg"]];
        }else{
            [__weakSelf showTheMostCommonAlertmessage:[myDic objectForKey:@"retMsg"]];
        }
        
    } failure:^{
        //
        [self showTheMostCommonAlertmessage:@"获取失败，请重试"];
    }];
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
