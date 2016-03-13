//
//  JKJKModel.m
//  Weibo
//
//  Created by HiJack on 16/1/14.
//  Copyright © 2016年 HiJack. All rights reserved.
//


#import "JKStatusModel.h"
#import "JKStatusHelper.h"

@implementation JKUser
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"userID" : @"id",
             @"idString" : @"idstr",
             @"genderString" : @"gender",
             @"verifiedTrade" : @"verified_trade",
             @"profileImageURL" : @"profile_image_url",
             @"screenName" : @"screen_name",
             @"verifiedType" : @"verified_type",
             };
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    // 自动 model-mapper 不能完成的，这里可以进行额外处理
    _gender = 0;
    if ([_genderString isEqualToString:@"m"]) {
        _gender = 1;
    } else if ([_genderString isEqualToString:@"f"]) {
        _gender = 2;
    }
    
    // 这个不一定准。。
    if (_verifiedType == 0) {
        _userVerifyType = JKUserVerifyTypeStandard;
    } else if (_verifiedType == 220) {
        _userVerifyType = JKUserVerifyTypeClub;
    } else if (_verifiedType == 2 ||_verifiedType == 3 || _verifiedType == 4 ) {
        _userVerifyType = JKUserVerifyTypeOrganization;
    } else {
        _userVerifyType = JKUserVerifyTypeNone;
    }
    return YES;
}
@end

@implementation JKPicture

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"thumbnailUrl" : @ "thumbnail_pic"};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSString *urlString = _thumbnailUrl;
    _bmiddleUrl = [urlString stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle" options:NSCaseInsensitiveSearch range:urlString.rangeOfAll];
    _originalUrl = [urlString stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large" options:NSCaseInsensitiveSearch range:urlString.rangeOfAll];
    return YES;
}

        //+ (NSArray *)modelPropertyBlacklist {
        //    return @[@"thumbnail_pic",
        //             @"bmiddle_pic",
        //             @"original_pic",
        //             ];
        //}
@end

@implementation JKStatus
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"statusID" : @"id",
             @"createdAt" : @"created_at",
             @"attitudesStatus" : @"attitudes_status",
             @"sourceType" : @"source_type",
             @"commentsCount" : @"comments_count",
             @"recomState" : @"recom_state",
             @"sourceAllowClick" : @"source_allowclick",
             @"bizFeature" : @"biz_feature",
             @"retweetedStatus" : @"retweeted_status",
             @"inReplyToStatusId" : @"in_reply_to_status_id",
             @"repostsCount" : @"reposts_count",
             @"attitudesCount" : @"attitudes_count",
             @"darwinTags" : @"darwin_tags",
             @"userType" : @"userType",
             @"inReplyToStatusId" : @"in_reply_to_status_id",
             @"inReplyToUserId" : @"in_reply_to_user_id",
             @"inReplyToScreenName" : @"in_reply_to_screen_name",
             @"thumbnailPic" : @"thumbnail_pic",
             @"bmiddlePic" : @"bmiddle_pic",
             @"originalPic" : @"original_pic",
             @"pictures" : @"pic_urls"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pictures" : [JKPicture class]};
}


@end

@implementation JKTimelineItem
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"hasVisible" : @"hasvisible",
             @"previousCursor" : @"previous_cursor",
             @"uveBlank" : @"uve_blank",
             @"hasUnread" : @"has_unread",
             @"totalNumber" : @"total_number",
             @"maxID" : @"max_id",
             @"sinceID" : @"since_id",
             @"nextCursor" : @"next_cursor"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"statuses" : [JKStatus class]};
}
@end

@implementation JKEmotion
+ (NSArray *)modelPropertyBlacklist {
    return @[@"group"];
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
       return YES;
    
}
@end


@implementation JKEmotionGroup

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"groupID" : @"id",
             @"groupNameCN" : @"group_name_cn",
             @"emotions" : @"emoticons"
            };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"emotions" : [JKEmotion class]};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    [_emotions enumerateObjectsUsingBlock:^(JKEmotion * emotion, NSUInteger idx, BOOL *stop) {
        // 表情分组
        emotion.group = self;
        // 表情分类(图片/emoji)
        if ((emotion.chs.length && emotion.png.length) ) { // 图片表情
            NSString *groupPath = [[[JKStatusHelper emotionBundle] bundlePath] stringByAppendingPathComponent:_groupID];
            emotion.png = [groupPath stringByAppendingPathComponent:emotion.png];
            emotion.type = JKEmotionGroupImage;
        } else if (emotion.code.length) { // emoji表情
            emotion.type = JKEmotionGroupEmoji;
            // 将emoji16进制字符串转换为emoji可直接显示字符串
            NSNumber *num = [NSNumber numberWithString:emotion.code];
            NSString *text = [NSString stringWithUTF32Char:num.unsignedIntValue];
            emotion.code = text;
        }
       
    
    }];
    return YES;
}

@end
