//
//  MyAfnetwork.m
//  Seller
//
//  Created by 毛宏鹏 on 16/8/18.
//  Copyright © 2016年 sfbm. All rights reserved.
//

#import "MyAfnetwork.h"
#import "UIKit+AFNetworking.h"
#import <UIKit/UIKit.h>
#import "Commens.h"
#import "KeychainItemWrapper.h"//钥匙串永久存储手机唯一标识符
#import <sys/utsname.h>//获取手机型号

@implementation MyAfnetwork

+(void)GET:(NSString *)url
    params:(NSDictionary *)params success:(void(^)(NSDictionary * myDic))success
      fail:(void(^)(NSError * error))failure
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //自动设置请求报文格式(AF内部实现默认格式) 这一点很重要
    //    session.requestSerializer = [AFJSONRequestSerializer serializer];
    //    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    //加上这一句即可
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    //防止空值崩溃
//    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
//    [serializer setRemovesKeysWithNullValues:YES];
//    [session setResponseSerializer:serializer];
    
    //手动请求报文格式设置
    /**
     *  POST 发送数据有两种形式：
     1、发送纯文本的内容
     2、发送的 body 部分带有文件（图片，音频或者其他二进制数据）
     
     对应的 Content-Type 有两种：
     1、application/x-www-form-urlencoded
     2、multipart/form-data
     */
//        [session.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [session.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //服务器响应报文格式设置
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    //请求超时30秒
    session.requestSerializer.timeoutInterval = 30;
