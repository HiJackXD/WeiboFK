//
//  JKAccount.m
//  Weibo
//
//  Created by HiJack on 16/1/11.
//  Copyright © 2016年 HiJack. All rights reserved.
//

#import "JKAccount.h"

@implementation JKAccount 

+ (instancetype)accountWithDictionary:(NSDictionary *)dictionary;
{
    JKAccount *account = [[JKAccount alloc]init];
    account.access_token = dictionary[@"access_token"];
    account.expires_in = dictionary[@"expires_in"];
    account.uid = dictionary[@"uid"];
    // 存储账号存储的时间(access_Token产生时间)
    account.access_Token_create_date = [NSDate date];
    return account;
}

/**
 *  编码时调用
 */
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeObject:self.expires_in forKey:@"expires_in"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.access_Token_create_date forKey:@"access_Token_create_date"];
    [aCoder encodeObject:self.name forKey:@"name"];
    

}

/**
 *  解码时调用
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]) {
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.expires_in = [aDecoder decodeObjectForKey:@"expires_in"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.access_Token_create_date = [aDecoder decodeObjectForKey:@"access_Token_create_date"];
        self.name = [aDecoder decodeObjectForKey:@"name"];

    }
    return self;
}
@end
