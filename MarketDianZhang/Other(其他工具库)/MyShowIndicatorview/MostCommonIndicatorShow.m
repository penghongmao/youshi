//
//  MostCommonIndicatorShow.m
//  My_App
//
//  Created by 毛宏鹏 on 16/11/11.
//  Copyright © 2016年 毛宏鹏. All rights reserved.
//

#import "MostCommonIndicatorShow.h"
@implementation MostCommonIndicatorShow
+(void)showTheMostCommonAlertmessage:(NSString *)message
{
    [self showMessageText:message withLoadMode:MBProgressHUDModeText duration:1.5];
    
    
}
+(void)showMessageText:(NSString *)text withLoadMode:(MBProgressHUDMode)mode duration:(NSTimeInterval)second
{
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    //[[[UIApplication sharedApplication] delegate] window]
    if (mode) {
        hud.mode = mode;
    }
    if (text) {
        hud.label.text = text;
    }
    [hud hideAnimated:YES afterDelay:second];
}
@end
