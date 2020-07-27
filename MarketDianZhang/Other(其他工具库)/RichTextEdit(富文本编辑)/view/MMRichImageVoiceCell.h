//
//  MMRichImageVoiceCell.h
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2018/9/13.
//  Copyright © 2018年 sfbm. All rights reserved.
//

#import "MMBaseRichContentCell.h"
#import <UIKit/UIKit.h>
#import "SFBMMutableEditingController.h"

@interface MMRichImageVoiceCell : MMBaseRichContentCell
@property (nonatomic, weak) id<RichTextEditDelegate> delegate;

- (void)updateWithData:(id)data;
- (void)beginEditing;

- (void)getPreFlag:(BOOL*)isPre postFlag:(BOOL*)isPost;

@end
