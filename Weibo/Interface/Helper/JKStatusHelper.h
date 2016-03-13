//
//  JKStatusHelper.h
//  Weibo
//
//  Created by HiJack on 16/1/25.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import "YYKit.h"
#import "JKStatusModel.h"

@interface JKStatusHelper : NSObject

/**微博图片 cache*/
+ (YYMemoryCache *)imageCache;

/**从微博 bundle 里获取图片 (有缓存)*/
+ (UIImage *)imageNamed:(NSString *)name;

/**从path创建图片 (有缓存)*/
+ (UIImage *)imageWithPath:(NSString *)path;

/**圆角头像的 manager*/
+ (YYWebImageManager *)avatarImageManager;

/**微博创建日期*/
+ (NSString *)stringWithTimelineDate:(NSDate *)date;

/**数字描述(万,千万)*/
+ (NSString *)shortedNumberDesc:(NSUInteger)number;

/**@用户名 正则匹配*/
+ (NSRegularExpression *)regexAt;

/**url 正则匹配*/
+ (NSRegularExpression *)regexUrl;

/**topic 正则匹配*/
+ (NSRegularExpression *)regexTopic;

/**emotion 正则匹配*/
+ (NSRegularExpression *)regexEmotion;


/** 表情bundle*/
+ (NSBundle *)emotionBundle;

/** 表情字典*/
+ (NSDictionary *)emotionDic;

+ (NSArray *)emoticonGroups;

@end
