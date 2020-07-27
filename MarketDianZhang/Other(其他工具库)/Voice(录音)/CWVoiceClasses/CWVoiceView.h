//
//  CWVoiceView.h
//  QQVoiceDemo
//
//  Created by 陈旺 on 2017/9/2.
//  Copyright © 2017年 陈旺. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CWVoiceViewDelegate <NSObject>
@optional
-(void)playSendVoiceFile2:(NSString *)filePath;
-(void)cancleSendVoiceFile2:(NSString *)filePath;

@end

typedef NS_ENUM(NSInteger,CWVoiceState) {
    CWVoiceStateDefault = 0, // 默认状态
    CWVoiceStateRecord,      // 录音
    CWVoiceStatePlay         // 播放
} ;

@interface CWVoiceView : UIView
@property (nonatomic,weak) id<CWVoiceViewDelegate>delegate;

@property (nonatomic,assign) CWVoiceState state;

@end






