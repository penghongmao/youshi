//
//  XLChannelView.m
//  XLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "XLChannelView.h"
#import "XLChannelItem.h"
#import "XLChannelHeader.h"
#import "SFBMDiaryModel2.h"
#import "MMManage.h"
#import "MostCommonIndicatorShow.h"
#import "SFBMAllThingsController.h"
#import "SFBMMutableEditingMessageDetailController.h"
//菜单列数
static NSInteger ColumnNumber = 2;
//横向和纵向的间距
static CGFloat CellMarginX = 15.0f;
static CGFloat CellMarginY = 10.0f;


@interface XLChannelView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    //被拖拽的item
    XLChannelItem *_dragingItem;
    //正在拖拽的indexpath
    NSIndexPath *_dragingIndexPath;
    //目标位置
    NSIndexPath *_targetIndexPath;
    NSMutableArray *_diaryColorArray;
}

@end

@implementation XLChannelView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

-(void)buildUI{
    _diaryColorArray = [NSMutableArray arrayWithObjects:DIARYCOLOR1,DIARYCOLOR2,DIARYCOLOR3,DIARYCOLOR4,DIARYCOLOR5,DIARYCOLOR6, nil];

    self.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat cellWidth = (self.bounds.size.width - (ColumnNumber + 1) * CellMarginX)/ColumnNumber;
    flowLayout.itemSize = CGSizeMake(cellWidth,cellWidth/2.0f);
    flowLayout.sectionInset = UIEdgeInsetsMake(CellMarginY, CellMarginX, CellMarginY, CellMarginX);
    flowLayout.minimumLineSpacing = CellMarginY;
    flowLayout.minimumInteritemSpacing = CellMarginX;
    flowLayout.headerReferenceSize = CGSizeMake(self.bounds.size.width, 40);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = false;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[XLChannelItem class] forCellWithReuseIdentifier:@"XLChannelItem"];
    [_collectionView registerClass:[XLChannelHeader class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XLChannelHeader"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self addSubview:_collectionView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
    longPress.minimumPressDuration = 0.2f;
    [_collectionView addGestureRecognizer:longPress];
    
    _dragingItem = [[XLChannelItem alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellWidth/2.0f)];
    _dragingItem.hidden = true;
    [_collectionView addSubview:_dragingItem];
}

#pragma mark -
#pragma mark LongPressMethod
-(void)longPressMethod:(UILongPressGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:_collectionView];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self dragBegin:point];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragChanged:point];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragEnd];
            break;
        default:
            break;
    }
}

//拖拽开始 找到被拖拽的item
-(void)dragBegin:(CGPoint)point{
    _dragingIndexPath = [self getDragingIndexPathWithPoint:point];
    if (!_dragingIndexPath) {return;}
    [_collectionView bringSubviewToFront:_dragingItem];
    XLChannelItem *item = (XLChannelItem*)[_collectionView cellForItemAtIndexPath:_dragingIndexPath];
    item.isMoving = true;
    //更新被拖拽的item
    _dragingItem.hidden = false;
    _dragingItem.frame = item.frame;
    _dragingItem.title = item.title;
    [_dragingItem setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
}

//正在被拖拽、、、
-(void)dragChanged:(CGPoint)point{
    if (!_dragingIndexPath) {return;}
    _dragingItem.center = point;
    _targetIndexPath = [self getTargetIndexPathWithPoint:point];
    //交换位置 如果没有找到_targetIndexPath则不交换位置
    if (_dragingIndexPath && _targetIndexPath) {
        //更新数据源
        [self rearrangeInUseTitles];
        //更新item位置
        [_collectionView moveItemAtIndexPath:_dragingIndexPath toIndexPath:_targetIndexPath];
        _dragingIndexPath = _targetIndexPath;
    }
}

//拖拽结束
-(void)dragEnd{
    if (!_dragingIndexPath) {return;}
    CGRect endFrame = [_collectionView cellForItemAtIndexPath:_dragingIndexPath].frame;
    [_dragingItem setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    [UIView animateWithDuration:0.3 animations:^{
        _dragingItem.frame = endFrame;
    }completion:^(BOOL finished) {
        _dragingItem.hidden = true;
        XLChannelItem *item = (XLChannelItem*)[_collectionView cellForItemAtIndexPath:_dragingIndexPath];
        item.isMoving = false;
    }];
}

#pragma mark -
#pragma mark 辅助方法

//获取被拖动IndexPath的方法
-(NSIndexPath*)getDragingIndexPathWithPoint:(CGPoint)point{
    NSIndexPath* dragIndexPath = nil;
    //最后剩一个怎不可以排序
    if ([_collectionView numberOfItemsInSection:0] == 1) {return dragIndexPath;}
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        //下半部分不需要排序
        if (indexPath.section > 0) {continue;}
        //在上半部分中找出相对应的Item
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
//            if (indexPath.row != 0) {
//                dragIndexPath = indexPath;
//            }
            dragIndexPath = indexPath;

            break;
        }
    }
    return dragIndexPath;
}

