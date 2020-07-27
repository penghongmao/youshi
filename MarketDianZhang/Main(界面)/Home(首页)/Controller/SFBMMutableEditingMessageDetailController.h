//
//  SFBMMutableEditingMessageDetailController.h
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2018/7/20.
//  Copyright © 2018年 sfbm. All rights reserved.
//

#import "BaseViewController.h"
#import "MMRichEditAccessoryView.h"
#import "SFBMDiaryModel2.h"
@protocol RichTextEditDetailDelegate <NSObject>

// 下面的属性相当远Delegate的属性，暂时放在类的属性中处理，把当前类作为弱引用提供给Cell
- (MMRichEditAccessoryView *)mm_inputAccessoryView;
- (MMRichEditAccessoryView *)mm_removeAccessoryView;

- (void)mm_preInsertTextLineAtIndexPath:(NSIndexPath*)actionIndexPath textContent:(NSString*)textContent;
- (void)mm_postInsertTextLineAtIndexPath:(NSIndexPath*)actionIndexPath textContent:(NSString*)textContent;
- (void)mm_preDeleteItemAtIndexPath:(NSIndexPath*)actionIndexPath;
- (void)mm_PostDeleteItemAtIndexPath:(NSIndexPath*)actionIndexPath;
- (void)mm_updateActiveIndexPath:(NSIndexPath*)activeIndexPath;
- (void)mm_reloadItemAtIndexPath:(NSIndexPath*)actionIndexPath;
- (NSIndexPath*)appendExtraData;

@end

@interface SFBMMutableEditingMessageDetailController : BaseViewController

@property(nonatomic,strong) SFBMDiaryModel2 *mode;

@end
