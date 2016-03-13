//
//  JKAccount.h
//  Weibo
//
//  Created by HiJack on 16/1/11.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKAccount : NSObject <NSCoding>
/** string OAuth授权口令 */
@property (copy, nonatomic) NSString *access_token;

/** access_Token生成日期 */
@property (strong, nonatomic) NSDate *access_Token_create_date;

/** string 账号授权过期时间 */
@property (copy, nonatomic) NSNumber *expires_in;


/** string 微博账号数字ID */
@property (copy, nonatomic) NSString *uid;

/** string 微博账号昵称 */
@property (copy, nonatomic) NSString *name;



+ (instancetype)accountWithDictionary:(NSDictionary *)dictionary;

@end
