//
//  JKComposeToolbar.h
//  Weibo
//
//  Created by HiJack on 16/3/1.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JKComposeToolBarType)
{
    JKComposeToolBarTypePicture,
    JKComposeToolBarTypeMention,
    JKComposeToolBarTypeTrend,
    JKComposeToolBarTypeEmotion,
    JKComposeToolBarTypeAdd
};

@class JKComposeToolbar;

@protocol JKComposeToolbarDelegate <NSObject>
@optional
- (void)composeToolBar:(JKComposeToolbar *)toolBar didClickButton:(UIButton *)buttom;
@end


@interface JKComposeToolbar : UIView
@property (nonatomic, weak) id<JKComposeToolbarDelegate> delegate;

@end
