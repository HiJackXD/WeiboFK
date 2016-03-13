//
//  UIBarButtonItem+Extension.h
//  Weibo
//
//  Created by HiJack on 16/1/1.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)


+ (instancetype)itemWithTaget:(id)taget action:(SEL)action image:(NSString *)image highlightImage:(NSString *)highlightImage;

@end
