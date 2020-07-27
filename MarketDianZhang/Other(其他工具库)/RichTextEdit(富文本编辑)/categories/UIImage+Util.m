//
//  UIImage+Util.m
//  MobileExperience
//
//  Created by fuyongle on 14-5-28.
//  Copyright (c) 2014年 NetDragon. All rights reserved.
//

#import "UIImage+Util.h"
#import <objc/runtime.h>
#import <WebKit/WebKit.h>
//#import <UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"
@implementation UIImage (Util)

- (UIImage *)scaletoWize:(float)imageWide {
    if (self.size.width < imageWide) {
        return self;
    }
    CGFloat imageHeight = self.size.height * 1.0 /self.size.width * imageWide;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWide, imageHeight), NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, imageWide, imageHeight)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
