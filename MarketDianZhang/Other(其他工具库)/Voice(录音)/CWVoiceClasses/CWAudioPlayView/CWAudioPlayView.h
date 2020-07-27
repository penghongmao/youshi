//
//  CWAudioPlayView.h
//  QQVoiceDemo
//
//  Created by 陈旺 on 2017/10/4.
//  Copyright © 2017年 陈旺. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol CWAudioPlayViewDelegate <NSObject>
@optional
-(void)playSendVoiceFile:(NSString *)filePath;
-(void)cancleSendVoiceFile:(NSString *)filePath;

@end
@interface CWAudioPlayView : UIView
@property (nonatomic,assign) CGFloat progressValue;
@property (nonatomic,weak) id<CWAudioPlayViewDelegate>delegate;
@end
