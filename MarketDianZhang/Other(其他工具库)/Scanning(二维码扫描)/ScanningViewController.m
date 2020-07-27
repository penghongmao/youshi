//
//  ScanningViewController.m
//  Battery
//
//  Created by 毛宏鹏 on 17/4/22.
//  Copyright © 2017年 SFBM. All rights reserved.
//

#import "ScanningViewController.h"


#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <ExternalAccessory/ExternalAccessory.h>
//跳转页面
//#import "SFBMmanulInputNumberController.h"
#define ZUOCHONGBIAOZHI  @"bd"//判断是否是座充，如果是座充不需要交押金
#define BLE_NAME_HEADER  @"SBC"//蓝牙名字头
#define BARRERYBIAOZHI @"shelf"//充电宝的标志

#define Height [UIScreen mainScreen].bounds.size.height
#define Width [UIScreen mainScreen].bounds.size.width
#define XCenter Width/2
#define YCenter Height/2

#define SHeight 20

#define SWidth (Width-100)
#define OFFSET_VIEW 64

#define PICKER_PowerBrowserPhotoLibirayText  @"您屏蔽了选择相册的权限，开启请去系统设置->隐私->相机来打开权限"

@interface ScanningViewController ()
{
    UIImageView * imageView;
    BOOL openBool;
    UIButton *changeBtn;
    UIButton *changeRightBtn;
    NSString*pushDeblock;
    NSString *chongNum;
    UILabel * labIntroudction;
    UILabel * titleLeft;
    UILabel * titleRight;
    
}


@end

@implementation ScanningViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (_session) {
        [_session startRunning];
    }
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    }
    
    if(self.scanningType == 2){
        self.title =@"扫码结束使用";
    }else{
        self.title =@"扫码使用";
    }
    


}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [_session stopRunning];
    [timer invalidate];
    timer = nil;
    
}
//获取当前屏幕
-(void)leftBackBtnClick{
    [super leftBackBtnClick];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    openBool = YES;
    pushDeblock = @"";
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [self addBaseBackBarButtonItem];
    [self addRightBarButtonItem];

    [self addOtherSubviews];
    
    [self setupCamera];

}
- (void)addOtherSubviews
{
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake((Width-SWidth)/2,(Height-SWidth)/2 -100,SWidth,SWidth)];
    imageView.image = [UIImage imageNamed:@"scanningbg.png"];
    [self.view addSubview:imageView];
    MYNSLog(@"1==%f",XCenter);
    
    MYNSLog(@"imageViewframe=1=%@",NSStringFromCGRect(imageView.frame));
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame)+5, CGRectGetMinY(imageView.frame)+5, SWidth-10,1)];
    _line.image = [UIImage imageNamed:@"scanLine1"];
    [self.view addSubview:_line];
    
    labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(60,CGRectGetMaxY(imageView.frame), Width-120, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=BASECOLOR;
    labIntroudction.text=@"请对准充电桩上的二维码";
    labIntroudction.font = [UIFont systemFontOfSize:15];
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labIntroudction];

    changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(110-25, Height-100-OFFSET_VIEW-45, 50, 50);
    [changeBtn setImage:[UIImage imageNamed:@"scanning_hand10"] forState:UIControlStateNormal];
//    [changeBtn setBackgroundColor:BASECOLOR];
    [changeBtn addTarget:self action:@selector(goManulInputVC) forControlEvents:UIControlEventTouchUpInside];
    [self baseCornerRaduisView:changeBtn radius:0 color:nil wide:0];
    [self.view addSubview:changeBtn];

    changeRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeRightBtn.frame = CGRectMake(SCREEN_WIDTH - 110-25, Height-100-OFFSET_VIEW-45, 50, 50);
    [changeRightBtn setImage:[UIImage imageNamed:@"scanning_flashlight11"] forState:UIControlStateNormal];
    [changeRightBtn setImage:[UIImage imageNamed:@"scanning_flashlight11"] forState:UIControlStateSelected];

    [changeRightBtn addTarget:self action:@selector(openTheDoor) forControlEvents:UIControlEventTouchUpInside];
    [self baseCornerRaduisView:changeRightBtn radius:0 color:nil wide:0];
    [self.view addSubview:changeRightBtn];
    
    titleLeft= [[UILabel alloc] initWithFrame:CGRectMake(55, Height-50-OFFSET_VIEW-45, 110, 50)];
    titleLeft.backgroundColor = [UIColor clearColor];
    titleLeft.numberOfLines=2;
    titleLeft.textColor=[UIColor whiteColor];
    titleLeft.text=@"手动输入编号";
    titleLeft.font = [UIFont systemFontOfSize:15];
    titleLeft.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLeft];

    titleRight= [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 110-55, Height-50-OFFSET_VIEW-45, 110, 50)];
    titleRight.backgroundColor = [UIColor clearColor];
    titleRight.numberOfLines=2;
    titleRight.textColor=[UIColor whiteColor];
    titleRight.text=@"手电筒";
    titleLeft.font = [UIFont systemFontOfSize:15];
    titleRight.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleRight];

    timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
}

