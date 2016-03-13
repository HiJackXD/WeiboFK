//
//  JKHomeTableViewCell.m
//  Weibo
//
//  Created by HiJack on 16/1/16.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import "JKStatusCell.h"



@implementation JKStatusProfileView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kJKStatusCellProfileHeight;
    }
    if (self = [super initWithFrame:frame]) {
        self.exclusiveTouch = YES;
        
        // 添加头像view
        _avatarView = [UIImageView new];
        _avatarView.frame = CGRectMake(kJKStatusCellPadding, kJKStatusCellPadding + 3, 40, 40);
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_avatarView];
        //为头像view右下角添加认证view
        _avatarBadgeView = [UIImageView new];
        _avatarBadgeView.size = CGSizeMake(14, 14);
        _avatarBadgeView.center = CGPointMake(_avatarView.right - 6, _avatarView.bottom - 6);
        _avatarBadgeView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_avatarBadgeView];
        // 添加昵称label
        _nameLabel = [YYLabel new];
        _nameLabel.centerY = 17;
        _nameLabel.left = _avatarView.right + kJKStatusCellNamePaddingLeft;
        _nameLabel.size = CGSizeMake(kJKStatusCellNameWidth, 24);
        _nameLabel.displaysAsynchronously = YES;
        _nameLabel.ignoreCommonProperties = YES;
        _nameLabel.fadeOnAsynchronouslyDisplay = NO;
        _nameLabel.fadeOnHighlight = NO;
        _nameLabel.lineBreakMode = NSLineBreakByClipping;
        _nameLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        [self addSubview:_nameLabel];
         // 添加来源label
        _sourceLabel = [YYLabel new];
        _sourceLabel.frame = _nameLabel.frame;
        _sourceLabel.centerY = 47;
        _sourceLabel.displaysAsynchronously = YES;
        _sourceLabel.ignoreCommonProperties = YES;
        _sourceLabel.fadeOnAsynchronouslyDisplay = NO;
        _sourceLabel.fadeOnHighlight = NO;
        [self addSubview:_sourceLabel];
        
    }
    return self;
}

- (void)setVerifyType:(JKUserVerifyType)verifyType {
    _verifyType = verifyType;
    switch (verifyType) {
        case JKUserVerifyTypeStandard: {
            _avatarBadgeView.hidden = NO;
            _avatarBadgeView.image = [JKStatusHelper imageNamed:@"avatar_vip"];
        } break;
        case JKUserVerifyTypeClub: {
            _avatarBadgeView.hidden = NO;
            _avatarBadgeView.image = [JKStatusHelper imageNamed:@"avatar_grassroot"];
        } break;
        case JKUserVerifyTypeOrganization :{
            _avatarBadgeView.hidden = NO;
            _avatarBadgeView.image = [JKStatusHelper imageNamed:@"avatar_enterprise_vip"];
        }break;
        default: {
            _avatarBadgeView.hidden = YES;
        } break;
    }
}

@end

@implementation JKPicsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (void)setWithLayout:(JKStatusLayout *)layout
{
    NSArray *pictures = layout.status.pictures;
    NSUInteger picCount = pictures.count;
    
   
    
    // 添加视图直到等于图片数
    while (picCount > self.subviews.count) {
        UIImageView *picView = [UIImageView new];
        picView.contentMode = UIViewContentModeScaleAspectFill;
        picView.clipsToBounds  = YES;

        [self addSubview:picView];
    }
    NSUInteger viewCout = self.subviews.count;
    // 为视图添加图片
    for (int i = 0; i < picCount; i++) {
        // frame
        NSUInteger row = 0;
        NSUInteger column = 0;
        
        if (picCount == 4) { // 4张配图采用田字布局
             row = i / 2;
             column = i % 2;
        } else {
             row = i / 3;
             column = i % 3;
             }
        CGFloat PicW = layout.picSize.width;
        CGFloat PicH = layout.picSize.height;
        CGFloat picX = column * PicW  + (kJKStatusCellPicPadding * column) + kJKStatusCellPadding ;
        CGFloat picY = row *layout.picSize.height + (kJKStatusCellPicPadding * row);
        UIImageView *picView = self.subviews[i];
        picView.frame =  CGRectMake(picX, picY, PicW, PicH);
        // 下载图片
        JKPicture *picture = pictures[i];
        NSURL *picUrl =  [NSURL URLWithString:picture.bmiddleUrl];
        [picView setImageWithURL:picUrl  options:0];
        picView.hidden = NO;
    }
    if (viewCout > picCount) { // 隐藏多余view
        for (int i = 0; i < viewCout - picCount ; i++) {
            UIImageView *view = self.subviews[viewCout - i -1];
            view.hidden = YES;
    }
    
    }
    
}



