//
//  JKTextView.h
//  Weibo
//
//  Created by HiJack on 16/3/1.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKTextView : UITextView
#define kStatusComposeFont [UIFont systemFontOfSize:17]

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholderString;

@end