- (void)addRightBarButtonItem
{
    UIButton *leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBarBtn setImage:[UIImage imageNamed:@"btnHelp"] forState:UIControlStateNormal];
    [leftBarBtn setImage:[UIImage imageNamed:@"btnHelp"] forState:UIControlStateSelected];

    [leftBarBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [leftBarBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [leftBarBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    leftBarBtn.frame = CGRectMake(0, 0, 25, 25);
    leftBarBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -11);

    leftBarBtn.tag = 101;
    [leftBarBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.rightBarButtonItem = leftItem;

}

- (void)rightBtnClick
{


}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(CGRectGetMinX(imageView.frame)+5, CGRectGetMinY(imageView.frame)+5+2*num, SWidth-10,1);
        
        if (num ==(int)(( SWidth-10)/2)) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame =CGRectMake(CGRectGetMinX(imageView.frame)+5, CGRectGetMinY(imageView.frame)+5+2*num, SWidth-10,1);
        
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    _output.rectOfInterest =[self rectOfInterestByScanViewRect:imageView.frame];//CGRectMake(0.1, 0, 0.9, 1);//
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode];
    
    
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResize;
    _preview.frame =self.view.bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    [self.view bringSubviewToFront:imageView];
    

    [self setOverView];
    
    [self.view bringSubviewToFront:labIntroudction];
    [self.view bringSubviewToFront:titleLeft];
    [self.view bringSubviewToFront:titleRight];

    [self.view bringSubviewToFront:changeBtn];
    [self.view bringSubviewToFront:changeRightBtn];

    // 先停止扫码，等接口调用成功以后再允许扫码
    [_session stopRunning];
//    [self getBacklightLevel];

}
#pragma mark--扫描结果
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        /**
         *  获取扫描结果
         */
        stringValue = metadataObject.stringValue;
        [_session stopRunning];

    }
    MYNSLog(@"stringValue==%@",stringValue);
//    if ([stringValue rangeOfString:@"http"].location !=NSNotFound) {
    //强烈要求把http的拦截去掉，为了保持安卓和ios扫码拦截逻辑一致，故作此修改
        chongNum = [[stringValue componentsSeparatedByString:@"="] lastObject];
        
        if ([stringValue rangeOfString:ZUOCHONGBIAOZHI].location !=NSNotFound) {
            [_session stopRunning];

        }else if([stringValue rangeOfString:BARRERYBIAOZHI].location != NSNotFound){

        }else{//无效的二维码
            [self showTheMostCommonAlertmessage:@"无效的二维码，请重新扫描"];
            [_session startRunning];
        }
    
    
}

- (CGRect)rectOfInterestByScanViewRect:(CGRect)rect {
    CGFloat width = Width;
    CGFloat height = Height;

    CGFloat x = CGRectGetMinY(rect) / height;
    CGFloat y = CGRectGetMinX(rect) / width;

    
    CGFloat w = CGRectGetHeight(rect) / height;
    CGFloat h = CGRectGetWidth(rect) / width;
    
    return CGRectMake(x, y, w, h);
}

#pragma mark - 添加模糊效果
- (void)setOverView {
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    
    CGFloat x = CGRectGetMinX(imageView.frame);
    CGFloat y = CGRectGetMinY(imageView.frame);
    CGFloat w = CGRectGetWidth(imageView.frame);
    CGFloat h = CGRectGetHeight(imageView.frame);
    
    [self creatView:CGRectMake(0, 0, width, y)];
    [self creatView:CGRectMake(0, y, x, h)];
    [self creatView:CGRectMake(0, y + h, width, height - y - h)];
    [self creatView:CGRectMake(x + w, y, width - x - w, h)];
}

- (void)creatView:(CGRect)rect {
    CGFloat alpha = 0.6;
    UIColor *backColor = [UIColor blackColor];
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backColor;
    view.alpha = alpha;
    [self.view addSubview:view];
}

//打开和关闭手电筒
- (void)openTheDoor{
    openBool = !openBool;
    
    if (openBool==NO) {
        if ([_device hasTorch]) {
            [_device lockForConfiguration:nil];
            [_device setTorchMode: AVCaptureTorchModeOn];
            [_device unlockForConfiguration];
        }
    }else{
        if ([_device hasTorch]) {
            [_device lockForConfiguration:nil];
            [_device setTorchMode: AVCaptureTorchModeOff];
            [_device unlockForConfiguration];
            
        }
        
    }
}
//手动输入页面
- (void)goManulInputVC
{
//    SFBMmanulInputNumberController *vc = [[SFBMmanulInputNumberController alloc] init];
//
//    vc.userinfoModel = self.userInfoModel;
//    vc.scanningType = self.scanningType;
//    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark request

- (void)dealloc{
    MYNSLog(@"扫码页面释放");
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will 9often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