//获取目标IndexPath的方法
-(NSIndexPath*)getTargetIndexPathWithPoint:(CGPoint)point{
    NSIndexPath *targetIndexPath = nil;
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        //如果是自己不需要排序
        if ([indexPath isEqual:_dragingIndexPath]) {continue;}
        //第二组不需要排序
        if (indexPath.section > 0) {continue;}
        //在第一组中找出将被替换位置的Item
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            if (indexPath.row != 0) {
                targetIndexPath = indexPath;
            }
        }
    }
    return targetIndexPath;
}

#pragma mark -
#pragma mark CollectionViewDelegate&DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return section == 0 ? _inUseTitles.count : _unUseTitles.count;
    return _inUseTitles.count;

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//    return 2;
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    XLChannelHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XLChannelHeader" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        headerView.title = @"已置顶";
        headerView.subTitle = @"按住拖动调整排序";
    }else{
//        headerView.title = @"其它";
//        headerView.subTitle = @"点击可置顶";
    }
    return headerView;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"XLChannelItem";
    XLChannelItem* item = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
//    item.title = indexPath.section == 0 ? _inUseTitles[indexPath.row] : _unUseTitles[indexPath.row];
    SFBMDiaryModel2 *diary = _inUseTitles[indexPath.row];
    NSString *title = diary.title;
    item.title = title;
    NSInteger colorNum = [diary.color integerValue];
    item.contentView.backgroundColor = _diaryColorArray[colorNum-1];
//    item.isFixed = indexPath.section == 0 && indexPath.row == 0;//已废弃，第一个不需要特殊处理啦
    [item.deleteBtn addTarget:self action:@selector(btnAction:event:) forControlEvents:UIControlEventTouchUpInside];
    return  item;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
////        //只剩一个的时候不可删除
////        if ([_collectionView numberOfItemsInSection:0] == 1)
////        {
////            return;
////        }
////        //第一个不可删除
////        if (indexPath.row  == 0) {return;}
//        id obj = [_inUseTitles objectAtIndex:indexPath.row];
//        [_inUseTitles removeObject:obj];
//        [_unUseTitles insertObject:obj atIndex:0];
//        [_collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//    }else{
//        id obj = [_unUseTitles objectAtIndex:indexPath.row];
//        [_unUseTitles removeObject:obj];
//        [_inUseTitles addObject:obj];
//        [_collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:_inUseTitles.count - 1 inSection:0]];
//    }
    
    //SFBMMutableEditingMessageDetailController
    SFBMDiaryModel2 *diary = _inUseTitles[indexPath.row];

    SFBMAllThingsController *currentVC = (SFBMAllThingsController *)[self myViewController];
    SFBMMutableEditingMessageDetailController *vc = (SFBMMutableEditingMessageDetailController *)[currentVC getControllerFromStoryboard:@"Main" withControllerID:@"SFBMMutableEditingMessageDetailController"];
    vc.mode = diary;
    [currentVC push2Next:vc animated:YES];
}

#pragma mark--Action
- (void)btnAction:(id)sender event:(id)event{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInView:_collectionView];
    
    NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:position];
//    NSLog(@"indexPath==%ld--%ld",indexPath.section,indexPath.row);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"要删除这个事件吗？"] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        //执行操作
        if (indexPath.section == 0) {
            SFBMDiaryModel2 *diary = _inUseTitles[indexPath.row];
          BOOL success = [[MMManage sharedLH] deleteContentMessageWithID:diary.ID withTableName:DIARY_TABLE];
            if (success==YES) {
                id obj = [_inUseTitles objectAtIndex:indexPath.row];
                [_inUseTitles removeObject:obj];
                [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
            }else{
                [MostCommonIndicatorShow showTheMostCommonAlertmessage:@"操作失败，请稍后再试"];
            }

        }else{
            id obj = [_unUseTitles objectAtIndex:indexPath.row];
            [_unUseTitles removeObject:obj];
            [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        }
    }]];
    
    UIViewController *myVC = [self myViewController];
    [myVC presentViewController:alert animated:YES completion:nil];

}

#pragma mark--获取当前视图所在控制器
- (UIViewController*)myViewController {
    //    for (UIView *next = [self superview]; next; next =
    //next.superview)
    for (UIView *next = [self superview]; next; next =
         next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController
                                          class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
    
}
#pragma mark -
#pragma mark 刷新方法
//拖拽排序后需要重新排序数据源
-(void)rearrangeInUseTitles
{
    id obj = [_inUseTitles objectAtIndex:_dragingIndexPath.row];
    [_inUseTitles removeObject:obj];
    [_inUseTitles insertObject:obj atIndex:_targetIndexPath.row];
}

-(void)reloadData
{
    [_collectionView reloadData];
}

@end
