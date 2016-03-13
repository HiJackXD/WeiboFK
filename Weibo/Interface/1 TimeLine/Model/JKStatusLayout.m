//
//  JKStatusLayout.m
//  Weibo
//
//  Created by HiJack on 16/1/25.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import "JKStatusLayout.h"
#import "JKStatusHelper.h"
#import "WBModel.h"


@implementation WBTextLinePositionModifier

-(instancetype)init
{
    if(self = [super init])
    {
        if (kiOS9Later) {
            _lineHeightMultiple = 1.34;
        } else {
            _lineHeightMultiple = 1.3125;
        }
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    WBTextLinePositionModifier *one = [self.class new];
    one ->_font = _font;
    one ->_paddingTop = _paddingTop;
    one ->_paddingBottom = _paddingBottom;
    one ->_lineHeightMultiple = _lineHeightMultiple;
    return one;
}

- (void)modifyLines:(NSArray *)lines fromText:(NSAttributedString *)text inContainer:(YYTextContainer *)container;
{
    CGFloat ascent = _font.pointSize * 0.86;
    
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    for (YYTextLine *line in lines) {
        CGPoint position = line.position;
        position.y = _paddingTop + ascent + line.row  * lineHeight;
        line.position = position;
    }

    
}


- (CGFloat)heightForLineCount:(NSUInteger)lineCount
{
   
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    
    return  _paddingTop + _paddingBottom + _font.pointSize + lineHeight * (lineCount - 1);
    
}

@end



@implementation JKStatusLayout

- (instancetype)initWithStatus:(JKStatus *)status
{
    if (self = [super init]) {
        _status = status;
        [self layout];
    }
    return self;

}

- (void)layout
{
    [self _layout];
    
}

- (void)_layout
{
    _marginTop = kJKStatusCellTopMargin;
    _marginBottom = kJKStatusCellToolbarBottomMargin;
    _textHeight = 0;
    _picsHeight = 0;
    _toolbarHeight = kJKStatusCellToolbarHeight;

    
    
    [self _layoutProfile];
    [self _layoutText];
    [self _layoutPic];
    [self _layoutRepost];
    [self _layoutRepostPic];
    [self _layoutToolbar];
    
    _height = 0;
    _height += _marginTop;
    _height += _profileHight;
    _height += _textHeight;
    _height += _picsHeight;
    _height += _toolbarHeight;
    _height += _marginBottom;
}



- (void) _layoutProfile
{
    _profileHight = kJKStatusCellProfileHeight;
    _nameTextLayout = nil;
    _sourceTextLayout = nil;
    
    [self _layoutName];
    [self _layoutSource];
    
    
}


- (void)_layoutName
{
    JKUser *user = _status.user;
    NSString *nameString = user.name;
    UIFont *font = [UIFont systemFontOfSize:kJKStatusCellNameFontSize];
    NSMutableAttributedString *nameAttributeString = nil;
    if (user.mbrank > 0) {
        UIImage *yelllowVImage = [JKStatusHelper imageNamed:[NSString stringWithFormat:@"common_icon_membership_level%d",user.mbrank]];
        NSMutableAttributedString  *attachment = [NSMutableAttributedString attachmentStringWithContent:yelllowVImage
                                                                                            contentMode:UIViewContentModeScaleAspectFill
                                                                                         attachmentSize:yelllowVImage.size
                                                                                            alignToFont:font
                                                                                              alignment:YYTextVerticalAlignmentCenter];
        nameString = [nameString stringByAppendingString:@" "];
        nameAttributeString = [[NSMutableAttributedString alloc]initWithString:nameString];
        [nameAttributeString appendAttributedString:attachment];
    }
    else {
        nameAttributeString = [[NSMutableAttributedString alloc]initWithString:nameString];
        
    }
    nameAttributeString.color = user.mbrank > 0 ? kJKStatusCellNameVipColor : kJKStatusCellNameNormalColor;
    nameAttributeString.font = font;
    /*
     nameAttributeString.lineBreakMode = NSLineBreakByCharWrapping;
     */
    
    if (nameAttributeString.length == 0) return;
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kJKStatusCellNameWidth, 9999)];
    container.maximumNumberOfRows = 1;
    _nameTextLayout = [YYTextLayout layoutWithContainer:container text:nameAttributeString];
}