@end



@implementation JKStatusToolbarView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.height == 0 && frame.size.height == 0) {
        frame.size.height = kJKStatusCellToolbarHeight;
        frame.size.width = kScreenWidth;
    }
    if (self = [super initWithFrame:frame]) {
        //转发按钮
        _repostButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _repostButton.width = self.width / 2;
        _repostButton.height = self.height;
        [self addSubview:_repostButton];
        
        // 评论按钮
        _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentButton.height = self.height;
        _commentButton.width = self.width / 2;
        _commentButton.left = self.width / 2;
        [self addSubview:_commentButton];
        
        // 转发按钮图标
        _repostImageView = [[UIImageView alloc] initWithImage:[JKStatusHelper imageNamed:@"timeline_icon_retweet"]];
        _repostImageView.centerY = self.height / 2;
        [_repostButton addSubview:_repostImageView]; //x未定
        // 转发按钮数字
        _repostLabel = [YYLabel new];
        _repostLabel.height = self.height;
        _repostLabel.ignoreCommonProperties = YES;
        _repostLabel.fadeOnHighlight = NO;
        _repostLabel.fadeOnAsynchronouslyDisplay = NO;
        _repostLabel.displaysAsynchronously = YES;
        _repostLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        [_repostButton addSubview:_repostLabel];// 宽度&x未定
        
        // 评论按钮图标
        _commentImageView = [[UIImageView alloc] initWithImage:[JKStatusHelper imageNamed:@"timeline_icon_comment"]];
        _commentImageView.centerY = self.height / 2;
        [_commentButton addSubview:_commentImageView]; //x未定
        // 评论按钮数字
        _commentLabel = [YYLabel new];
        _commentLabel.height = self.height;
        _commentLabel.ignoreCommonProperties = YES;
        _commentLabel.fadeOnHighlight = NO;
        _commentLabel.fadeOnAsynchronouslyDisplay = NO;
        _commentLabel.displaysAsynchronously = YES;
        _commentLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        [_commentButton addSubview:_commentLabel];// 宽度&x未定
        
        
        UIColor *dark = [UIColor colorWithWhite:0 alpha:0.2];
        UIColor *clear = [UIColor colorWithWhite:0 alpha:0];
        NSArray *colors = @[(id)clear.CGColor,(id)dark.CGColor, (id)clear.CGColor];
        NSArray *locations = @[@0.2, @0.5, @0.8];
        _line1 = [CAGradientLayer layer];
        _line1.colors = colors;
        _line1.locations = locations;
        _line1.startPoint = CGPointMake(0, 0);
        _line1.endPoint = CGPointMake(0, 1);
        _line1.size = CGSizeMake(CGFloatFromPixel(1), self.height);
        _line1.left = _repostButton.right;
        
        
        _topLine = [CALayer layer];
        _topLine.size = CGSizeMake(self.width, CGFloatFromPixel(1));
        _topLine.backgroundColor = UIColorHex(e8e8e8).CGColor;
        
        _bottomLine = [CALayer layer];
        _bottomLine.size = _topLine.size;
        _bottomLine.bottom = self.height;
        _bottomLine.backgroundColor = UIColorHex(e8e8e8).CGColor;
        
        [self addSubview:_repostButton];
        [self addSubview:_commentButton];
        [self.layer addSublayer:_line1];
        [self.layer addSublayer:_line2];
        [self.layer addSublayer:_topLine];
        [self.layer addSublayer:_bottomLine];
    }
    return self;
}

- (void)setWithlayout:(JKStatusLayout *)layout {
    
    _repostLabel.width = layout.toolbarRepostTextWidth;
    _repostLabel.textLayout = layout.toolbarRepostTextLayout;
    _commentLabel.width = layout.toolbarCommentTextWidth;
    _commentLabel.textLayout = layout.toolbarCommentTextLayout;
    
    [self _adjustImageView:_repostImageView label:_repostLabel inButton:_repostButton];
    [self _adjustImageView:_commentImageView label:_commentLabel inButton:_commentButton];
}

