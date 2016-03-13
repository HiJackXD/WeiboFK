//
//  JKJKModel.h
//  Weibo
//
//  Created by HiJack on 16/1/14.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 认证方式
typedef NS_ENUM(NSUInteger, JKUserVerifyType){
    JKUserVerifyTypeNone = 0,     ///< 没有认证
    JKUserVerifyTypeStandard,     ///< 个人认证，黄V
    JKUserVerifyTypeOrganization, ///< 官方认证，蓝V
    JKUserVerifyTypeClub,         ///< 达人认证，红星
};

/// 图片标记
typedef NS_ENUM(NSUInteger, JKPictureBadgeType) {
    JKPictureBadgeTypeNone = 0, ///< 正常图片
    JKPictureBadgeTypeLong,     ///< 长图
    JKPictureBadgeTypeGIF,      ///< GIF
};


/**
 一个图片的元数据
 */
@interface JKPictureMetadata : NSObject
@property (nonatomic, strong) NSURL *url; ///< Full image url
@property (nonatomic, assign) int width; ///< pixel width
@property (nonatomic, assign) int height; ///< pixel height
@property (nonatomic, strong) NSString *type; ///< "WEBP" "JPEG" "GIF"
@property (nonatomic, assign) int cutType; ///< Default:1
@property (nonatomic, assign) JKPictureBadgeType badgeType;
@end


/**
 图片
 */
@interface JKPicture : NSObject
@property (nonatomic, strong) NSString *thumbnailUrl;
@property (nonatomic, strong) NSString *bmiddleUrl;
@property (nonatomic, strong) NSString *originalUrl;




//@property (nonatomic, assign) int photoTag;
//@property (nonatomic, assign) BOOL keepSize; ///< YES:固定为方形 NO:原始宽高比
//@property (nonatomic, strong) JKPictureMetadata *thumbnail;  ///< w:180
//@property (nonatomic, strong) JKPictureMetadata *bmiddle;    ///< w:360 (列表中的缩略图)
//@property (nonatomic, strong) JKPictureMetadata *original;   ///< (查看原图)
//@property (nonatomic, assign) JKPictureBadgeType badgeType;
@end


/**
 用户
 */
@interface JKUser : NSObject
@property (nonatomic, assign) uint64_t userID; ///< id (int)
@property (nonatomic, strong) NSString *idString; ///< id (string)
//@property (nonatomic, assign) int32_t uclass;
@property (nonatomic, strong) NSString *screenName; ///< 友好昵称
@property (nonatomic, strong) NSString *name; ///< 昵称
//@property (nonatomic, strong) NSString *province; ///< 省
//@property (nonatomic, strong) NSString *city;     ///< 市
//@property (nonatomic, strong) NSString *location; ///< 所在地
//@property (nonatomic, strong) NSString *desc; ///< 个人简介
//@property (nonatomic, strong) NSString *url; ///< 博客地址
@property (nonatomic, strong) NSURL *profileImageURL; ///< 头像 50x50 (FeedList)
//@property (nonatomic, strong) NSURL *coverImagePhone;
@property (nonatomic, strong) NSString *profileURL;
//@property (nonatomic, strong) NSString *domain; ///< 个性域名
//@property (nonatomic, strong) NSString *weihao;


@property (nonatomic, assign) int32_t gender; /// 0:none 1:男 2:女
@property (nonatomic, strong) NSString *genderString; /// "m":男 "f":女 "n"未知

@property (nonatomic, strong) NSString *remark; ///< 备注

/*
@property (nonatomic, assign) int32_t followersCount; ///< 粉丝数
@property (nonatomic, assign) int32_t friendsCount; ///< 关注数
@property (nonatomic, assign) int32_t biFollowersCount; ///< 好友数 (双向关注)
@property (nonatomic, assign) int32_t favouritesCount; ///< 收藏数
@property (nonatomic, assign) int32_t statusesCount; ///< 微博数
@property (nonatomic, assign) int32_t topicsCount; ///< 话题数
@property (nonatomic, assign) int32_t blockedCount; ///< 屏蔽数
@property (nonatomic, assign) int32_t pagefriendsCount;
@property (nonatomic, assign) BOOL followMe;
@property (nonatomic, assign) BOOL following;
*/


//@property (nonatomic, strong) NSURL *avatarLarge;     ///< 头像 180*180
//@property (nonatomic, strong) NSURL *avatarHD;        ///< 头像 原图
//@property (nonatomic, strong) NSURL *coverImage;      ///< 封面图 920x300

//@property (nonatomic, assign) int32_t type;
//@property (nonatomic, assign) int32_t ptype;
//@property (nonatomic, assign) int32_t mbtype;
@property (nonatomic, assign) int32_t urank; ///< 微博等级 (LV)
@property (nonatomic, assign) int32_t mbrank; ///< 会员等级 (橙名 VIP)
//@property (nonatomic, assign) int32_t star;
//@property (nonatomic, assign) int32_t level;
//@property (nonatomic, strong) NSDate *createdAt; ///< 注册时间
//@property (nonatomic, assign) BOOL allowAllActMsg;
//@property (nonatomic, assign) BOOL allowAllComment;
//@property (nonatomic, assign) BOOL geoEnabled;
//@property (nonatomic, assign) int32_t onlineStatus;
//@property (nonatomic, assign) int32_t blockWord;
//@property (nonatomic, assign) int32_t blockApp;
//@property (nonatomic, assign) int32_t creditScore; ///< 信用积分
//@property (nonatomic, strong) NSString *lang;
//@property (nonatomic, assign) int32_t userAbility;


