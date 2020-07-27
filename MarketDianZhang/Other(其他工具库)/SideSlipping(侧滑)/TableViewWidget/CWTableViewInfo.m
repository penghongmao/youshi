//
//  CWTableViewInfo.m
//  CWLateralSlideDemo
//
//  Created by ChavezChen on 2018/6/8.
//  Copyright © 2018年 chavez. All rights reserved.
//

#import "CWTableViewInfo.h"
#import "CWTableViewCell.h"

@interface CWTableViewInfo ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CWTableViewInfo
{
    UITableView *_tableView;
    NSMutableArray *_cellInfoArray;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super init];
    if (self) {
        [self setupTableViewWithFrame:frame style:style];
        _cellInfoArray = [NSMutableArray array];
    }
    return self;
}

- (void)setupTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    _tableView = [[UITableView alloc] initWithFrame:frame style:style];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    if (@available(iOS 11.0, *)) {//适配iOS 11，防止tableview下移
//        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
}

#pragma mark - Setter方法
- (void)setBackGroudColor:(UIColor *)backGroudColor {
    _backGroudColor = backGroudColor;
    _tableView.backgroundColor = backGroudColor;
}

- (void)setSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle {
    _separatorStyle = separatorStyle;
    _tableView.separatorStyle = separatorStyle;
}

#pragma mark - public Method
- (NSUInteger)getDataArrayCount {
    return _cellInfoArray.count;
}

- (UITableView *)getTableView {
    return _tableView;
}


- (void)addCell:(CWTableViewCellInfo *)cellInfo {
    [_cellInfoArray addObject:cellInfo];
}

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"%zd",_cellInfoArray.count);
    return _cellInfoArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width *0.75, 0.5)];
    footer.backgroundColor = [UIColor lightGrayColor];
    return footer;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    CWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellReusaId"];
    CWTableViewCellInfo *cellInfo = _cellInfoArray[indexPath.row];
    
    if (cell == nil) {
        cell = [[CWTableViewCell alloc] initWithStyle:cellInfo.cellStyle reuseIdentifier:@"CellReusaId"];
    }
    
    cell.cellInfo = cellInfo;
    return cell;
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//清除选中状态
    
    CWTableViewCellInfo *cellInfo = _cellInfoArray[indexPath.row];
    
    id target = cellInfo.actionTarget;
    SEL selector = cellInfo.actionSel;
    
    if (cellInfo.selectionStyle)
    {
        if ([target respondsToSelector:selector])
        {
            IMP imp = [target methodForSelector:selector];
            void (*func)(id, SEL, CWTableViewCellInfo *, NSIndexPath *) = (void *)imp;
            func(target, selector, cellInfo, indexPath);
        }
    }
    
}


@end