- (void)_adjustImageView:(UIImageView *)imageView label:(YYLabel *)label inButton:(UIButton *)button {
    static CGFloat paddingMid = 5;
    CGFloat paddingSide = (button.width - paddingMid - label.width - imageView.width) / 2;
    imageView.left = paddingSide;
    label.right = button.width - paddingSide;
}
@end

@interface JKRetweetView ()


@end

@implementation JKRetweetView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor lightGrayColor];
    _retweetTextLabel = [YYLabel new];
    _retweetTextLabel = [YYLabel new];
    _retweetTextLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _retweetTextLabel.displaysAsynchronously = YES;
    _retweetTextLabel.ignoreCommonProperties = YES;
    _retweetTextLabel.fadeOnAsynchronouslyDisplay = NO;
    _retweetTextLabel.fadeOnHighlight = NO;
    [self addSubview:_retweetTextLabel];
    _picsView = [JKPicsView new];
    [self addSubview:_picsView];
    return self;
}

- (void)setWithLayout:(JKStatusLayout *)layout
{
    _retweetTextLabel.textLayout = layout.retweetLayout;
    [_picsView setWithLayout:layout];
    
}

@end

@implementation JKStatusView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (    self = [super initWithFrame:frame]) {
        // 添加总容器contentView
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        // 添加个人profileView
        _profileView = [JKStatusProfileView new];
        [self addSubview:_profileView];
        
        // 添加正文view
        _textLabel = [YYLabel new];
        _textLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        _textLabel.displaysAsynchronously = YES;
        _textLabel.ignoreCommonProperties = YES;
        _textLabel.fadeOnAsynchronouslyDisplay = NO;
        _textLabel.fadeOnHighlight = NO;
        __weak typeof(self) weakSelf = self;
        _textLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            if ([weakSelf.cell.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
                [weakSelf.cell.delegate cell:weakSelf.cell didClickInLabel:(YYLabel *)containerView textRange:range];
            }
        };
        [_contentView addSubview:_textLabel];
        
        // 配图
        _picView = [JKPicsView new];
        [_contentView addSubview:_picView];
        
       

        
        // 添加toolbarView
        _toolbarView = [JKStatusToolbarView new];
        [_contentView addSubview:_toolbarView];
    }

    return self;
}



- (void)setLayout:(JKStatusLayout *)layout
{
    _layout = layout;
    
    self.width = kScreenWidth;
    self.height = layout.height;
    
    // 设置_contentView(以下所有子view的父view)的frame
    _contentView.width = kScreenWidth;
    _contentView.top = layout.marginTop;
    _contentView.height = layout.height - layout.marginTop - layout.marginBottom;
    
    //
    CGFloat top = 0;
    
    // 头像图标
    [_profileView.avatarView setImageWithURL:layout.status.user.profileImageURL
                                 placeholder:nil
                                     options:0
                                     manager:[JKStatusHelper avatarImageManager]
                                    progress:nil
                                   transform:nil
                                  completion:nil];
    
    _profileView.verifyType = layout.status.user.userVerifyType;
    _profileView.nameLabel.textLayout = layout.nameTextLayout;
    _profileView.sourceLabel.textLayout = layout.sourceTextLayout;
    
    
    
    top += _profileView.height;
    // 设置_textLabel的Frame
    _textLabel.top = top;
    _textLabel.height = layout.textHeight;
    _textLabel.left = kJKStatusCellPadding;
    _textLabel.width = kJKStatusCellContentWidth;
    _textLabel.textLayout = layout.textLayout;
    top += _textLabel.height;

    // 设置_picView的 frame
    if (layout.status.pictures == 0) {
        _picView.hidden = YES;
        _picView.height = 0;
    } else {
        _picView.top = top;
        _picView.height = layout.picsHeight;
        [_picView setWithLayout:layout];
    }
    
  
    
    top += _picView.height;

    _toolbarView.bottom = _contentView.height;
    [_toolbarView setWithlayout:layout];

    
}


@end


@implementation JKStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _statusView = [JKStatusView new];
        _statusView.cell = self;
        [self.contentView addSubview:_statusView];
    }
    return self;
}

- (void)setlayout:(JKStatusLayout *)layout
{
    self.height = layout.height;
    _statusView.layout = layout;
}

@end






















