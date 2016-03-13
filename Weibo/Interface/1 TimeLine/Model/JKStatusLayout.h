//
//  JKStatusLayout.h
//  Weibo
//
//  Created by HiJack on 16/1/25.
//  Copyright © 2016年 HiJack. All rights reserved.
//
#import "YYKit.h"
#import "JKStatusModel.h"
#import <Foundation/Foundation.h>


// 宽高
#define kJKStatusCellTopMargin 8        // cell 顶部灰色留白
#define kJKStatusCellPadding 12         // cell 内边距
#define kJKStatusCellProfileHeight 56 // cell 名片高度


#define kJKStatusCellNamePaddingLeft 14 // cell 名字和头像之间的空白
#define kJKStatusCellNameWidth (kScreenWidth - 110) // cell 名字最宽限制
#define kJKStatusCellPaddingText 10     // cell 正文与上下其他元素间留白
#define kJKStatusCellContentWidth (kScreenWidth - 2 *kJKStatusCellPadding) // cell 内容宽度
#define kJKStatusCellNameWidth (kScreenWidth - 110) // cell 名字最宽限制
#define kJKStatusCellPicPadding 5 // 图片之间间距
#define kJKStatusCellToolbarHeight 35 // toolbar高度


#define kJKStatusCellToolbarBottomMargin 2 // cell 下方灰色留白



// 字体
#define kJKStatusCellNameFontSize 16 // 名字字体大小
#define kJKStatusCellSourceFontSize 12 // 来源字体大小
#define kJKStatusCellTextFontSize 17 // 正文字体大小
#define kJKStatusCellRetweetTextFontSize 15 // 转发正文字体大小
#define kJKStatusCellToolbarFontSize 14 // 工具栏字体大小


// 颜色
#define kJKStatusCellNameNormalColor UIColorHex(333333) // 普通名字颜色
#define kJKStatusCellNameVipColor UIColorHex(f26220) // Vip名字颜色
#define kJKStatusCellTextNormalColor UIColorHex(333333) // 一般文本色
#define kJKStatusCellTimeNormalColor UIColorHex(828282) // 时间颜色
#define kJKStatusCellTextHighlightColor UIColorHex(527ead) // Link 文本色
#define kJKStatusCellTextHighlightBackgroundColor UIColorHex(bfdffe) // Link 点击背景色
#define kJKStatusCellToolbarTitleColor UIColorHex(929292) // 工具栏文本色

// 其他
#define kJKStatusToolbarButtonsCount 2




@interface JKStatusLayout : NSObject

// 以下是数据
@property (nonatomic, strong) JKStatus *status;

// 以下是布局结果

/// 顶部留白
@property (nonatomic, assign) CGFloat marginTop;
// 个人资料
@property (nonatomic, assign) CGFloat profileHight; // 个人资料高度
@property (nonatomic, strong) YYTextLayout *nameTextLayout; // 名字布局
@property (nonatomic, strong) YYTextLayout *sourceTextLayout; // 来源布局
// 正文
@property (nonatomic, assign) CGFloat textHeight; ///< 正文高度
@property (nonatomic, strong) YYTextLayout *textLayout; ///< 正文布局

// 配图
@property (nonatomic, assign) CGFloat picsHeight;
@property (nonatomic, assign) CGSize picSize;
@property (nonatomic, strong) YYTextLayout *picLayout;

// 转发
@property (nonatomic, assign) CGFloat retweetHeight; ///< 转发高度
@property (nonatomic, strong) YYTextLayout *retweetLayout; ///< 转发布局

// 工具栏
@property (nonatomic, assign) CGFloat toolbarHeight; // 工具栏
@property (nonatomic, strong) YYTextLayout *toolbarRepostTextLayout; ///<工具栏转发数字布局(=0,显示"转发")
@property (nonatomic, strong) YYTextLayout *toolbarCommentTextLayout; ///< 工具栏评论数字布局(=0,显示"评论")
@property (nonatomic, assign) CGFloat toolbarRepostTextWidth; ///< 工具栏转发数字宽度
@property (nonatomic, assign) CGFloat toolbarCommentTextWidth; ///< 工具栏评论数字宽度
/// 下边留白
@property (nonatomic, assign) CGFloat marginBottom; ///< 下边留白

// 总高度
@property (nonatomic, assign) CGFloat height;

- (instancetype)initWithStatus:(JKStatus *)status;
- (void)layout;
@end    


/**
 文本 Line 位置修改
 将每行文本的高度和位置固定下来，不受中英文/Emoji字体的 ascent/descent 影响
 */
@interface WBTextLinePositionModifier : NSObject <YYTextLinePositionModifier>
@property (nonatomic, strong) UIFont *font; ///< 基准字体 (例如 Heiti SC/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop; ///< 文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom; ///< 文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; ///< 行距倍数
- (CGFloat)heightForLineCount:(NSUInteger)lineCount; ///< 本文总高度
@end



