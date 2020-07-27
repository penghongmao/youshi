//
//  AvatarObject.h
//  Seller
//
//  Created by 毛宏鹏 on 16/9/12.
//  Copyright © 2016年 sfbm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol ImagePickerDelegate <NSObject>

@required
/**
 *  pickerView 需要显示的UIImagePickerController控制器
 */
-(void)presentImagePickerView:(UIImagePickerController *)pickerView;
/**
 *  imageData 图片数据
 *  ext     图片格式：png、jpg
 */
@optional
-(void)endPickerImageWithData:(NSData *)imageData;
-(void)endPickerImageWithImage:(UIImage *)image;

@end

@interface AvatarObject : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, weak) id<ImagePickerDelegate> pickDelegate;
@property (nonatomic, copy) NSString *title;

+(instancetype)shareImagePicker;
-(void)steupWithView:(UIView *)view;
@end
