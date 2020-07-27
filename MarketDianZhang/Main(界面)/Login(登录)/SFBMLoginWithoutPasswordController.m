//
//  SFBMLoginWithoutPasswordController.m
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2018/1/5.
//  Copyright © 2018年 sfbm. All rights reserved.
//

#import "SFBMLoginWithoutPasswordController.h"
#define TimeOutInterval 60
#import "SFBMLoginWithoutPasswordController.h"
#import "NSString+PFzhengZeBiaoDa.h"

#import "BaseNavigationController.h"
#import "SFBMWebController.h"
//#import "WXApi.h"
typedef NS_ENUM(NSInteger,SFBMLoginType){//登录类型
    SFBMLoginTypeMobile = 0, //手机登录
    SFBMLoginTypeWeiXin,//微信
    //    SFBMBatteryStateUseEnd //使用结束
};
@interface SFBMLoginWithoutPasswordController  ()<UITextFieldDelegate>
{
    int _seconds;
}
@property (weak, nonatomic) IBOutlet UIView *varifyBgV;
@property (weak, nonatomic) IBOutlet UIView *phoneNumberBgV;
@property (weak, nonatomic) IBOutlet UITextField *userPhoneNumberT;  //电话
@property (weak, nonatomic) IBOutlet UITextField *varifyCodeT; //验证码
@property (weak, nonatomic) IBOutlet UIButton *getVarifyCodeButton; //获取验证码
@property (weak, nonatomic) IBOutlet UIButton *loginButton; //登录
@property (nonatomic, strong) NSTimer *timer; //定时器
@end

@implementation SFBMLoginWithoutPasswordController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _seconds = TimeOutInterval;
    [self initUI];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxLoginNotification:) name:kWXLoginNotification object:nil];
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}
//初始化UI
- (void)initUI{
    
    [_userPhoneNumberT setValue:RGBA(184, 184, 184, 184) forKeyPath:@"_placeholderLabel.textColor"];
    [_varifyCodeT setValue:RGBA(184, 184, 184, 184) forKeyPath:@"_placeholderLabel.textColor"];

    _loginButton.layer.cornerRadius = _loginButton.height/2.0;
    [self baseCornerRaduisView:self.phoneNumberBgV radius:4 color:[UIColor lightGrayColor] wide:0.6];
    [self baseCornerRaduisView:self.varifyBgV radius:4 color:[UIColor lightGrayColor] wide:0.6];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
}


#pragma mark - buttonAction
- (IBAction)loginAction:(UIButton *)sender {
    
    MYNSLog(@"登录操作");
    if ([NSString isMobileStr:self.userPhoneNumberT.text]&&[self.userPhoneNumberT.text isEqualToString:@"15895985636"]) {
        //        loadind  nav_close18
//        [sender setImage:[UIImage imageNamed:@"nav_close18"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"loading24"] forState:UIControlStateNormal];

        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.duration = 1.5;
        animation.fromValue = @0;
        animation.toValue = [NSNumber numberWithDouble:M_PI*2];
        animation.repeatCount = MAXFLOAT;
        [sender.imageView.layer addAnimation:animation forKey:@"rotationAnimation"];
        sender.userInteractionEnabled = NO;
        [self sendLoginRequestWithType:SFBMLoginTypeMobile];
        
    }else{
        [self showTheMostCommonAlertmessage:@"请正确输入手机号码" ];
    }
    
    
}
//关闭
- (IBAction)closeLogin:(id)sender {
    if (self.timer.valid) {
        [self.timer invalidate];
    }
    self.timer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)gotoAgreement:(id)sender {
    SFBMWebController *vc = (SFBMWebController *)[self getControllerFromStoryboard:@"Login" withControllerID:@"SFBMWebController"];
    vc.type = SFBMWebTypeUseAgreement;
    [self push2Next:vc animated:YES];
}

- (IBAction)getVarifyCodeAction:(id)sender {
    MYNSLog(@"获取验证码");
    
    if ([NSString isMobileStr:self.userPhoneNumberT.text]) {
        [self requestNetworkingGetCode];
    }else{
        [self showTheMostCommonAlertmessage:@"请正确输入手机号码"];
    }
}

