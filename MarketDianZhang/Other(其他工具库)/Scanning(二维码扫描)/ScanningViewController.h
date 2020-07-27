//
//  ScanningViewController.h
//  Battery
//
//  Created by 毛宏鹏 on 17/4/22.
//  Copyright © 2017年 SFBM. All rights reserved.
//

#import "BaseViewController.h"

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ScanningViewController : BaseViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain)UIImageView * line;

@property (nonatomic, assign)int scanningType;//扫码类型: 1扫码解锁，2扫码归还

@end