- (void)_layoutSource {
    
    static NSDateFormatter *todayFormatter;
    static NSDateFormatter *yesterdayFormatter;
    static NSDateFormatter *thisYearFormatter;
    static NSDateFormatter *fullDateFormatter;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        todayFormatter = [[NSDateFormatter alloc] init];
        todayFormatter.dateFormat = @"今天 HH:mm";
        
        yesterdayFormatter = [[NSDateFormatter alloc] init];
        yesterdayFormatter.dateFormat = @"昨天 HH:mm";
        
        thisYearFormatter = [[NSDateFormatter alloc] init];
        thisYearFormatter.dateFormat = @"M-d";
        
        fullDateFormatter = [[NSDateFormatter alloc] init];
        fullDateFormatter.dateFormat = @"yy-M-d";
    });
    
    NSMutableAttributedString *sourceText = [NSMutableAttributedString new]; ///< 来源富文本
    // 时间
    NSDate *date = _status.createdAt;
    NSDate *nowDate = [NSDate date];
    CGFloat timeInterval = nowDate.timeIntervalSinceReferenceDate - date.timeIntervalSinceReferenceDate;
    NSString *dateString ; ///< 微博创建日期string
    if (!date) dateString = @"";
    if (timeInterval < -60 * 10) { // 系统时间错误
        dateString = [fullDateFormatter stringFromDate:date];
    } else if (timeInterval < 60 ) {
        dateString = @"刚刚";
    } else if (timeInterval < 60 * 10) {
        dateString = [NSString stringWithFormat:@"%d分钟前",(int)(timeInterval / 60.0 )];
    } else if (timeInterval < 60 * 60 * 24) { // 今天
        dateString = [todayFormatter stringFromDate:date];
    } else if (timeInterval < 60 * 60 * 24 * 2) { // 昨天
         dateString = [yesterdayFormatter stringFromDate:date];
    } else if (date.year == nowDate.year) {
        dateString = [thisYearFormatter stringFromDate:date];
    } else {
        dateString = [fullDateFormatter stringFromDate:date];
    }
    if (dateString.length) {
        NSMutableAttributedString *timeText = [[NSMutableAttributedString alloc] initWithString:dateString];
        timeText.font = [UIFont systemFontOfSize:kJKStatusCellSourceFontSize];
        timeText.color = kJKStatusCellTimeNormalColor;
        [sourceText appendAttributedString:timeText];
        
    }
    // 来源
    if (_status.source.length) {
        static NSRegularExpression *sourceRegex;
        // <a href=\"http://weibo.com/\" rel=\"nofollow\">微博 weibo.com</a>   **匹配文字:"微博 weibo.com" 匹配规则 "> <"
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sourceRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<=>).+(?=<)" options:0 error:nil];
        });
        NSTextCheckingResult *sourceResult;
        NSString *sourceString;
        sourceResult = [sourceRegex firstMatchInString:_status.source options:0 range:NSMakeRange(0, _status.source.length)];
        sourceString = [_status.source substringWithRange:sourceResult.range];
        
        if (sourceString.length) {
            NSMutableAttributedString *fromText = [NSMutableAttributedString new];
            [fromText  appendString:[NSString stringWithFormat:@"来自 %@",sourceString]];
            fromText .font = [UIFont systemFontOfSize:kJKStatusCellSourceFontSize];
            fromText .color = kJKStatusCellTimeNormalColor;
           
            [sourceText appendAttributedString:fromText];
        }
    }
    
    if (sourceText.length == 0) {
        _sourceTextLayout = nil;
    } else {
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kJKStatusCellNameWidth, CGFLOAT_MAX)];
        container.maximumNumberOfRows = 1;
        _sourceTextLayout = [YYTextLayout layoutWithContainer:container text:sourceText];
    }
    
    
    
    
    
}

