//
//  JKStatusComposeController.h
//  Weibo
//
//  Created by HiJack on 16/3/1.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JKStatusComposeControllerDelegate <NSObject>
@optional
- (void)statusComposeSuccess;

@end

@interface JKStatusComposeController : UIViewController
@property (nonatomic, weak) id<JKStatusComposeControllerDelegate> delegate;

@end
