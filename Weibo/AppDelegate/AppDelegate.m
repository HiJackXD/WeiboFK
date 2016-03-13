//
//  AppDelegate.m
//  Weibo
//
//  Created by HiJack on 15/12/31.
//  Copyright © 2015年 HiJack. All rights reserved.
//

#import "AppDelegate.h"
#import "JKTabBarController.h"
#import "JKOAuthViewController.h"
#import "JKAccountTool.h"
@interface AppDelegate () 

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.
    
    // 1.创建一个窗口
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    // 2.设置window根控制器
    // 沙盒路径(查找account)
    JKAccount *account = [JKAccountTool account];
    if (account) { // 本地有Token
        // 启动主界面
        JKTabBarController *tabBarController = [[JKTabBarController alloc]init];
        [self.window setRootViewController:tabBarController];
    } else { // 本地无Token
    // 启动OAuth验证
    [self.window setRootViewController:[[JKOAuthViewController alloc]init]];
    }
    
  
    // 5.显示窗口
    [self.window makeKeyAndVisible];
    
    // 设置UIBarButtonItem 高亮样式
    NSMutableDictionary *highlightTextAttributes = [[NSMutableDictionary alloc] init];
    highlightTextAttributes[NSForegroundColorAttributeName] = [UIColor orangeColor];
    highlightTextAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [[UIBarButtonItem appearance] setTitleTextAttributes:highlightTextAttributes forState:UIControlStateHighlighted];
    
    // 设置UIBarButtonItem 普通样式
    NSMutableDictionary *normalTextAttributes = [[NSMutableDictionary alloc] init];
    normalTextAttributes[NSForegroundColorAttributeName] = [UIColor blackColor];
    normalTextAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [[UIBarButtonItem appearance] setTitleTextAttributes:normalTextAttributes forState:UIControlStateNormal];
    
    UIImage *featureImage = [UIImage imageNamed:@"new_feature_1"];

    
    
    
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