//编辑文字改变的时候
- (IBAction)textDidChangedAction:(UITextField *)sender {
    if (self.userPhoneNumberT.text.length != 0 && self.varifyCodeT.text.length != 0) {
        if (!self.loginButton.enabled) {
            self.loginButton.enabled = YES;
//            self.loginButton.backgroundColor = BASECOLOR;
        }
    }else{
        if (self.loginButton.enabled) {
            self.loginButton.enabled = NO;
//            self.loginButton.backgroundColor = RGBA(230, 230, 230, 1);
        }
    }
}

#pragma mark textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat height = textField == self.userPhoneNumberT?40:80;
    height = height * (375.0/SCREEN_WIDTH);
    [UIView animateWithDuration:.35 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -height);
        
    }];
    return YES;
}


#pragma mark netWorkRequest
- (void)sendLoginRequestWithType:(SFBMLoginType)type{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *url;
    url = USERLOGIN_URL;
    params[@"mobile"] = self.userPhoneNumberT.text;
    params[@"validCode"] = self.varifyCodeT.text;
    
    __weak typeof(self) weakSelf = self;//
    
    /*
     [MyAfnetwork postUrl:url baseURL:BASE_URL withHUD:YES message:nil parameters:params getChat:^(NSDictionary *myDic) {
     //
     MYNSLog(@"登录myDic=%@",myDic);
     NSString *erroMsg = [myDic objectForKey:@"retCode"];
     int code = erroMsg.intValue;
     if (code== 10000){
     
     [self showTheMostCommonAlertmessage:@"登录成功"];
     NSDictionary *dic = [myDic objectForKey:@"data"];
     NSString *user_id = (NSString *)[dic objectForKey:@"user_id"];
     NSString *userName = [dic objectForKey:@"user_name"];
     //            NSString *user_mobile = [dic objectForKey:@"mobile"];
     
     NSString *token = [dic objectForKey:@"token"];
     NSString *verify = [dic objectForKey:@"verify"];
     NSString *userPortrait = [dic objectForKey:@"userPortrait"];
     
     //seller存储
     [CacheBox saveCacheValue:userName forKey:USER_NAME];
     NSDate *date = [NSDate date];
     [CacheBox saveCacheValue:date forKey:TOKEN_DATE];
     
     [CacheBox saveCacheValue:user_id forKey:USER_ID];
     [CacheBox saveCacheValue:weakSelf.userPhoneNumberT.text forKey:USER_MOBILE];
     
     [CacheBox saveCacheValue:userPortrait forKey:USER_ICON];
     [CacheBox saveCacheValue:token forKey:USER_TOKEN];
     [CacheBox saveCacheValue:verify forKey:USER_VERITY];
     
     
     
     //                [weakSelf doNetworkingOrderList];
     //            [weakSelf uploadRegistrationIdNetWorking];
     
     //            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
     //            NSString *registId = [CacheBox getCacheWithKey:USER_REDISTRATIONID];
     //            if (registId.length>0) {
     //                [self donetworkingUploadRegistrationId];
     //            }else{
     //                [weakSelf dismissViewControllerAnimated:YES completion:nil];
     //            }
     [weakSelf dismissViewControllerAnimated:YES completion:nil];
     
     
     }else{
     [weakSelf.loginButton setImage:nil forState:UIControlStateNormal];
     [weakSelf.loginButton.imageView.layer removeAllAnimations];
     weakSelf.loginButton.userInteractionEnabled = YES;
     [self showTheMostCommonAlertmessage:@"验证失败，请输入正确手机验证码"];
     
     }
     
     } failure:^{
     weakSelf.loginButton.imageView.image = nil;
     [weakSelf.loginButton.imageView.layer removeAllAnimations];
     weakSelf.loginButton.userInteractionEnabled = YES;
     [self showTheMostCommonAlertmessage:@"网络有问题，请重试"];
     }];
     */
    
    //临时模拟服务器登录 把手机号当做唯一的标识符 userid
    [CacheBox saveCacheValue:self.userPhoneNumberT.text forKey:USER_ID];
    [self showTheMostCommonAlertmessage:@"登录成功"];

    [weakSelf dismissViewControllerAnimated:YES completion:nil];
}
- (void)requestNetworkingGetCode
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"mobile"] = _userPhoneNumberT.text;
    
    __weak typeof(self) __weakSelf = self;
    [MyAfnetwork postUrl:REGISTERCODE_URL baseURL:BASE_URL withHUD:NO message:nil parameters:params getChat:^(NSDictionary *myDic) {
        //
        int code = [[myDic objectForKey:@"retCode"] intValue];
        if (code==10000) {
            [__weakSelf getTimer];
            [__weakSelf showTheMostCommonAlertmessage:[myDic objectForKey:@"retMsg"]];
        }else{
            [__weakSelf showTheMostCommonAlertmessage:[myDic objectForKey:@"retMsg"]];
        }
        
    } failure:^{
        //
        [self showTheMostCommonAlertmessage:@"获取失败，请重试"];
    }];
}
//极光推送上传参数接口
//- (void)donetworkingUploadRegistrationId{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"userId"] = [CacheBox getCacheWithKey:USER_ID];
//    params[@"token"] = [CacheBox getCacheWithKey:USER_TOKEN];
//    params[@"registrationId"] = [CacheBox getCacheWithKey:USER_REDISTRATIONID];
//    MYNSLog(@"registrationId=22=%@",[CacheBox getCacheWithKey:USER_REDISTRATIONID]);
//
//    __weak typeof(self) weakSelf = self;//
//    [MyAfnetwork postUrl:JPushRegistrationId_URL baseURL:BASE_URL withHUD:NO message:nil parameters:params getChat:^(NSDictionary *myDic) {
//        //
//        [weakSelf dismissViewControllerAnimated:YES completion:nil];
//
//        NSString *erroMsg = [myDic objectForKey:@"code"];
//        int code = erroMsg.intValue;
//        if (code== 100){
//
//        }else{
//
//        }
//
//    } failure:^{
//        [weakSelf dismissViewControllerAnimated:YES completion:nil];
//
//        //        [self showTheMostCommonAlertmessage:@"网络有问题，请重试"];
//    }];
//}
#pragma mark - private
- (void)getTimer{
    if (_timer != nil) {
        
        [_timer invalidate];
        _timer = nil;
    }
    NSString *strTime = [NSString stringWithFormat:@"%d", _seconds];
    [self.getVarifyCodeButton setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
    self.getVarifyCodeButton.enabled = NO;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(startTimeMinus:) userInfo:nil repeats:YES];
    
}
//开启验证码计时
- (void)startTimeMinus:(NSTimer *)timer
{
    _seconds--;
    if (_seconds < 0) {
        [self.getVarifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getVarifyCodeButton.enabled = YES;
        [timer invalidate];
        self.timer = nil;
        _seconds = TimeOutInterval;
    }else{
        
        NSString *strTime = [NSString stringWithFormat:@"%d", _seconds];
        [self.getVarifyCodeButton setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
        self.getVarifyCodeButton.enabled = NO;
    }
    
}

//发起登陆认证
//-(BOOL)sendAuthRequest
//{
//    //构造SendAuthReq结构体
//    SendAuthReq* req =[[SendAuthReq alloc ] init];
//    req.scope = @"snsapi_userinfo" ;
//    req.state = @"123" ;
//    //第三方向微信终端发送一个SendAuthReq消息结构
//    return [WXApi sendReq:req];
//    //    return [WXApi sendAuthReq:req viewController:nil delegate:self];
//}

#pragma mark notification
//键盘隐藏
- (void)keyboardDidHideNotification:(NSNotification *)noti{
    
    [UIView animateWithDuration:.35 animations:^{
        self.view.transform = CGAffineTransformIdentity;
        
    }];
    
}



- (void)dealloc{
    
    MYNSLog(@"登录页面释放了");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

