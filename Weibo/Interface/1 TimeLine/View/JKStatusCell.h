//
//  JKHomeTableViewCell.h
//  Weibo
//
//  Created by HiJack on 16/1/16.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit/YYKit.h>
#import "JKTableViewCell.h"
#import "JKStatusLayout.h"
#import "JKStatusHelper.h"

@class JKStatusCell;



@interface JKStatusProfileView : UIView
@property (nonatomic, strong) UIImageView *avatarView; ///< 头像
@property (nonatomic, strong) UIImageView *avatarBadgeView; ///< 徽章
@property (nonatomic, strong) YYLabel *nameLabel; ///< 昵称
@property (nonatomic, strong) YYLabel *sourceLabel; ///< 来源
@property (nonatomic, assign) JKUserVerifyType verifyType; ///< 认证类型
@property (nonatomic, weak) JKStatusCell *cell; ///< 所在的cell
@end

@interface JKPicsView : UIView
@end

@interface JKStatusToolbarView : UIView
@property (nonatomic, strong) UIButton *repostButton;
@property (nonatomic, strong) UIButton *commentButton;

@property (nonatomic, strong) UIImageView *repostImageView;
@property (nonatomic, strong) UIImageView *commentImageView;

@property (nonatomic, strong) YYLabel *repostLabel;
@property (nonatomic, strong) YYLabel *commentLabel;

@property (nonatomic, strong) CAGradientLayer *line1;
@property (nonatomic, strong) CAGradientLayer *line2;
@property (nonatomic, strong) CALayer *topLine;
@property (nonatomic, strong) CALayer *bottomLine;
@property (nonatomic, weak) JKStatusCell *cell;


@end

@interface JKRetweetView : UIView
@property (nonatomic, strong) YYLabel *retweetTextLabel;
@property (nonatomic, strong) JKPicsView *picsView;

@end



@interface JKStatusView : UIView
@property (nonatomic, strong) UIView *contentView;              // 容器

@property (nonatomic, strong) JKStatusProfileView *profileView; ///< 用户资料(头像/昵称/来源/发布日期)
@property (nonatomic, strong) YYLabel *textLabel;  // 文本
@property (nonatomic, strong) JKPicsView *picView; // 配图
@property (nonatomic, strong) JKRetweetView *retweetView; // 转发内容

@property (nonatomic, strong) JKStatusLayout *layout;
@property (nonatomic, weak) JKStatusCell *cell;

@property (nonatomic, strong) JKStatusToolbarView *toolbarView; // 工具栏


@end



@protocol JKStatusCellDelegate;
@interface JKStatusCell : JKTableViewCell
@property (nonatomic, weak) id<JKStatusCellDelegate> delegate;
@property (nonatomic, strong) JKStatusView *statusView;
- (void)setlayout:(JKStatusLayout *)layout;
@end


@protocol JKStatusCellDelegate <NSObject>
@optional
/// 点击了 Cell
- (void)cellDidClick:(JKStatusCell *)cell;
/// 点击了 Card
- (void)cellDidClickCard:(JKStatusCell *)cell;
/// 点击了转发内容
- (void)cellDidClickRetweet:(JKStatusCell *)cell;
/// 点击了Cell菜单
- (void)cellDidClickMenu:(JKStatusCell *)cell;
/// 点击了关注
- (void)cellDidClickFollow:(JKStatusCell *)cell;
/// 点击了转发
- (void)cellDidClickRepost:(JKStatusCell *)cell;
/// 点击了下方 Tag
- (void)cellDidClickTag:(JKStatusCell *)cell;
/// 点击了评论
- (void)cellDidClickComment:(JKStatusCell *)cell;
/// 点击了赞
- (void)cellDidClickLike:(JKStatusCell *)cell;
/// 点击了用户
- (void)cell:(JKStatusCell *)cell didClickUser:(JKUser *)user;
/// 点击了图片
- (void)cell:(JKStatusCell *)cell didClickImageAtIndex:(NSUInteger)index;
/// 点击了 Label 的链接
- (void)cell:(JKStatusCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange;
@end

