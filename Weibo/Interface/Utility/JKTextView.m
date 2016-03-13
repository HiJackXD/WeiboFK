//
//  JKTextView.m
//  Weibo
//
//  Created by HiJack on 16/3/1.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import "JKTextView.h"
#import "YYKit.h"


@interface JKTextView () <UIScrollViewDelegate>
@property (nonatomic, weak) YYLabel *placeHolderLabel;
@end

@implementation JKTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = CGSizeMake(kScreenWidth, kScreenHeight);
    }
    if (self = [super initWithFrame:frame]) {
        YYLabel *placeHolderLabel = [YYLabel new];
        placeHolderLabel.text = _placeholderString ? _placeholderString : @"请输入微博...";
        placeHolderLabel.textColor = UIColorHex(878787);
        placeHolderLabel.frame = CGRectMake(5, 8, kScreenWidth- 10, kStatusComposeFont.pointSize);
        [self addSubview:placeHolderLabel];
        self.placeHolderLabel = placeHolderLabel;
        self.placeHolderLabel.font = self.font = kStatusComposeFont;
        
        [self becomeFirstResponder];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)textDidChange
{
    self.placeHolderLabel.hidden = ![self hasText];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}


@end
