//
//  WPFSearchResultViewController.m
//  HighLightedSearchDemol
//
//  Created by 毛宏鹏 on 2018/1/18.
//  Copyright © 2018年 sfbm. All rights reserved.
//

#import "WPFSearchResultViewController.h"
#import "WPFPerson.h"
#import "WPFPeopleCell.h"
#import "SFBMCustomerMessageDetailController.h"
#import "MMManage.h"
@interface WPFSearchResultViewController ()

@end

static NSString *kResultCellIdentifier = @"kResultCellIdentifier";

@implementation WPFSearchResultViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
//        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kResultCellIdentifier];
        [self.tableView registerNib:[UINib nibWithNibName:@"WPFPeopleCell" bundle:nil] forCellReuseIdentifier:@"WPFPeopleCell"];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 解决 UITableViewWrapperView下移64pt问题
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultDataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kResultCellIdentifier];
    WPFPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WPFPeopleCell" forIndexPath:indexPath];

    WPFPerson *people = self.resultDataSource[indexPath.row];
    // 设置关键字高亮
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:people.name];
    UIColor *highlightedColor = [UIColor colorWithRed:0 green:131/255.0 blue:0 alpha:1.0];
    [attributedString addAttribute:NSForegroundColorAttributeName value:highlightedColor range:people.textRange];
//    cell.textLabel.attributedText = attributedString;
    cell.cellTitleL.attributedText = attributedString;
    cell.cellDetailL.text = people.company;
    cell.cellImageV.image = [UIImage imageWithData:people.headpath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"dianjile di--%zd行--",indexPath.row);
    WPFPerson *person = self.resultDataSource[indexPath.row];
    NSLog(@"--%@--",person.personId);
    NSArray *arr = [[MMManage sharedLH] selectFromTableWithFileValue:person.personId fileKey:@"id" withTableName:CONTACT_TABLE];
    NSDictionary *dic = [arr firstObject];
    MyContactListModel2 *p = [[MyContactListModel2 alloc] initWithDic:dic];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFBMCustomerMessageDetailController *VC = (SFBMCustomerMessageDetailController *)[self getControllerFromStoryboard:@"Main" withControllerID:@"SFBMCustomerMessageDetailController"];
    VC.model = p;//
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - Setters && Getters
- (NSMutableArray *)resultDataSource {
    if (!_resultDataSource) {
        _resultDataSource = [NSMutableArray array];
    }
    return _resultDataSource;
}

@end

