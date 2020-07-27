//
//  YCCollectionViewController.m
//  YCToolkit
//
//  Created by 蔡亚超 on 2018/7/20.
//  Copyright © 2018年 WellsCai. All rights reserved.
//

#import "YCCollectionViewController.h"
#import "YCPhotoBrowserController.h"
#import "YCPhotoBrowserAnimator.h"
#import "YCCollectionViewCell.h"

#import "SFBMDiaryModel2.h"
#import "MMManage.h"
#import "NSString+isEnptyHP.h"
//#import <UIImageView+WebCache.h>

@interface YCCollectionViewController ()<AnimatorPresentedDelegate>
@property(nonatomic,strong)NSArray      *arr1;
@property(nonatomic,strong)UILabel *emptyLabel;
@end

@implementation YCCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的相册";
    _arr1 = [NSArray array];
    [self selectMyDiaryData];
    [self.view addSubview:self.emptyLabel];
    [self.view bringSubviewToFront:self.emptyLabel];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
//    self.arr1 = @[[UIImage imageNamed:@"timg"],
//                  [UIImage imageNamed:@"timg"],
//                  [UIImage imageNamed:@"timg"],
//                  ];
    
    /*
     self.arr1 = @[@"image0.jpg",@"image1.jpg",@"image2.jpg",@"image3.jpg",@"image4.jpg",@"image2.jpg",@"image3.jpg",@"image4.jpg",@"image5.jpg",@"image6.jpg",@"image7.jpg",@"image8.jpg"

     //                  @"http://a.hiphotos.baidu.com/zhidao/pic/item/7e3e6709c93d70cf0b741421fcdcd100baa12b0b.jpg",
     //                  @"http://g.hiphotos.baidu.com/zhidao/pic/item/8b82b9014a90f6035dd466133112b31bb051ed7a.jpg",
     //                  @"http://h.hiphotos.baidu.com/zhidao/pic/item/86d6277f9e2f0708dff00629e124b899a901f226.jpg",
     ];
     */


    // Register cell classes
    [self.collectionView registerClass:[YCCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
}

#pragma mark--set datasource
- (void)selectMyDiaryData
{
    NSString *note = @"base64image=";
    //查询整张表
    NSArray *diaryArray  = [[MMManage sharedLH] selectFromTableWithTableName:DIARY_TABLE];
    
    NSMutableArray *muArr = [NSMutableArray array];
    for(NSDictionary *dic in diaryArray)
    {
        NSString *content = dic[@"content"];
        NSArray *contentArr = [content componentsSeparatedByString:@"<br />"];
        for (NSString *imageS in contentArr) {
            if ([imageS containsString:note])
            {
                NSArray *imageArr0 = [imageS componentsSeparatedByString:note];
                NSString *imageStr0 = [imageArr0 lastObject];
                UIImage *diaryImage = [NSString Base64StrToUIImage:imageStr0];
                [muArr addObject:diaryImage];
            }
        }

    }
    self.arr1 = [muArr copy];
    [self.collectionView reloadData];
    if (self.arr1.count==0) {
        self.emptyLabel.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arr1.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    [cell.imageView sd_setImageWithURL:self.arr1[indexPath.row] placeholderImage:[UIImage imageNamed:@"timg"]] ;
    cell.imageView.image = self.arr1[indexPath.row];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 30)/3;
    return CGSizeMake(width, width);
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // 1. 创建动画配置类
    YCPhotoBrowserAnimator *browserAnimator = [[YCPhotoBrowserAnimator alloc] initWithPresentedDelegate:self];
    
    // 2. 创建图片控制器类(有两种创建方式，本地图和网络图)
    // ① 网络图片
    // urlReplacing为缩略图url和高清图url的转换:比如传入@{@“small”：@“big”}
    // 即可将传入的url（带small）自动转成高清图url（带big）
//    YCPhotoBrowserController *vc = [YCPhotoBrowserController instanceWithShowImagesURLs:self.arr1 urlReplacing:nil];
    // ② 本地图片（传入UIImage）
    // + (instancetype)instanceWithShowImages:(NSArray<UIImage *> *)showImages{
    
//    NSMutableArray *imageArray0 = [NSMutableArray arrayWithCapacity:0];
//    for (int i=0; i<self.arr1.count; i++) {
//        UIImage *image0 = [UIImage imageNamed:self.arr1[i]];
//        [imageArray0 addObject:image0];
//    }
    YCPhotoBrowserController *vc = [YCPhotoBrowserController instanceWithShowImages:self.arr1];
    
    // 3. 自定义配置图片控制器
    vc.placeholder = [UIImage imageNamed:@"timg"];
    // 设置点击的下标，没设置则从第一张开始
    vc.indexPath = indexPath;
    // 设置动画，没设置则没动画
    vc.browserAnimator = browserAnimator;
    ///还可以设置指示视图位置，类型，长按的回调。。。
    
    // 4.弹出图片控制器
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - <AnimatorPresentedDelegate>
// 动画需要实现该协议，将动画的image传给动画类
- (UIImageView *)imageViewWithIndexPath:(NSIndexPath *)index{
    YCCollectionViewCell *cell = (YCCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:index];
    return cell.imageView;
}

#pragma mark-setter getter
-(UILabel *)emptyLabel
{
    if (_emptyLabel==nil) {
        _emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.height-40)/3, self.view.bounds.size.width, 40)];
//        _emptyLabel.center = self.view.center;
        _emptyLabel.textColor = [UIColor grayColor];
        _emptyLabel.font = [UIFont systemFontOfSize:20];
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.text = @"空空如也，您的日记中没有图片哦~";
        _emptyLabel.hidden = YES;
    }
    return _emptyLabel;
}
@end
