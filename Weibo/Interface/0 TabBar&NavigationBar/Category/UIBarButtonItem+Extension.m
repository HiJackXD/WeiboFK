//
//  UIBarButtonItem+Extension.m
//  Weibo
//
//  Created by HiJack on 16/1/1.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)


/**
 *  创建一个特定button类型的UIBarButtonItem对象
 *
 *  @param taget          点击item后向taget发送消息
 *  @param action         点击item后taget调用的方法
 *  @param image          item普通图片
 *  @param highlightImage item高亮图片
 *
 *  @return 创建的item
 */
+ (instancetype)itemWithTaget:(id)taget action:(SEL)action image:(NSString *)image highlightImage:(NSString *)highlightImage
{
    // 创建一个button代替导航返回键
    UIButton *leftBarButton = [[UIButton alloc]init];
    // 设置button的frame
    UIImage *currentImage = [UIImage imageNamed:image];
    leftBarButton.frame = CGRectMake(0, 0, currentImage.size.width, currentImage.size.height);
    // 设置button图片
    [leftBarButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [leftBarButton setImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
    // 设置button点击事件方法 (返回)
    [leftBarButton addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];

    return  [[UIBarButtonItem alloc]initWithCustomView:leftBarButton];
}
@end