//    session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];

    MYNSLog(@"url==%@",url);
    MYNSLog(@"params==%@",params);

    [session GET:url parameters:params headers:@{@"":@""} progress:^(NSProgress * _Nonnull downloadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        success(result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)postUrl:(NSString *)url parameters:(id)parameters getChat:(void(^)(NSDictionary * myDic))success failure:(void(^)(NSError * _Nonnull error))failure
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
//    session.responseSerializer = [AFHTTPResponseSerializer serializer];

    //    __weak typeof(self) _weakSelf = self;
    
    [session POST:url parameters:parameters headers:@{@"":@""}  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        NSDictionary *result = [MyAfnetwork responseConfiguration:responseObject];
        NSDictionary *result = (NSDictionary *)responseObject;
        success(result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MYNSLog(@"error==%@",error);
        failure(error);

    }];
}



+(void)postUrl:(NSString *)url baseURL:(NSString *)baseUrl withHUD:(BOOL)isNeedHud message:(NSString *)message parameters:(id)parameters getChat:(void(^)(NSDictionary * myDic))success failure:(void(^)(void))failure
{
    
    __block MBProgressHUD *hud;
    if (isNeedHud) {
        hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
        if (message) {
            hud.label.text = message;
        }
        hud.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    }
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//自动设置请求报文格式(AF内部实现默认格式) 这一点很重要
//    session.requestSerializer = [AFJSONRequestSerializer serializer];
//    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    //防止空值崩溃
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    [session setResponseSerializer:serializer];
    
//手动请求报文格式设置
    /**
     *  POST 发送数据有两种形式：
     1、发送纯文本的内容
     2、发送的 body 部分带有文件（图片，音频或者其他二进制数据）
     
     对应的 Content-Type 有两种：
     1、application/x-www-form-urlencoded
     2、multipart/form-data
     */
//    [session.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [session.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

//服务器响应报文格式设置
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];

    //请求超时30秒
    session.requestSerializer.timeoutInterval = 30;
    session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    NSString *verify = [CacheBox getCacheWithKey:USER_VERITY];
    //user_id  token
    NSString *user_id = [NSString stringWithFormat:@"%@",[CacheBox getCacheWithKey:USER_ID]];
    NSString *token = [CacheBox getCacheWithKey:USER_TOKEN];
    [session.requestSerializer setValue:user_id forHTTPHeaderField:@"user_id"];//user_id 用户ID
    [session.requestSerializer setValue:token forHTTPHeaderField:@"token"];//token验证

    if (![verify isEnptyHP]) {
        //后台服务器需要参数验证 verify  myAppVersion
        [session.requestSerializer setValue:[CacheBox getCacheWithKey:USER_VERITY] forHTTPHeaderField:@"verify"];
        MYNSLog(@"请求头verify=%@",[CacheBox getCacheWithKey:USER_VERITY]);
    }
    NSString *myAppVersion = (NSString *)[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    NSString *client_id = [self getIDFVString];
    NSString *phoneType = [self getIphoneType];
    
    NSDate *senddate = [NSDate date];
    NSString *sbc_correlation_id = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    MYNSLog(@"请求app和设备信息version=%@--client_id=%@--phoneType=%@--时间戳sbc_correlation_id=%@--user_id=%@--token=%@",myAppVersion,client_id,phoneType,sbc_correlation_id,user_id,token);

    [session.requestSerializer setValue:myAppVersion forHTTPHeaderField:@"version"];//app版本号
    [session.requestSerializer setValue:client_id forHTTPHeaderField:@"deviceId"];//设备唯一标识
    [session.requestSerializer setValue:phoneType forHTTPHeaderField:@"deviceVersion"];//设备名字
    [session.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"plateForm"];//平台
    [session.requestSerializer setValue:sbc_correlation_id forHTTPHeaderField:@"sbc_correlation_id"];//当前时间戳


    NSString *myUrl = [NSString stringWithFormat:@"%@%@",baseUrl,url];
    MYNSLog(@"请求参数parameters==%@",parameters);

    MYNSLog(@"请求路径url==%@",myUrl);

    [session POST:myUrl parameters:parameters headers:@{@"":@""}  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        MYNSLog(@"请求返回报文allHeaders==%@",allHeaders);

//        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *result = (NSDictionary *)responseObject;
        MYNSLog(@"请求返回结果myDic=1=%@",result);
        if ([result isKindOfClass:[NSDictionary class]]&&result.count>0) {
            int errcode = [[result objectForKey:@"errCode"] intValue];
            int retcode = [[result objectForKey:@"retCode"] intValue];

            if (errcode==-100||retcode == -100) {    //校验失败，发通知，跳转登录
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationCenterVerifyFaild" object:nil userInfo:nil];
            }else if (errcode==-101||retcode == -101){//需要更新版本
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationCenterNeedToUpdate" object:nil userInfo:nil];
            }
            else{

                success(result);
            }
        }else{//返回值为(null)的时候弹框处理
//            [MostCommonIndicatorShow showTheMostCommonAlertmessage:@"网络环境异常，请稍后再试"];
            failure();
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
//        [MostCommonIndicatorShow showTheMostCommonAlertmessage:@"网络环境异常，请稍后再试"];

        MYNSLog(@"请求失败了error==%@",error);
        failure();
    }];
}
+(void)postAppIdUrl:(NSString *)url baseURL:(NSString *)baseUrl withHUD:(BOOL)isNeedHud message:(NSString *)message parameters:(id)parameters getChat:(void(^)(NSDictionary * myDic))success failure:(void(^)(void))failure
{
    
    __block MBProgressHUD *hud;
    if (isNeedHud) {
        hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
        if (message) {
            hud.label.text = message;
        }
        hud.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    }
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //自动设置请求报文格式(AF内部实现默认格式) 这一点很重要
    //    session.requestSerializer = [AFJSONRequestSerializer serializer];
    //    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    //防止空值崩溃
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    [serializer setRemovesKeysWithNullValues:YES];
    [session setResponseSerializer:serializer];
    
    //手动请求报文格式设置
    /**
     *  POST 发送数据有两种形式：
     1、发送纯文本的内容
     2、发送的 body 部分带有文件（图片，音频或者其他二进制数据）
     
     对应的 Content-Type 有两种：
     1、application/x-www-form-urlencoded
     2、multipart/form-data
     */
    //    [session.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [session.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //服务器响应报文格式设置
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    //请求超时30秒
    session.requestSerializer.timeoutInterval = 30;
    session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
//    NSString *verify = [CacheBox getCacheWithKey:USER_VERITY];
//    //user_id  token
//    NSString *user_id = [NSString stringWithFormat:@"%@",[CacheBox getCacheWithKey:USER_ID]];
//    NSString *token = [CacheBox getCacheWithKey:USER_TOKEN];
//    [session.requestSerializer setValue:user_id forHTTPHeaderField:@"user_id"];//user_id 用户ID
//    [session.requestSerializer setValue:token forHTTPHeaderField:@"token"];//token验证
//
//    if (![verify isEnptyHP]) {
//        //后台服务器需要参数验证 verify  myAppVersion
//        [session.requestSerializer setValue:[CacheBox getCacheWithKey:USER_VERITY] forHTTPHeaderField:@"verify"];
//        MYNSLog(@"请求头verify=%@",[CacheBox getCacheWithKey:USER_VERITY]);
//    }
//    NSString *myAppVersion = (NSString *)[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
//    NSString *client_id = [self getIDFVString];
//    NSString *phoneType = [self getIphoneType];
//
//    NSDate *senddate = [NSDate date];
//    NSString *sbc_correlation_id = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
//    MYNSLog(@"请求app和设备信息version=%@--client_id=%@--phoneType=%@--时间戳sbc_correlation_id=%@--user_id=%@--token=%@",myAppVersion,client_id,phoneType,sbc_correlation_id,user_id,token);
//
//    [session.requestSerializer setValue:myAppVersion forHTTPHeaderField:@"version"];//app版本号
//    [session.requestSerializer setValue:client_id forHTTPHeaderField:@"deviceId"];//设备唯一标识
//    [session.requestSerializer setValue:phoneType forHTTPHeaderField:@"deviceVersion"];//设备名字
//    [session.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"plateForm"];//平台
//    [session.requestSerializer setValue:sbc_correlation_id forHTTPHeaderField:@"sbc_correlation_id"];//当前时间戳
    
    
    NSString *myUrl = [NSString stringWithFormat:@"%@%@",baseUrl,url];
    MYNSLog(@"请求参数parameters==%@",parameters);
    
    MYNSLog(@"请求路径url==%@",myUrl);
    
    [session POST:myUrl parameters:parameters headers:@{@"":@""}  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:YES];
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        MYNSLog(@"请求返回报文allHeaders==%@",allHeaders);
        
        //        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *result = (NSDictionary *)responseObject;
        MYNSLog(@"请求返回结果myDic=1=%@",result);
        if ([result isKindOfClass:[NSDictionary class]]&&result.count>0) {
            int errcode = [[result objectForKey:@"errCode"] intValue];
            int retcode = [[result objectForKey:@"retCode"] intValue];
            
            if (errcode==-100||retcode == -100) {    //校验失败，发通知，跳转登录
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationCenterVerifyFaild" object:nil userInfo:nil];
            }else if (errcode==-101||retcode == -101){//需要更新版本
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationCenterNeedToUpdate" object:nil userInfo:nil];
            }
            else{
                
                success(result);
            }
        }else{//返回值为(null)的时候弹框处理
            //            [MostCommonIndicatorShow showTheMostCommonAlertmessage:@"网络环境异常，请稍后再试"];
            failure();
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        //        [MostCommonIndicatorShow showTheMostCommonAlertmessage:@"网络环境异常，请稍后再试"];
        
        MYNSLog(@"请求失败了error==%@",error);
        failure();
    }];
}
//上传图片
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
                fail:(void(^)(NSError * error))failure
{
    __block MBProgressHUD *hud;
    MYNSLog(@"url=%@",url);
    if (isNeedHud) {
        hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
        if (message) {
            hud.label.text = message;
        }
    }

    MYNSLog(@"参数params==%@",params);
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
//    session.responseSerializer = [AFHTTPResponseSerializer serializer];



    NSString *verify = [CacheBox getCacheWithKey:USER_VERITY];
    if (![verify isEnptyHP]) {
        //后台服务器需要参数验证 verify
        [session.requestSerializer setValue:[CacheBox getCacheWithKey:USER_VERITY] forHTTPHeaderField:@"verify"];
    }

    
    [session POST:url parameters:params headers:@{@"":@""}  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:filedata name:name fileName:filename mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hideAnimated:YES];
        NSDictionary *dic = (NSDictionary *)responseObject;
        success(dic);
        MYNSLog(@"请求返回结果==%@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        failure(error);
        MYNSLog(@"网络请求失败了error==%@",error);

    }];
    
}