@property (nonatomic, assign) BOOL verified; ///< 微博认证 (大V)
@property (nonatomic, assign) int32_t verifiedType;
//@property (nonatomic, assign) int32_t verifiedLevel;
//@property (nonatomic, assign) int32_t verifiedState;
//@property (nonatomic, strong) NSString *verifiedContactEmail;
//@property (nonatomic, strong) NSString *verifiedContactMobile;
//@property (nonatomic, strong) NSString *verifiedTrade;
//@property (nonatomic, strong) NSString *verifiedContactName;
//@property (nonatomic, strong) NSString *verifiedSource;
//@property (nonatomic, strong) NSString *verifiedSourceURL;
//@property (nonatomic, strong) NSString *verifiedReason; ///< 微博认证描述
//@property (nonatomic, strong) NSString *verifiedReasonURL;
//@property (nonatomic, strong) NSString *verifiedReasonModified;

@property (nonatomic, assign) JKUserVerifyType userVerifyType;


@end


/**
 微博
 */
@interface JKStatus : NSObject
@property (nonatomic, strong) NSDate *createdAt; ///< 发布时间
@property (nonatomic, assign) uint64_t statusID; ///< id (number)
@property (nonatomic, strong) NSString *idstr; ///< id (string)
@property (nonatomic, strong) NSString *mid;
@property (nonatomic, strong) NSString *rid;

@property (nonatomic, strong) NSString *text; ///< 正文
@property (nonatomic, strong) NSString *source; ///< 来自 XXX
@property (nonatomic, assign) int32_t sourceType;
@property (nonatomic, assign) int32_t sourceAllowClick; ///< 来源是否允许点击
@property (nonatomic, assign) BOOL favorited; ///< 是否收藏
@property (nonatomic, assign) BOOL truncated;  ///< 是否截断
@property (nonatomic, strong) NSString *inReplyToScreenName;
@property (nonatomic, strong) NSString *inReplyToStatusId;
@property (nonatomic, strong) NSString *inReplyToUserId;



@property (nonatomic, strong) JKUser *user;

@property (nonatomic, strong) NSURL *thumbnailPic; ///< 缩略图
@property (nonatomic, strong) NSURL *bmiddlePic; ///< 中图
@property (nonatomic, strong) NSURL *originalPic; ///< 大图

@property (nonatomic, strong) JKStatus *retweetedStatus; ///转发微博

@property (nonatomic, strong) NSArray<JKPicture*> *pictures; /// Array<NSString>



@property (nonatomic, assign) int32_t repostsCount; ///< 转发数
@property (nonatomic, assign) int32_t commentsCount; ///< 评论数

@property (nonatomic, assign) BOOL isLongText; ///< 是否长微博

@property (nonatomic, assign) int32_t mlevel; ///< VIP登基
@property (nonatomic, strong) NSDictionary *visible;
@property (nonatomic, assign) int32_t bizFeature;
@property (nonatomic, strong) NSArray *darwinTags;
@property (nonatomic, strong) NSArray *hotWeiboTags;


@property (nonatomic, strong) NSDictionary *geo;
@property (nonatomic, strong) NSArray *annotations; ///< 地理位置





@end


/**
 一次API请求的数据
 */
@interface JKTimelineItem : NSObject
@property (nonatomic, strong) NSArray *ad;
@property (nonatomic, strong) NSArray *advertises;
@property (nonatomic, strong) NSString *gsid;
@property (nonatomic, assign) int32_t interval;
@property (nonatomic, assign) int32_t uveBlank;
@property (nonatomic, assign) int32_t hasUnread;
@property (nonatomic, assign) int32_t totalNumber;
@property (nonatomic, strong) NSString *sinceID;
@property (nonatomic, strong) NSString *maxID;
@property (nonatomic, strong) NSString *previousCursor;
@property (nonatomic, strong) NSString *nextCursor;
@property (nonatomic, strong) NSArray *statuses;
/*
 groupInfo
 trends
 */
@end










//******************************************************/
//*************************表情**************************/
//******************************************************/

@class  JKEmotionGroup;

typedef NS_ENUM(NSUInteger, JKEmotionType)
{
    JKEmotionGroupImage = 0, ///< 图片表情
    JKEmotionGroupEmoji = 1 ///< emoji表情
};

@interface JKEmotion : NSObject
@property (nonatomic, copy) NSString *chs;  ///< [微笑]
@property (nonatomic, copy) NSString *cht;
@property (nonatomic, copy) NSString *png;  ///< d_hehe.png
@property (nonatomic, copy) NSString *code;  ///< 0x1f601
@property (nonatomic, assign) JKEmotionType type; ///< emoji或图片表情
@property (nonatomic, weak) JKEmotionGroup *group; ///< 所在分组
@end



@interface JKEmotionGroup : NSObject
@property (nonatomic, copy) NSString *groupID; ///< com.sina.default
@property (nonatomic, copy) NSString *groupNameCN; ///< emoji/默认/浪小花
@property (nonatomic, strong) NSArray<JKEmotion *> *emotions;

@end









