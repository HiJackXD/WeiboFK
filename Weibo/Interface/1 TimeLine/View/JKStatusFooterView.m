//
//  JKStatusFooterView.m
//  Weibo
//
//  Created by HiJack on 16/1/18.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import "JKStatusFooterView.h"

@implementation JKStatusFooterView

- (void)awakeFromNib
{
    int width = [UIScreen mainScreen].bounds.size.width;
    self.frame  = CGRectMake(0, 0, width, 30);
}

+ (instancetype)footerView
{
    static JKStatusFooterView *footerView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      footerView =  [[[NSBundle mainBundle] loadNibNamed:@"JKStatusFooterView" owner:nil options:nil] firstObject];
    });
    return footerView;
    
}

@end