- (void)_layoutText
{
    _textHeight = 0;
    _textLayout = nil;
    
    
    NSMutableString *string = _status.text.mutableCopy;
  
    // 字体
    UIFont *font = [UIFont systemFontOfSize:kJKStatusCellTextFontSize];
    // 高粱状态下的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = kJKStatusCellTextHighlightBackgroundColor;
    
    // 统一所有文本为普通字体，颜色
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:string];
    text.font = font;
    text.color = kJKStatusCellTextNormalColor;
    // 高亮@
    NSArray *atResults = [[JKStatusHelper regexAt] matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *at in atResults) {
        if (at.range.location == NSNotFound) continue;
        if ([text attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil) {
                [text setColor:kJKStatusCellTextHighlightColor range:at.range];
        }
    }
    // 高亮url
    NSArray *urlResults = [[JKStatusHelper regexUrl] matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *url in urlResults) {
        if (url.range.location == NSNotFound) continue;
        if ([text attribute:YYTextHighlightAttributeName atIndex:url.range.location] == nil) {
            [text setColor:kJKStatusCellTextHighlightColor range:url.range];
        }
    }
    
    // 高亮topic
    NSArray *topicResults = [[JKStatusHelper regexTopic] matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *url in topicResults) {
        if (url.range.location == NSNotFound) continue;
        if ([text attribute:YYTextHighlightAttributeName atIndex:url.range.location] == nil) {
            [text setColor:kJKStatusCellTextHighlightColor range:url.range];
        }
    }
    
     //转换表情
    NSArray *emotionResults = [[JKStatusHelper regexEmotion] matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    NSUInteger emoClipLength = 0;
    for (NSTextCheckingResult *emo in emotionResults) {
        
        if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
        NSRange range = emo.range;
        range.location -= emoClipLength;
        if ([text attribute:YYTextHighlightAttributeName atIndex:range.location]) continue;
        if ([text attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
        NSString *emoString = [text.string substringWithRange:range];

        NSString *imagePath = [JKStatusHelper emotionDic][emoString];
        UIImage *image = [JKStatusHelper imageWithPath:imagePath];
        if (!image) continue;
        NSAttributedString *emoText = [NSAttributedString attachmentStringWithEmojiImage:image fontSize:[UIFont systemFontOfSize:kJKStatusCellTextFontSize].pointSize];
        [text replaceCharactersInRange:range withAttributedString:emoText];
        emoClipLength += range.length - 1;
    }

    
    if (text.length == 0) return;
    
    // 文本line位置修改
    WBTextLinePositionModifier *modifier = [WBTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:kJKStatusCellTextFontSize];
    modifier.paddingTop = kJKStatusCellPaddingText;
    modifier.paddingBottom = kJKStatusCellPaddingText;
    
    // 创建文本容器对象
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kJKStatusCellContentWidth, MAXFLOAT);
    container.linePositionModifier = modifier;
    
    // 输出文本布局
    _textLayout = [YYTextLayout layoutWithContainer:container text:text];
    
    // 输出文本高度
    _textHeight = [modifier heightForLineCount:_textLayout.rowCount];
    
}

- (void)_layoutPic
{
    CGSize picSize = CGSizeZero;
    CGFloat picsHeight = 0;
  
    
   NSUInteger num = _status.pictures.count;
    switch (num) {
        case 0:
            break;
        case 1:
            picSize.height = picSize.width = (kJKStatusCellContentWidth - kJKStatusCellPicPadding)  / 2;
            picsHeight = picSize.height ;
            
            break;
        case 2: case 3: {
            picSize.height = picSize.width = (kJKStatusCellContentWidth - kJKStatusCellPicPadding * (num -1))   / num;
            picsHeight = picSize.height ;
            
            break;
        }
        case 4: case 5: case 6: {
           
            picSize.height = picSize.width = (kJKStatusCellContentWidth - (kJKStatusCellPicPadding * 2)) / 3;
            picsHeight = picSize.height *2 + kJKStatusCellPicPadding * 2;
           
            break;
        }
        default: { // 7, 8, 9
            picSize.height = picSize.width = (kJKStatusCellContentWidth - (kJKStatusCellPicPadding * 2)) / 3;
            picsHeight = picSize.height *3 + kJKStatusCellPicPadding * 2;
        }
    }
    
    _picSize = picSize;
    _picsHeight = picsHeight;
    
    }

- (void)_layoutRepost
{
    _retweetHeight = 0;
    _retweetLayout = nil;
    
    
    NSMutableString *string = _status.retweetedStatus.text.mutableCopy;
    
    // 字体
    UIFont *font = [UIFont systemFontOfSize:kJKStatusCellTextFontSize];
    // 高粱状态下的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = kJKStatusCellTextHighlightBackgroundColor;
    
    // 统一所有文本为普通字体，颜色
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:string];
    text.font = font;
    text.color = kJKStatusCellTextNormalColor;
    // 高亮@
    NSArray *atResults = [[JKStatusHelper regexAt] matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *at in atResults) {
        if (at.range.location == NSNotFound) continue;
        if ([text attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil) {
            [text setColor:kJKStatusCellTextHighlightColor range:at.range];
        }
    }
    // 高亮url
    NSArray *urlResults = [[JKStatusHelper regexUrl] matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *url in urlResults) {
        if (url.range.location == NSNotFound) continue;
        if ([text attribute:YYTextHighlightAttributeName atIndex:url.range.location] == nil) {
            [text setColor:kJKStatusCellTextHighlightColor range:url.range];
        }
    }
    
    // 高亮topic
    NSArray *topicResults = [[JKStatusHelper regexTopic] matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *url in topicResults) {
        if (url.range.location == NSNotFound) continue;
        if ([text attribute:YYTextHighlightAttributeName atIndex:url.range.location] == nil) {
            [text setColor:kJKStatusCellTextHighlightColor range:url.range];
        }
    }
    
    //转换表情
    NSArray *emotionResults = [[JKStatusHelper regexEmotion] matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    NSUInteger emoClipLength = 0;
    for (NSTextCheckingResult *emo in emotionResults) {
        
        if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
        NSRange range = emo.range;
        range.location -= emoClipLength;
        if ([text attribute:YYTextHighlightAttributeName atIndex:range.location]) continue;
        if ([text attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
        NSString *emoString = [text.string substringWithRange:range];
        
        NSString *imagePath = [JKStatusHelper emotionDic][emoString];
        UIImage *image = [JKStatusHelper imageWithPath:imagePath];
        if (!image) continue;
        NSAttributedString *emoText = [NSAttributedString attachmentStringWithEmojiImage:image fontSize:[UIFont systemFontOfSize:kJKStatusCellTextFontSize].pointSize];
        [text replaceCharactersInRange:range withAttributedString:emoText];
        emoClipLength += range.length - 1;
    }
    if (text.length == 0) return;
    
    // 文本line位置修改
    WBTextLinePositionModifier *modifier = [WBTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:kJKStatusCellTextFontSize];
    modifier.paddingTop = kJKStatusCellPaddingText;
    modifier.paddingBottom = kJKStatusCellPaddingText;
    
    // 创建文本容器对象
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kJKStatusCellContentWidth, MAXFLOAT);
    container.linePositionModifier = modifier;
    
    // 输出文本布局
    _retweetLayout = [YYTextLayout layoutWithContainer:container text:text];
    
    // 输出文本高度
    _retweetHeight = [modifier heightForLineCount:_textLayout.rowCount];

}

- (void)_layoutToolbar
{
    static UIFont *font;
    static YYTextContainer *container;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        font = [UIFont systemFontOfSize:kJKStatusCellToolbarFontSize];
        container = [YYTextContainer new];
        container.size = CGSizeMake(kScreenWidth, kJKStatusCellToolbarHeight);
        container.maximumNumberOfRows = 1;
    });
    
    
    NSMutableAttributedString *repostText = [[NSMutableAttributedString alloc] initWithString:_status.repostsCount <= 0 ? @"转发" : [JKStatusHelper shortedNumberDesc:_status.repostsCount ]] ;
    repostText.font = font;
    repostText.color = kJKStatusCellToolbarTitleColor;
    _toolbarRepostTextLayout = [YYTextLayout layoutWithContainer:container text:repostText];
    _toolbarRepostTextWidth = _toolbarRepostTextLayout.textBoundingRect.size.width;
    
    NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:(_status.commentsCount <=0) ? @"评论" : [JKStatusHelper shortedNumberDesc:_status.commentsCount]];
    commentText.font = font;
    commentText.color = kJKStatusCellToolbarTitleColor;
    _toolbarCommentTextLayout = [YYTextLayout layoutWithContainer:container text:commentText];
    _toolbarCommentTextWidth = _toolbarCommentTextLayout.textBoundingRect.size.width;
    
    
}

-



@end
