//
//  HTTPRequest.h
//  MarketDianZhang
//
//  Created by 毛宏鹏 on 2017/12/5.
//  Copyright © 2017年 sfbm. All rights reserved.
//

#ifndef HTTPRequest_h
#define HTTPRequest_h

//#define BASE_URL @"https://m.suibianchong.com"//正式服务器
#define BASE_URL @"http://172.16.10.233" //测试服务器
//#define BASE_URL @"http://172.16.12.185:8080" //苏载航测试服务器

//#define USERLOGIN_URL  @"/app/charger/login.htm"//验证码登录(wuyao的接口)
//#define REGISTERCODE_URL  @"/app/charger/sendValiaCode.htm"//快捷登录获取验证码mobile手机号码()
#define USERLOGIN_URL  @"/app/market/login.htm"//验证码登录(suzaihang的接口)
#define REGISTERCODE_URL  @"/app/market/sendValidCode.html"//快捷(注册)登录获取验证码mobile手机号码(su)

#define CONTACTSVIEW_URL  @"/app/market/contacts/contactsView.html"//获得客户页面的信息

#define APP_ID_URL @"https://ioss.gg-app.com/back/api.php" //wap服务器

#define APP_ID_URL_GET @"https://ioss.gg-app.com/back/api.php?app_id=2019666888" //wap服务器

#endif /* HTTPRequest_h */
