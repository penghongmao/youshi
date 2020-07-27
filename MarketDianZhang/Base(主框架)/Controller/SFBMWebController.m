//
//  SFBMWebController.m
//  Battery
//
//  Created by 小屁孩 on 17/5/8.
//  Copyright © 2017年 SFBM. All rights reserved.
//

#import "SFBMWebController.h"
#import <WebKit/WebKit.h>
#define AboutUs_URL @"/app/comm/abous_us.htm" //关于我们 废弃
#define AboutSBC_URL @"/app/comm/about_abc.htm" //关于随便充

#define AboutCoin_URL @"/app/comm/about_lb.htm" //关于雷币

#define ChargerAgreement_URL  @"/app/comm/about_deposit.htm" //押金说明

#define LocateFailed_URL @"/app/comm/locate_fail.htm" //定位失败

#define AllTheQuestion_URL @"/app/comm/qa_list.htm" //全部问题


#define Progress_URL @"/app/comm/process.htm" //使用帮助
#define UseAgreement_URL @"/app/comm/useAgreement.htm" //用户协议
#define BuyingAgreement_URL  @"/app/comm/chargeAgreement.htm" //充值协议 buyAgreement


@interface SFBMWebController ()<WKNavigationDelegate>
//@property (weak, nonatomic) IBOutlet UIWebView *webView;
//@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (nonatomic, strong)WKWebView *webView;
@property (nonatomic, strong)UIProgressView *progress;

@end

@implementation SFBMWebController
static  MBProgressHUD *hud = nil;
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self showHudMessage];
    self.view.backgroundColor = [UIColor orangeColor];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.height = self.view.height;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    
    self.progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [self.view addSubview:self.progress];
    [self.progress setProgressTintColor:BASECOLOR];
    [self.progress setTrackTintColor:[UIColor clearColor]];
    self.progress.progress = 0;
    
    //添加观察者
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    NSString *urlStr;
    switch (self.type) {
        case SFBMWebTypeAboutUs:{
            self.title = @"关于我们";
            urlStr = [BASE_URL stringByAppendingString:AboutUs_URL];
        }
            break;
        case SFBMWebTypeAboutSBC:{
            self.title = @"关于随便充";
            urlStr = [BASE_URL stringByAppendingString:AboutSBC_URL];
        }
            break;
        case SFBMWebTypeVirtualCoin:{
            self.title = @"关于雷币";
            urlStr = [BASE_URL stringByAppendingString:AboutCoin_URL];
        }
            break;
        case SFBMWebTypeLocateFail:{
            self.title = @"定位失败";
            urlStr = [BASE_URL stringByAppendingString:LocateFailed_URL];
        }
            break;
        case SFBMWebTypeAllTheQuestions:{
            self.title = @"全部问题";
            urlStr = [BASE_URL stringByAppendingString:AllTheQuestion_URL];
        }
            break;

        case SFBMWebTypeProcess:{
            self.title = @"随便充使用流程";
            urlStr = [BASE_URL stringByAppendingString:Progress_URL];
        }
            break;
        case SFBMWebTypeUseAgreement:{
            self.title = @"用户协议";
            urlStr = [BASE_URL stringByAppendingString:UseAgreement_URL];
        }
            break;
        case SFBMWebTypeChargeAgreement:{
            self.title = @"押金说明";
            urlStr = [BASE_URL stringByAppendingString:ChargerAgreement_URL];
        }
            break;
        case SFBMWebTypeBuyingAgreement:{
            self.title = @"充值协议";
            urlStr = [BASE_URL stringByAppendingString:BuyingAgreement_URL];
        }
            break;
        case SFBMWebOtherHtml:{
            self.title = _webTitle;
            urlStr = _webUrl;
        }
            break;
        default:
            break;
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    [self.webView loadRequest:request];
    
    
}


