//
//  JKEmotionInputView.h
//  Weibo
//
//  Created by HiJack on 16/3/5.
//  Copyright © 2016年 HiJack. All rights reserved.
//



#import <UIKit/UIKit.h>
@class JKEmotion;
@class JKEmotionTable;
@class JKEmotionScrollView;

typedef NS_ENUM(NSUInteger, JKEmotionGroupButtonType)
{
    JKEmotionGroupButtonTypeDefault,
    JKEmotionGroupButtonTypeEmoji,
    JKEmotionGroupButtonTypeLxh
};


@protocol JKEmotionInputViewDelegate <NSObject>
@optional
- (void)tapCollectionViewForEmotion:(JKEmotion *)emotion;
- (void)tapCollectionViewForDelete;

@end

@interface JKEmotionInputView : UIView
@property (nonatomic, weak) id<JKEmotionInputViewDelegate> delegate;

+ (instancetype)sharedView;

@end