+(void)uploadUrl:(NSString *)url baseURL:(NSString *)baseUrl images:(NSArray *)images withHUD:(BOOL)isNeedHud message:(NSString *)message parameters:(id)parameters progress:(void(^)(NSProgress * progress))progress getChat:(void(^)(NSDictionary * myDic))success failure:(void(^)(void))failure{
    __block MBProgressHUD *hud;
    if (isNeedHud) {
        hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
        if (message) {
            hud.label.text = message;
        }
    }
    NSString *paraUrl = @"?";
    for (NSString *key in (NSDictionary *)parameters) {
        //拼接字符串
        NSString *str =[NSString stringWithFormat:@"%@=%@&",key,parameters[key]];
        paraUrl = [paraUrl stringByAppendingString:str];
    }
    paraUrl = [paraUrl substringToIndex:paraUrl.length-1];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [session.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //请求超时60秒
    session.requestSerializer.timeoutInterval = 60;
    session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    NSString *verify = [CacheBox getCacheWithKey:USER_VERITY];
    if (![verify isEnptyHP]) {
        //后台服务器需要参数验证 verify
        [session.requestSerializer setValue:[CacheBox getCacheWithKey:USER_VERITY] forHTTPHeaderField:@"verify"];
    }
    NSString *myUrl = [NSString stringWithFormat:@"%@%@%@",baseUrl,url,paraUrl];
    [session POST:myUrl parameters:params headers:@{@"":@""}  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSDictionary *dic in images) {
            NSString *fileName = dic[@"fileName"];
            NSData *data = dic[@"data"];
            NSString *name = dic[@"name"];
            NSString *mimeType = dic[@"mimeType"];
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //监听进度
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功
        [hud hideAnimated:YES];
        NSDictionary *dic = (NSDictionary *)responseObject;
        success(dic);
        MYNSLog(@"请求返回结果==%@",dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hideAnimated:YES];
        failure();
        MYNSLog(@"网络请求失败了error==%@",error);
    }];
    
    
}

+(NSDictionary *)responseConfiguration:(id)responseObject{
    
    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return dic;
}


//获取手机唯一标识符，app重装不会被重置
+ (NSString *)getIDFVString
{
    NSString *str;
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc]initWithIdentifier:@"UUID" accessGroup:nil];
    NSString *uuidStr = [keychainItem objectForKey:(id)kSecValueData];
    if (uuidStr.length == 0)
    { //代表里面还没有存值
        [keychainItem setObject:@"MY_APP_CREDENTIALS" forKey:(id)kSecAttrService];
        NSString *myUUIDStr = [[[UIDevice currentDevice] identifierForVendor]UUIDString];
        [keychainItem setObject:myUUIDStr forKey:(id)kSecValueData];
        str = myUUIDStr;
    }
    else{
        str = [keychainItem objectForKey:(id)kSecValueData];
    }
    return str;
}

//获取手机型号
+ (NSString *)getIphoneType {
    //    需要导入头文件：#import <sys/utsname.h>
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    return platform;
    
}


@end