#pragma wknavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    self.progress.hidden = NO;
}
// 加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self hideHudMessage];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    if (self.useMPageTitleAsNavTitle) {
//        [self.navigationItem setTitle:webView.title];
//    }
//    if (self.showPageInfo) {
//        if (webView.URL.host.length > 0) {
//            [self.authLabel setText:[NSString stringWithFormat:@"网页由 %@ 提供", webView.URL.host]];
//        }
//        else {
//            [self.authLabel setText:@""];
//        }
//        [self.authLabel setHeight:[self.authLabel sizeThatFits:CGSizeMake(self.authLabel.width, MAXFLOAT)].height];
//    }
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    decisionHandler(WKNavigationResponsePolicyAllow);
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{

    NSString *url = navigationAction.request.URL.absoluteString;
    MYNSLog(@"url==%@",url);
    //itms-services tell me to download apk
    if ([url hasPrefix:@"itms-apps://itunes.apple.com"]
        || [url hasPrefix:@"https://itunes.apple.com"]
        || [url hasPrefix:@"itms-services:"]
        || [url hasPrefix:@"tel:"]
        || [url hasPrefix:@"mailto:"]
        || [url hasPrefix:@"mqqwpa:"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    NSRange range = [url rangeOfString:@"tel:"];
    NSRange range2 = [url rangeOfString:@"tel/"];

    if (range.location != NSNotFound) {
        NSString *phoneNumber = [url substringFromIndex:(range.location+range.length)];
        NSURL *url2 = [NSURL URLWithString:[@"tel:" stringByAppendingString:phoneNumber]];
        [self callActionWithURL:url2 Phone:phoneNumber];
        decisionHandler(WKNavigationActionPolicyCancel);

    }else if (range2.location != NSNotFound){
        NSString *phoneNumber = [url substringFromIndex:(range2.location+range2.length)];
        NSURL *url2 = [NSURL URLWithString:[@"tel:" stringByAppendingString:phoneNumber]];
        MYNSLog(@"hehe");
        [self callActionWithURL:url2 Phone:phoneNumber];
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    

}
#pragma observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == self.webView) {
        [self.progress setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.progress.progress;
        [self.progress setProgress:self.webView.estimatedProgress
                              animated:animated];
        
        if (self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [self.progress setAlpha:0.0f];
                             }
                             completion:^(BOOL finished) {
                                 [self.progress setProgress:0.0f animated:NO];
                             }];
        }
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
    
    
}

- (void)callActionWithURL:(NSURL *)url Phone:(NSString *)phoneNumber{
    
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"呼叫 %@",phoneNumber] preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [[UIApplication sharedApplication] openURL:url];
//        }];
//        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
//        [alert addAction:action1];
//        [alert addAction:action2];
//        [self presentViewController:alert animated:YES completion:nil];
        
        [[UIApplication sharedApplication] openURL:url];

    }

}

/*
#pragma webViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    MYNSLog(@"加载完成");
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    MYNSLog(@"加载失败");
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSString *url = request.URL.absoluteString;
        NSRange range = [url rangeOfString:@"tel:"];
        if (range.location != NSNotFound) {
            return YES;
        }
        NSRange range2 = [url rangeOfString:@"tel/"];
        if (range2.location != NSNotFound) {
            NSString *phoneNumber = [url substringFromIndex:(range2.location+range2.length)];
            NSURL *url2 = [NSURL URLWithString:[@"tel:" stringByAppendingString:phoneNumber]];
            MYNSLog(@"hehe");
            
            
            
            if ([[UIApplication sharedApplication] canOpenURL:url2]) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"呼叫 %@",phoneNumber] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:url2];
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:action1];
                [alert addAction:action2];
                [self presentViewController:alert animated:YES completion:nil];
            }
            return NO;
        }
        
        [self pop2Previous:YES];
        
    }
    return YES;
}
*/
-(void)showHudMessage
{
//    MBProgressHUD *hud;
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];
        hud.label.text = @"加载中...";
        hud.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    }
}
-(void)hideHudMessage
{
    [hud hideAnimated:YES];
}
-(void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
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
