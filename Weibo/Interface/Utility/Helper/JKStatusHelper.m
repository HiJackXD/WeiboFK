//
//  JKStatusHelper.m
//  Weibo
//
//  Created by HiJack on 16/1/25.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import "JKStatusHelper.h"

@implementation JKStatusHelper

+ (NSBundle *)bundle {
    static NSBundle *bundel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ResourceWeibo" ofType:@"bundle"];
        bundel = [NSBundle bundleWithPath:path];
    });
    return bundel;
}

+ (YYMemoryCache *)imageCache {
    static YYMemoryCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [YYMemoryCache new];
        cache.shouldRemoveAllObjectsOnMemoryWarning = NO;
        cache.shouldRemoveAllObjectsWhenEnteringBackground = NO;
        cache.name = @"JKStatusImageCache";
    });
    return cache;
}

+ (UIImage *)imageNamed:(NSString *)name
{
    if (!name) return nil;
    UIImage *image = [[self imageCache] objectForKey:name];
    if (image) return image;
    NSString *ext = name.pathExtension;
    if (ext.length == 0) ext = @"png";
    NSString *path = [[self bundle] pathForScaledResource:name ofType:ext];
    if (!path) return nil;
    image = [UIImage imageWithContentsOfFile:path];
    return image;
    
}
    


/**
 *  头像webImageManager(储存位置:caches/weibo.avatar,队列:全局共享队列)
 */
+ (YYWebImageManager *)avatarImageManager {
    static YYWebImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[UIApplication sharedApplication].cachesPath stringByAppendingPathComponent:@"weibo.avatar"];
        YYImageCache *cache = [[YYImageCache alloc] initWithPath:path];
        manager = [[YYWebImageManager alloc] initWithCache:cache queue:[YYWebImageManager sharedManager].queue];
        manager.sharedTransformBlock = ^(UIImage *image, NSURL *url) {
            if (!image) return image;
            return [image imageByRoundCornerRadius:100]; // a large value
        };
    });
    return manager;
}

+ (NSString *)stringWithTimelineDate:(NSDate *)date {
    if (!date) return @"";
    
    static NSDateFormatter *formatterYesterday;
    static NSDateFormatter *formatterSameYear;
    static NSDateFormatter *formatterFullDate;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatterYesterday = [[NSDateFormatter alloc] init];
        [formatterYesterday setDateFormat:@"昨天 HH:mm"];
        
        formatterSameYear = [[NSDateFormatter alloc] init];
        [formatterSameYear setDateFormat:@"M-d"];
        
        formatterFullDate = [[NSDateFormatter alloc] init];
        [formatterFullDate setDateFormat:@"yy-M-dd"];
    });
    
    NSDate *now = [NSDate new];
    NSTimeInterval delta = now.timeIntervalSince1970 - date.timeIntervalSince1970;
    if (delta < -60 * 10) { // 本地时间有问题
        return [formatterFullDate stringFromDate:date];
    } else if (delta < 60 * 10) { // 10分钟内
        return @"刚刚";
    } else if (delta < 60 * 60) { // 1小时内
        return [NSString stringWithFormat:@"%d分钟前", (int)(delta / 60.0)];
    } else if (date.isToday) {
        return [NSString stringWithFormat:@"%d小时前", (int)(delta / 60.0 / 60.0)];
    } else if (date.isYesterday) {
        return [formatterYesterday stringFromDate:date];
    } else if (date.year == now.year) {
        return [formatterSameYear stringFromDate:date];
    } else {
        return [formatterFullDate stringFromDate:date];
    }
}

+ (NSString *)shortedNumberDesc:(NSUInteger)number {
    if (number < 9999) { // <1万
        return [NSString stringWithFormat:@"%ld",number];
    } else if (number < 9999999) { // < 1千万
        return [NSString stringWithFormat:@"%ld万",number/10000];
    } else { // >1千万
        return [NSString stringWithFormat:@"%ld千万",number / 10000000];
    }
}

+ (NSRegularExpression *)regexAt {
    static NSRegularExpression *regexAt;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regexAt = [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FFF]+" options:0 error:nil];
    });
    return regexAt;
}

+ (NSRegularExpression *)regexUrl
{
    static NSRegularExpression *urlRegex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        urlRegex = [NSRegularExpression regularExpressionWithPattern: @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"  options:0 error:nil];
    });
    return urlRegex;
}

+ (NSRegularExpression *)regexTopic
{
    static  NSRegularExpression *topicRegex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        topicRegex = [NSRegularExpression regularExpressionWithPattern:@"#[-_a-zA-Z0-9\u4E00-\u9FFF]+#" options:0 error:nil];

    });
    return topicRegex;
}

+ (NSRegularExpression *)regexEmotion {
    static NSRegularExpression *emotionRegex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emotionRegex = [NSRegularExpression regularExpressionWithPattern:@"[.+]" options:0 error:nil];
    });
    return emotionRegex;
}
    
    
    
@end
