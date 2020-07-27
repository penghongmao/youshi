//
//  SFBMMyFoldersController.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2018/8/2.
//  Copyright © 2018年 sfbm. All rights reserved.
//

#import "SFBMMyFoldersController.h"
#import "MMManage.h"
#import "SFBMOneTypeThingsController.h"
@interface SFBMMyFoldersController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_titleArray;
    NSArray *_imageArray;
    NSMutableArray *_diaryArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//
@end

@implementation SFBMMyFoldersController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self selectMyDairy];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"文件夹";
    // Do any additional setup after loading the view.
    _titleArray = @[@"文件夹1",@"文件夹2",@"文件夹3",@"文件夹4",@"文件夹5",@"文件夹6"];
    _imageArray = @[@"folder38-1",@"folder38-2",@"folder38-3",@"folder38-4",@"folder38-5",@"folder38-6"];
    
}
- (void)selectMyDairy
{
    _diaryArray = [NSMutableArray arrayWithCapacity:0];

    for (int i=1; i<7; i++) {
        NSString *key = [NSString stringWithFormat:@"%d",i];
        NSArray *arr = [[MMManage sharedLH] selectFromTableWithFileValue:key fileKey:@"color" withTableName:DIARY_TABLE];
        [_diaryArray addObject:arr];
    }
    MYNSLog(@"_diaryArray==%ld",_diaryArray.count);
    [self.tableView reloadData];
}
#pragma mark - tableViewDataSource and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SFBMMyFoldersControllercell"];
    
    NSArray *detailArr = [_diaryArray objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",detailArr.count];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (detailArr.count==0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.userInteractionEnabled = NO;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0.5)];
    footer.backgroundColor = [UIColor lightGrayColor];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell* )cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYNSLog(@"%ld",indexPath.row);
    SFBMOneTypeThingsController *VC = (SFBMOneTypeThingsController *)[self getControllerFromStoryboard:@"Things" withControllerID:@"SFBMOneTypeThingsController"];
    VC.oneTypeDiary = [_diaryArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:VC animated:YES];
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
