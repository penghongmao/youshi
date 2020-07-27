//
//  MMRichImageVoiceModel.h
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2018/9/13.
//  Copyright © 2018年 sfbm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface MMRichImageVoiceModel : NSObject
@property (nonatomic, strong) UIImage* image;///<图片
@property (nonatomic, copy) NSString* localImagePath;///<本地存储路径
@property (nonatomic, copy) NSString* localImageVoicePath;///<录音的存储路径

@property (nonatomic, copy) NSString* remoteImageUrlString;///<上传完成之后的远程路径
@property (nonatomic, assign) CGRect imageFrame;///<Frame

// 上传处理
@property (nonatomic, assign) float uploadProgress;
@property (nonatomic, assign) BOOL isFailed;
@property (nonatomic, assign) BOOL isDone;
//@property (nonatomic, weak) id<MMRichImageUploadDelegate> uploadDelegate;///<上传回调

/**
 显示图片的属性文字
 */
- (NSAttributedString*)attrStringWithContainerWidth:(NSInteger)containerWidth;

@end
