//
//  JKTabBarController.m
//  Weibo
//
//  Created by HiJack on 16/1/1.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import "JKTabBarController.h"
#import "JKHomeViewController.h"
#import "JKMessageCenterViewController.h"
#import "JKDiscoverViewController.h"
#import "JKProfileTableViewController.h"
#import "JKNavigationController.h"
#import "JKStatusHelper.h"

@interface JKTabBarController ()

@end

@implementation JKTabBarController

#pragma mark ViewDidLoad调用方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化子控制器
   
    // 添加主页控制器
    JKHomeViewController *homeViewController = [[JKHomeViewController alloc]init];
     [self _addChildViewController:homeViewController withTitle:@"主页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    // 添加消息控制器
    JKMessageCenterViewController *messageCenterViewController = [[JKMessageCenterViewController alloc]init];
    [self _addChildViewController:messageCenterViewController withTitle:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    
    // 添加"发现"控制器
    JKDiscoverViewController *discoverController = [[JKDiscoverViewController alloc]init];
    [self _addChildViewController:discoverController withTitle:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    
    // 添加"我"控制器
    JKProfileTableViewController *profileController = [[JKProfileTableViewController alloc]init];
    [self _addChildViewController:profileController withTitle:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];

    
    
}

#pragma mark 内存警告调用方法
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 自建方法

/**
 * 为当前控制器增加一个特定子控制器
 *
 *  @param childViewController 被加入的子控制器
 *  @param title               自控器标题(显示在navigationBar&tabBarItem)
 *  @param image               子控制器对应的tabBarItem图片
 *  @param selectedImage       子控制器对应的tabBarItem的高亮图片(UIImageRenderingModeAlwaysOriginal)
 */
- (void )_addChildViewController:(UIViewController *)childViewController withTitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    
    // 设置主页控制器标题
    childViewController.tabBarItem.title = title;
    // 设置主页控制器tabBarItem图片(默认图片与selected图片)
    childViewController.tabBarItem.image = [JKStatusHelper imageNamed:image];
    childViewController.tabBarItem.selectedImage = [[JKStatusHelper imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字样式
    
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childViewController.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    // 给homeViewController包装一个导航控制器
    JKNavigationController *childNavigationController = [[JKNavigationController alloc]initWithRootViewController:childViewController];
    
    // 添加导航控制器为self的子控制器
    [self addChildViewController:childNavigationController];
    
}


#pragma mark overriding methods



@end
