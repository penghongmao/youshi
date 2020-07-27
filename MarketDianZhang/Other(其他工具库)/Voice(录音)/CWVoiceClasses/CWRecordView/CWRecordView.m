//
//  CWRecordView.m
//  QQVoiceDemo
//
//  Created by chavez on 2017/10/11.
//  Copyright © 2017年 陈旺. All rights reserved.
//

#import "CWRecordView.h"
#import "CWAudioPlayView.h"
#import "CWRecordStateView.h"
#import "CWVoiceButton.h"
#import "UIView+CWChat.h"
#import "CWRecorder.h"
#import "CWVoiceView.h"
#import "CWFlieManager.h"
//----------------------录音界面---------------------------------//
@interface CWRecordView ()<CWRecorderDelegate,CWAudioPlayViewDelegate>
@property (nonatomic, weak) CWRecordStateView *stateView;
@property (nonatomic, weak) CWVoiceButton *recordButton;    // 录音按钮
@property (nonatomic, weak) CWAudioPlayView *playView;   // 播放界面
@property (nonatomic, weak) UIButton *hideSuperBtn; // 隐藏录音界面
@property (nonatomic, weak) UIImageView *lineImageV;// 顶部灰色横线

@end


@implementation CWRecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self lineImageV];
    [self stateView];
    [self hideSuperBtn];
    [self recordButton];
}

#pragma mark - subViews
- (CWAudioPlayView *)playView {
    if (_playView == nil) {
        CWAudioPlayView *view = [[CWAudioPlayView alloc] initWithFrame:self.bounds];
        
        [self addSubview:view];
        _playView = view;
        _playView.delegate = self;
    }
    return _playView;
}

- (UIButton *)hideSuperBtn
{
    if (_hideSuperBtn == nil) {
        UIButton *hidenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        hidenBtn.frame = CGRectMake(self.cw_width-40, 0, 40, 40);
        [hidenBtn setImage:[UIImage imageNamed:@"recordCancle"] forState:UIControlStateNormal];
        //        hidenBtn.backgroundColor = [UIColor redColor];
        [hidenBtn addTarget:self action:@selector(hidenMySuperView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:hidenBtn];
        _hideSuperBtn = hidenBtn;
    }
    return _hideSuperBtn;
}

- (CWRecordStateView *)stateView {
    if (_stateView == nil) {
        CWRecordStateView *stateView = [[CWRecordStateView alloc] initWithFrame:CGRectMake(0, 10, self.cw_width, 50)];
        stateView.recordState = CWRecordStateClickRecord;
        [self addSubview:stateView];
        _stateView = stateView;
    }
    return  _stateView;
}
- (UIImageView *)lineImageV
{
    if (_lineImageV == nil) {
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.cw_width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        _lineImageV = line;
    }
    return _lineImageV;
}
- (CWVoiceButton *)recordButton {
    if (_recordButton == nil) {
        CWVoiceButton *btn = [CWVoiceButton buttonWithBackImageNor:@"aio_record_being_button" backImageSelected:@"aio_record_being_button" imageNor:@"aio_record_start_nor" imageSelected:@"aio_record_stop_nor" frame:CGRectMake(0, self.stateView.cw_bottom, 0, 0) isMicPhone:YES];
        // 松开手指 开始录音
        [btn addTarget:self action:@selector(startRecorde:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.cw_centerX = self.cw_width / 2.0;
        [self addSubview:btn];
        _recordButton = btn;
    }
    return _recordButton;
}

- (void)startRecorde:(CWVoiceButton *)btn {
    // 设置状态 隐藏小圆点和三个标签
    [(CWVoiceView *)self.superview.superview setState:CWVoiceStateRecord];
    //隐藏 右上角 X 按钮
    self.hideSuperBtn.hidden = YES;
    btn.selected = !btn.selected;
    if (btn.selected) {
        [CWRecorder shareInstance].delegate = self;
        NSString *filePath = [CWFlieManager filePath];
//        NSString *path = [CWDocumentPath stringByAppendingPathComponent:@"test.wav"];
        //        @"/Users/chavez/Desktop/test.wav"
        NSLog(@"-----开始录音0---------%@",filePath);
        [[CWRecorder shareInstance] beginRecordWithRecordPath:filePath];
    }else {
        
        [[CWRecorder shareInstance] endRecord];
        [self.stateView endRecord];
        self.stateView.recordState = CWRecordStateClickRecord;
        self.playView = nil;
        [self playView];
    }
    
}

- (void)hidenMySuperView:(UIButton *)hideBtn
{
    UIView *supView = hideBtn.superview.superview.superview;
    if (supView) {
        supView.hidden = YES;
    }
    
}

#pragma mark - CWRecorderDelegate
- (void)recorderPrepare {
        NSLog(@"准备中......");
    self.stateView.recordState = CWRecordStatePrepare;
}

- (void)recorderRecording {
    NSLog(@"开始录音......");

    self.stateView.recordState = CWRecordStateRecording;
    // 设置状态view开始录音
    [self.stateView beginRecord];
}

- (void)recorderFailed:(NSString *)failedMessage {
    self.stateView.recordState = CWRecordStateClickRecord;
    NSLog(@"失败：%@",failedMessage);
}
#pragma mark -CWAudioPlayViewDelegate
-(void)playSendVoiceFile:(NSString *)filePath
{
    NSLog(@"filePath1-mao==%@",filePath);
    if (self.delegate && [self.delegate respondsToSelector:@selector(playSendVoiceFile1:)]) {
        [self.delegate playSendVoiceFile1:filePath];
    }
}
-(void)cancleSendVoiceFile:(NSString *)filePath
{
    NSLog(@"filePath1-hong==%@",filePath);
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancleSendVoiceFile1:)]) {
        [self.delegate cancleSendVoiceFile1:filePath];
    }
}
@end
