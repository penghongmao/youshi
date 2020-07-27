//
//  MyAfnetwork.h
//  Seller
//
//  Created by 毛宏鹏 on 16/8/18.
//  Copyright © 2016年 sfbm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#define NetOrServiceFailed @"网络或服务器异常"
@interface MyAfnetwork : NSObject

+(void)GET:(NSString *)url
    params:(NSDictionary *)params success:(void(^)(NSDictionary * myDic))success
      fail:(void(^)(NSError * error))failure;
/**
 *  普通post方法请求网络数据
 *
 *  @param url        请求网址路径
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */

+(void)postUrl:(NSString *)url parameters:(id)parameters getChat:(void(^)(NSDictionary * myDic))success failure:(void(^)(NSError * _Nonnull error))failure;
/**
 *  含有baseURL的post方法
 *
 *  @param url        请求网址路径
 *  @param baseUrl    请求网址根路径
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */

+(void)postUrl:(NSString *)url baseURL:(NSString *)baseUrl withHUD:(BOOL)isNeedHud message:(NSString *)message parameters:(id)parameters getChat:(void(^)(NSDictionary * myDic))success failure:(void(^)(void))failure;

+(void)postAppIdUrl:(NSString *)url baseURL:(NSString *)baseUrl withHUD:(BOOL)isNeedHud message:(NSString *)message parameters:(id)parameters getChat:(void(^)(NSDictionary * myDic))success failure:(void(^)(void))failure;
/**
 *  普通路径上传文件
 *
 *  @param url      请求网址路径
 *  @param params   请求参数
 *  @param filedata 文件      data = UIImagePNGRepresentation(image)
 *  @param name     指定参数名 name = @"file" 后台服务端也要用相同的标识符
 *  @param filename 文件名（要有后缀名） fileName = @"image.png"
 *  @param mimeType 文件类型    mimeType = @"image/png"
 *  @param progress 上传进度
 *  @param success  成功回调
 *  @param failure     失败回调
 */

+(void)uploadWithURL:(NSString *)url
             withHUD:(BOOL)isNeedHud
             message:(NSString *)message
              params:(NSDictionary *)params
            fileData:(NSData *)filedata
                name:(NSString *)name
            fileName:(NSString *)filename
            mimeType:(NSString *) mimeType
            progress:(void(^)(NSProgress * progress))progress
             success:(void(^)(NSDictionary * myDic))success
                fail:(void(^)(NSError * error))failure;

/**
 *  含有baseURL的upload方法
 *
 *  @param images        多张图片的数组字典
 字典类型：
 NSString *fileName = dic[@"fileName"];
 NSData *data = dic[@"data"];
 NSString *param = dic[@"param"];
 *  @param url        请求网址路径
 *  @param baseUrl    请求网址根路径
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param progress    上传进度
 *  @param failure    失败回调
 */

+(void)uploadUrl:(NSString *)url baseURL:(NSString *)baseUrl images:(NSArray *)images withHUD:(BOOL)isNeedHud message:(NSString *)message parameters:(id)parameters progress:(void(^)(NSProgress * progress))progress getChat:(void(^)(NSDictionary * myDic))success failure:(void(^)(void))failure;

@end
