//
//  JKOAuthViewController.m
//  Weibo
//
//  Created by HiJack on 16/1/9.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import "JKOAuthViewController.h"
#import "AFNetworking.h"
#import "JKTabBarController.h"
#import "JKAccount.h"
#import "SVProgressHUD.h"
#import "JKAccountTool.h"


@interface JKOAuthViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation JKOAuthViewController

#pragma mark - 懒加载



#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _webView.delegate = self;
    [_webView scalesPageToFit];
    [self.view addSubview:_webView];

  
    
    // 2.登录获得token授权并进入微博
    [self login];
    
}


/**
 *  登录获得token授权并进入微博
 */
- (void)login
{
    // 用webView加载登陆页面
    NSString *urlStringForAuthorize = @"https://api.weibo.com/oauth2/authorize?client_id=963361910&redirect_uri=http://baidu.com";
    NSURL *url = [NSURL URLWithString:urlStringForAuthorize];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 加载登陆界面并储存Token,进入微博
    [_webView loadRequest:request];

}

#pragma mark - webView代理方法
// webView
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 1. 获得url
    NSString *url = request.URL.absoluteString;
    
    // 2.判断是否为回调地址
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0) { // 是回调地址
        // 截取code(code=后面的参数值)
        NSString *code = [url substringFromIndex:(range.location + range.length)];
        // 利用code获得accessToken
        [self accessTokenWithCode:code];
        
        // 禁止加载回调地址
        return NO;
    }
    return YES;
    
}

/**
 *  利用code获得accessToken
 *
 *  @param code 授权成功后的accessToken
 */
- (void)accessTokenWithCode:(NSString *)code
{
    
    
    // 1.请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    // 2.设置请求体参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = @"963361910";
    params[@"client_secret"] = @"9b7edec1e6962dd44d8d886a89ec957d";
    params[@"grant_type"] = @"authorization_code";
    params[@"code"] = code;
    params[@"redirect_uri"] = @"http://baidu.com";
    
    // 3.发送请求
    [mgr POST:@"https://api.weibo.com/oauth2/access_token" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
        
        // 将服务器返回的account存入沙盒
        // - 将account字典转为模型
        NSLog(@"accessToken返回数据%@",responseObject);
        JKAccount *account = [JKAccount accountWithDictionary:responseObject];
        // - 储存account
        [JKAccountTool saveAccout:account];
        
        // 进入主页(tabBarController)
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = [[JKTabBarController alloc]init];
        
        
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求失败%@",error);
        [self login];
        
    }];
    
}

@end
