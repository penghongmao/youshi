//
//  AvatarObject.m
//  Seller
//
//  Created by 毛宏鹏 on 16/9/12.
//  Copyright © 2016年 sfbm. All rights reserved.
//
#import "AvatarObject.h"
#import "ImageUtil.h"
#define PICKER_PowerBrowserPhotoLibirayText  @"请在iPhone的“设置->隐私->相机”中允许访问相机"
#import <AVFoundation/AVFoundation.h>
@implementation AvatarObject

+(instancetype)shareImagePicker
{
    static AvatarObject *pickerManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pickerManager = [[self alloc] init];
    });
    return pickerManager;
}

-(void)steupWithView:(UIView *)view {
    
    if (![self cameraPemission]) {
        UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:PICKER_PowerBrowserPhotoLibirayText preferredStyle:UIAlertControllerStyleAlert];
        [aler addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [aler addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                
                [[UIApplication sharedApplication]openURL:url];
            }
        }]];
        
        [[self getCurrentVC] presentViewController:aler animated:true completion:nil];

    }else{
        //跳转到
        UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                        initWithTitle:self.title
                                        delegate:self
                                        cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                        otherButtonTitles: @"我的相册", @"拍照",nil];
        [myActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //从相册选择
            [self LocalPhoto];
            break;
        case 1:
            //拍照
            [self takePhoto];
            break;
        default:
            break;
    }
}
//从相册选择
-(void)LocalPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    if (_pickDelegate && [_pickDelegate respondsToSelector:@selector(presentImagePickerView:)]) {
        [_pickDelegate presentImagePickerView:picker];
    }
    //    [self presentViewController:picker animated:YES completion:nil];
}

//拍照
-(void)takePhoto{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        //        [self presentModalViewController:picker animated:YES];
        //        [self presentViewController:picker animated:YES completion:nil];
        if (_pickDelegate && [_pickDelegate respondsToSelector:@selector(presentImagePickerView:)]) {
            [_pickDelegate presentImagePickerView:picker];
        }
    }else {
        NSLog(@"该设备无摄像头");
    }
}
#pragma Delegate method UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    //当图片不为空时显示图片并保存图片
    if (image != nil) {
        
        UIImage *scaleImage = [ImageUtil imageWithImage:image
                        scaledToSizeWithSameAspectRatio:CGSizeMake(320.0f, 320.0f)
                                        backgroundColor:nil];
        //压缩系数 0.00001很小了
        NSData *orinData = UIImageJPEGRepresentation(scaleImage, 0.00001);

        NSData *imageData = UIImageJPEGRepresentation(scaleImage, 0.00001);
       NSInteger length = [imageData length]/1000;
        NSInteger orinlength = [orinData length]/1000;

        NSLog(@"orinlength==%ld----length==%ld",orinlength,length);

        scaleImage = [UIImage imageWithData:imageData];

        if (_pickDelegate && [_pickDelegate respondsToSelector:@selector(endPickerImageWithImage:)]) {
            [_pickDelegate endPickerImageWithImage:scaleImage];
        }
        
        //把图片转成NSData类型的数据来保存文件
//        NSData *data;
//        //判断图片是不是png格式的文件
//        if (UIImageJPEGRepresentation(image, 0.2)) {
//            //返回为JPEG图像。
//            data = UIImageJPEGRepresentation(image, 6.0);
//        }else {
//            //返回为png图像。
//            data = UIImagePNGRepresentation(image);
//        }
        
        //保存
        //        [[NSFileManager defaultManager] createFileAtPath:self.imageStoragePath contents:data attributes:nil];
//        if (_pickDelegate && [_pickDelegate respondsToSelector:@selector(endPickerImageWithData:)]) {
//            [_pickDelegate endPickerImageWithData:data];
//        }
    }
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark-- 扫一扫 判断是否有相机权限

- (BOOL)cameraPemission
{
    
    BOOL isHavePemission = NO;
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                isHavePemission = YES;
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                break;
            case AVAuthorizationStatusNotDetermined:
                isHavePemission = YES;
                break;
        }
    }
    return isHavePemission;
}

- (UINavigationController *)getCurrentVC{
    
    UINavigationController *result = nil;
    //    UIView *topView = [[[[UIApplication sharedApplication] keyWindow] subviews]lastObject];
        UIWindow *myWindow = [[UIApplication sharedApplication] keyWindow];
    if ([myWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
        
        NSArray *vcArr = [(UITabBarController *)myWindow.rootViewController childViewControllers];
//        NSInteger index = [CYTabBarConfig shared].selectIndex;
        result = [vcArr objectAtIndex:0];
    }
    return result;
    //    [currenVC pushViewController:vc animated:YES];
    
}

@end

