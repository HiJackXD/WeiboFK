//
//  JKComposeToolbar.m
//  Weibo
//
//  Created by HiJack on 16/3/1.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import "JKComposeToolbar.h"
#import "YYKit.h"
#import "JKStatusHelper.h"



@implementation JKComposeToolbar
- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = CGSizeMake(kScreenWidth, 44);
    }
    if (self = [super initWithFrame:frame]) {
        // 图片
        [self addButtonWithType:JKComposeToolBarTypePicture Image:@"compose_toolbar_picture" highlight:@"compose_toolbar_picture_highlited"];
        // @
        [self addButtonWithType:JKComposeToolBarTypeMention Image:@"compose_mentionbutton_background" highlight:@"compose_mentionbutton_background_highlighted"];
        // #
        [self addButtonWithType:JKComposeToolBarTypeTrend Image:@"compose_trendbutton_background" highlight:@"compose_picturebutton_background_highlited"];
        // 表情
        [self addButtonWithType:JKComposeToolBarTypeEmotion Image:@"compose_emoticonbutton_background" highlight:@"compose_picturebutton_background_highlited"];
        // +
        [self addButtonWithType:JKComposeToolBarTypeAdd Image:@"message_add_background" highlight:@"message_add_background_highlighted"];

        
    }
    return self;
}

- (void)layoutSubviews
{
    NSUInteger count = self.subviews.count;
    for (int i = 0 ; i < count; i++) {
        UIButton *button = self.subviews[i];
        button.height = self.height;
        button.width = kScreenWidth / count;
        button.left = button.width * i;
    }
}

- (void)addButtonWithType:(JKComposeToolBarType)buttonType Image:(NSString *)imageName highlight:(NSString *)highlit
{
    UIButton *button = [[UIButton alloc] init];
    button.tag = buttonType;
    [button setImage:[JKStatusHelper imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[JKStatusHelper imageNamed:highlit] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:button];
}

- (void)clickButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(composeToolBar:didClickButton:)]) {
        [self.delegate composeToolBar:self didClickButton:button];
    }
}
@end
